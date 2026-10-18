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

		public static void RunManagedGame(IntPtr env, IntPtr clazz)
		{
			Console.WriteLine("[AndroidGameBridge] runManagedGame called from SDLThread!");
			try
			{
				var context = global::Android.App.Application.Context;
				NativeLibraryResolver.Initialize();

				var externalFiles = context.GetExternalFilesDir(null)?.AbsolutePath ?? context.FilesDir.AbsolutePath;
				var gameDir = Path.Combine(externalFiles, "Game");
				var supportDir = Path.Combine(externalFiles, "Support");

				Directory.CreateDirectory(gameDir);
				Directory.CreateDirectory(supportDir);

				Platform.OverrideEngineDir(gameDir);
				Platform.OverrideSupportDir(supportDir);

				AssetExtractor.EnsureAssetsExtracted(context, gameDir, msg => Console.WriteLine($"[OpenRA.Android] {msg}"));

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
