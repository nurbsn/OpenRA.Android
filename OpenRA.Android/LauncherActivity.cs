using System;
using Android.App;
using Android.Content;
using Android.Content.PM;
using Android.OS;

namespace OpenRA.Android
{
	[Activity(
		Name = "eu.gfmm.nopenra.LauncherActivity",
		Label = "nOpenRA Mobile",
		Icon = "@mipmap/app_icon",
		RoundIcon = "@mipmap/app_icon",
		MainLauncher = false,
		Exported = false,
		NoHistory = true,
		ConfigurationChanges = ConfigChanges.Orientation | ConfigChanges.ScreenSize | ConfigChanges.ScreenLayout | ConfigChanges.SmallestScreenSize | ConfigChanges.UiMode | ConfigChanges.KeyboardHidden,
		ScreenOrientation = ScreenOrientation.SensorLandscape,
		ResizeableActivity = true,
		Theme = "@android:style/Theme.NoTitleBar.Fullscreen")]
	public class LauncherActivity : Activity
	{
		protected override void OnCreate(Bundle savedInstanceState)
		{
			base.OnCreate(savedInstanceState);
			Console.WriteLine("[LauncherActivity] Starting OpenRA launcher...");

			try
			{
				AndroidGameBridge.RegisterJniMethods();

				var intent = new Intent();
				intent.SetClassName(this, "org.libsdl.app.SDLActivity");
				intent.AddFlags(ActivityFlags.ForwardResult);
				StartActivity(intent);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[LauncherActivity] Launch failed: {ex}");
			}

			Finish();
		}
	}
}
