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
	}
}
