using System;
using Android.App;
using Android.Runtime;

namespace OpenRA.Android
{
	[Register("eu.gfmm.nopenra.MainApplication")]
	[Application(
		Label = "nOpenRA Mobile",
		Icon = "@mipmap/app_icon",
		RoundIcon = "@mipmap/app_icon",
		AllowBackup = true,
		SupportsRtl = true,
		HasCode = true,
		ExtractNativeLibs = true,
		ResizeableActivity = false,
		RequestLegacyExternalStorage = true)]
	public class MainApplication : Application
	{
		public MainApplication(IntPtr handle, JniHandleOwnership transfer)
			: base(handle, transfer)
		{
		}

		public override void OnCreate()
		{
			base.OnCreate();
			Console.WriteLine("[MainApplication] Application OnCreate - registering JNI methods...");
			try
			{
				AndroidGameBridge.RegisterJniMethods();
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[MainApplication] Error registering JNI methods: {ex}");
			}
		}
	}
}
