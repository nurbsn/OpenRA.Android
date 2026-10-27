using System;
using System.IO;
using Java.Interop;
using OpenRA.Platforms.Default;

namespace OpenRA.Android
{
	public static class AndroidGameBridge
	{
		public static void RegisterJniMethods()
		{
			try
			{
				Console.WriteLine("[AndroidGameBridge] Registering JNI methods for org.libsdl.app.SDLActivity...");
				var sdlClass = JniEnvironment.Types.FindClass("org/libsdl/app/SDLActivity");
				var methods = new[]
				{
					new JniNativeMethodRegistration(
						"runManagedGame",
						"()V",
						(Action<IntPtr, IntPtr>)RunManagedGame)
				};
				JniEnvironment.Types.RegisterNatives(sdlClass, methods, methods.Length);
				Console.WriteLine("[AndroidGameBridge] Successfully registered JNI methods for SDLActivity!");
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[AndroidGameBridge] Error registering JNI methods: {ex}");
			}
		}

		public static void ApplyImmersiveFullscreen()
		{
			try
			{
				Console.WriteLine("[AndroidGameBridge] Applying immersive sticky fullscreen mode...");
				var classRef = global::Android.Runtime.JNIEnv.FindClass("org/libsdl/app/SDLActivity");
				if (classRef != IntPtr.Zero)
				{
					var getContextMethod = global::Android.Runtime.JNIEnv.GetStaticMethodID(classRef, "getContext", "()Landroid/content/Context;");
					if (getContextMethod != IntPtr.Zero)
					{
						var activityPtr = global::Android.Runtime.JNIEnv.CallStaticObjectMethod(classRef, getContextMethod);
						if (activityPtr != IntPtr.Zero)
						{
							var activity = Java.Lang.Object.GetObject<global::Android.App.Activity>(activityPtr, global::Android.Runtime.JniHandleOwnership.DoNotTransfer);
							activity?.RunOnUiThread(() =>
							{
								try
								{
									var window = activity.Window;
									if (window != null)
									{
										window.AddFlags(global::Android.Views.WindowManagerFlags.Fullscreen | global::Android.Views.WindowManagerFlags.KeepScreenOn);
										window.ClearFlags(global::Android.Views.WindowManagerFlags.ForceNotFullscreen);

										if (global::Android.OS.Build.VERSION.SdkInt >= global::Android.OS.BuildVersionCodes.R)
										{
											window.SetDecorFitsSystemWindows(false);
											var controller = window.InsetsController;
											if (controller != null)
											{
												controller.Hide(global::Android.Views.WindowInsets.Type.SystemBars());
												controller.SystemBarsBehavior = (int)global::Android.Views.WindowInsetsControllerBehavior.ShowTransientBarsBySwipe;
											}
										}
										else
										{
											var flags = global::Android.Views.SystemUiFlags.ImmersiveSticky
												| global::Android.Views.SystemUiFlags.Fullscreen
												| global::Android.Views.SystemUiFlags.HideNavigation
												| global::Android.Views.SystemUiFlags.LayoutStable
												| global::Android.Views.SystemUiFlags.LayoutFullscreen
												| global::Android.Views.SystemUiFlags.LayoutHideNavigation;
											window.DecorView.SystemUiVisibility = (global::Android.Views.StatusBarVisibility)flags;
										}
									}
								}
								catch (Exception ex)
								{
									Console.WriteLine($"[AndroidGameBridge] Failed to configure window insets: {ex.Message}");
								}
							});
						}
					}

					var setWindowStyle = global::Android.Runtime.JNIEnv.GetStaticMethodID(classRef, "setWindowStyle", "(Z)V");
					if (setWindowStyle != IntPtr.Zero)
						global::Android.Runtime.JNIEnv.CallStaticVoidMethod(classRef, setWindowStyle, new global::Android.Runtime.JValue(true));
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[AndroidGameBridge] ApplyImmersiveFullscreen error: {ex.Message}");
			}
		}

		public static void RunManagedGame(IntPtr env, IntPtr clazz)
		{
			Console.WriteLine("[AndroidGameBridge] runManagedGame called from SDLThread!");
			try
			{
				ApplyImmersiveFullscreen();
				Game.OnShellmapLoaded += ApplyImmersiveFullscreen;

				var context = global::Android.App.Application.Context;
				NativeLibraryResolver.Initialize();

				string baseDir = null;
				try
				{
					var ext = context.GetExternalFilesDir(null)?.AbsolutePath;
					if (!string.IsNullOrEmpty(ext))
					{
						var testDir = Path.Combine(ext, "Game");
						Directory.CreateDirectory(testDir);
						baseDir = ext;
					}
				}
				catch (Exception ex)
				{
					Console.WriteLine($"[AndroidGameBridge] Failed to use external files dir, falling back to internal: {ex.Message}");
				}

				if (string.IsNullOrEmpty(baseDir))
					baseDir = context.FilesDir.AbsolutePath;

				var gameDir = Path.Combine(baseDir, "Game");
				var supportDir = Path.Combine(baseDir, "Support");

				Directory.CreateDirectory(gameDir);
				Directory.CreateDirectory(supportDir);

				Platform.OverrideEngineDir(gameDir);
				Platform.OverrideSupportDir(supportDir);

				try
				{
					AssetExtractor.EnsureAssetsExtracted(context, gameDir, msg => Console.WriteLine($"[OpenRA.Android] {msg}"));
					AssetExtractor.EnsureContentExtracted(context, supportDir, msg => Console.WriteLine($"[OpenRA.Android] {msg}"));
				}
				catch (Exception ex)
				{
					Console.WriteLine($"[OpenRA.Android] Extraction failed in {gameDir}: {ex.Message}");
					if (baseDir != context.FilesDir.AbsolutePath)
					{
						Console.WriteLine("[OpenRA.Android] Retrying asset extraction in internal FilesDir...");
						baseDir = context.FilesDir.AbsolutePath;
						gameDir = Path.Combine(baseDir, "Game");
						supportDir = Path.Combine(baseDir, "Support");
						Directory.CreateDirectory(gameDir);
						Directory.CreateDirectory(supportDir);
						Platform.OverrideEngineDir(gameDir);
						Platform.OverrideSupportDir(supportDir);
						AssetExtractor.EnsureAssetsExtracted(context, gameDir, msg => Console.WriteLine($"[OpenRA.Android] {msg}"));
						AssetExtractor.EnsureContentExtracted(context, supportDir, msg => Console.WriteLine($"[OpenRA.Android] {msg}"));
					}
					else
					{
						throw;
					}
				}

				// Pre-load mod and platform assemblies packaged in the APK into the default load context
				var modAssemblies = new[] { "OpenRA.Platforms.Default", "OpenRA.Mods.Common", "OpenRA.Mods.Cnc", "OpenRA.Mods.D2k" };
				foreach (var modAsm in modAssemblies)
				{
					try
					{
						var loaded = System.Reflection.Assembly.Load(new System.Reflection.AssemblyName(modAsm));
						Console.WriteLine($"[OpenRA.Android] Pre-loaded assembly: {loaded.FullName}");
					}
					catch (Exception ex)
					{
						Console.WriteLine($"[OpenRA.Android] Failed to pre-load assembly {modAsm}: {ex.Message}");
					}
				}

				var activeMod = "ra";
				var settingsFile = Path.Combine(supportDir, "settings.yaml");
				if (File.Exists(settingsFile))
				{
					try
					{
						var yaml = MiniYaml.FromFile(settingsFile);
						foreach (var node in yaml)
						{
							if (node.Key == "Game")
							{
								foreach (var sub in node.Value.Nodes)
								{
									if (sub.Key == "LastActiveMod" && !string.IsNullOrWhiteSpace(sub.Value?.Value))
									{
										activeMod = sub.Value.Value.Trim();
										break;
									}
								}

								break;
							}
						}
					}
					catch (Exception ex)
					{
						Console.WriteLine($"[OpenRA.Android] Failed reading LastActiveMod from settings: {ex.Message}");
					}
				}

				Console.WriteLine($"[OpenRA.Android] Starting with active mod: {activeMod}");

				var args = new[]
				{
					"Game.Mod=" + activeMod,
					"Graphics.GLProfile=Embedded",
					"Graphics.Mode=Fullscreen",
					"Graphics.CapFramerate=True",
					"Graphics.MaxFramerate=60",
					"Game.MouseControlStyle=Classic",
					"Game.MouseScroll=Standard",
					"Game.ViewportEdgeScroll=False",
					"Game.UseAlternateScrollButton=False",
					"Game.IntroductionPromptVersion=2"
				};

				Game.InitializeAndRun(args);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[OpenRA.Android] Critical game error in RunManagedGame: {ex}");
			}
		}
	}
}
