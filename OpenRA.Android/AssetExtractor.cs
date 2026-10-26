using System;
using System.IO;
using System.IO.Compression;
using Android.Content;

namespace OpenRA.Android
{
	public static class AssetExtractor
	{
		const string DataZipAsset = "openra-data.zip";
		const string VersionStampFile = ".extracted_version";

		const string ContentZipAsset = "ra-content.zip";
		const string ContentStampFile = ".extracted_ra_content";

		public static void EnsureAssetsExtracted(Context context, string targetDir, Action<string> onProgress = null)
		{
			Directory.CreateDirectory(targetDir);

			var versionFile = Path.Combine(targetDir, VersionStampFile);
			var packageInfo = context.PackageManager.GetPackageInfo(context.PackageName, 0);
			var appVersion = $"{packageInfo?.LongVersionCode}_{packageInfo?.LastUpdateTime}";

			if (File.Exists(versionFile) && File.ReadAllText(versionFile).Trim() == appVersion)
			{
				onProgress?.Invoke("Assets up to date.");
				return;
			}

			onProgress?.Invoke("Extracting game assets...");

			try
			{
				using (var stream = context.Assets.Open(DataZipAsset))
				using (var archive = new ZipArchive(stream, ZipArchiveMode.Read))
				{
					var total = archive.Entries.Count;
					var current = 0;

					foreach (var entry in archive.Entries)
					{
						current++;
						if (string.IsNullOrEmpty(entry.Name) && entry.FullName.EndsWith('/'))
						{
							Directory.CreateDirectory(Path.Combine(targetDir, entry.FullName));
							continue;
						}

						var destPath = Path.Combine(targetDir, entry.FullName);
						var parentDir = Path.GetDirectoryName(destPath);
						if (!string.IsNullOrEmpty(parentDir))
							Directory.CreateDirectory(parentDir);

						entry.ExtractToFile(destPath, overwrite: true);

						if (current % 100 == 0)
							onProgress?.Invoke($"Extracting assets ({current}/{total})...");
					}
				}

				File.WriteAllText(versionFile, appVersion);
				onProgress?.Invoke("Assets extracted successfully.");
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[AssetExtractor] Failed to extract assets: {ex}");
				throw;
			}
		}

		public static void EnsureContentExtracted(Context context, string supportDir, Action<string> onProgress = null)
		{
			var raContentDir = Path.Combine(supportDir, "Content", "ra", "v2");
			Directory.CreateDirectory(raContentDir);

			var stampFile = Path.Combine(raContentDir, ContentStampFile);
			var packageInfo = context.PackageManager.GetPackageInfo(context.PackageName, 0);
			var appVersion = $"{packageInfo?.LongVersionCode}_{packageInfo?.LastUpdateTime}";

			if (File.Exists(stampFile) && File.ReadAllText(stampFile).Trim() == appVersion)
				return;

			// Also verify that core content files are present
			if (File.Exists(Path.Combine(raContentDir, "allies.mix")) &&
				File.Exists(Path.Combine(raContentDir, "conquer.mix")) &&
				File.Exists(Path.Combine(raContentDir, "expand", "chrotnk1.aud")))
			{
				File.WriteAllText(stampFile, appVersion);
				return;
			}

			try
			{
				bool hasContentAsset = false;
				var assets = context.Assets.List("");
				if (assets != null)
				{
					foreach (var a in assets)
					{
						if (string.Equals(a, ContentZipAsset, StringComparison.OrdinalIgnoreCase))
						{
							hasContentAsset = true;
							break;
						}
					}
				}

				if (!hasContentAsset)
					return;

				onProgress?.Invoke("Extracting bundled Red Alert content...");

				using (var stream = context.Assets.Open(ContentZipAsset))
				using (var archive = new ZipArchive(stream, ZipArchiveMode.Read))
				{
					foreach (var entry in archive.Entries)
					{
						if (string.IsNullOrEmpty(entry.Name) && entry.FullName.EndsWith('/'))
						{
							Directory.CreateDirectory(Path.Combine(raContentDir, entry.FullName));
							continue;
						}

						var destPath = Path.Combine(raContentDir, entry.FullName);
						var parentDir = Path.GetDirectoryName(destPath);
						if (!string.IsNullOrEmpty(parentDir))
							Directory.CreateDirectory(parentDir);

						entry.ExtractToFile(destPath, overwrite: true);
					}
				}

				File.WriteAllText(stampFile, appVersion);
				onProgress?.Invoke("Red Alert content extracted successfully.");
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[AssetExtractor] Failed to extract bundled content: {ex}");
			}
		}
	}
}
