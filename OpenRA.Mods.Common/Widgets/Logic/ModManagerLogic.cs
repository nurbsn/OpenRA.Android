#region Copyright & License Information
/*
 * Copyright (c) The OpenRA Developers and Contributors
 * This file is part of OpenRA, which is free software. It is made
 * available to you under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version. For more
 * information, see COPYING.
 */
#endregion

using System;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using OpenRA.Support;
using OpenRA.Widgets;

namespace OpenRA.Mods.Common.Widgets.Logic
{
	public class ModManagerLogic : ChromeLogic
	{
		[FluentReference]
		const string ModActive = "button-mod-active";

		[FluentReference]
		const string ModSwitch = "button-mod-switch";

		[FluentReference]
		const string ModActiveTag = "label-mod-active-tag";

		[FluentReference]
		const string ModVersion = "label-mod-version";

		[FluentReference]
		const string StorageErrorEmpty = "label-storage-error-empty";

		[FluentReference]
		const string StorageSaved = "label-storage-saved";

		[FluentReference]
		const string DownloadErrorUrl = "label-download-error-url";

		[FluentReference]
		const string DownloadErrorProtocol = "label-download-error-protocol";

		[FluentReference]
		const string DownloadConnecting = "label-download-connecting";

		[FluentReference]
		const string DownloadInstalling = "label-download-installing";

		[FluentReference]
		const string DownloadSuccess = "label-download-success";

		readonly ModData modData;

		// Tab controls
		readonly ButtonWidget tabMods;
		readonly ButtonWidget tabDownload;
		readonly ButtonWidget tabStorage;

		readonly Widget panelMods;
		readonly Widget panelDownload;
		readonly Widget panelStorage;

		// Mod list tab
		readonly ScrollPanelWidget modList;
		readonly ScrollItemWidget modTemplate;
		string selectedMod;

		// Download tab
		readonly TextFieldWidget urlInput;
		readonly ButtonWidget downloadButton;
		int downloadPercentage;
		string downloadStatus = FluentProvider.GetMessage("label-ready-download");
		bool isDownloading;

		string activeTab = "mods";

		// Storage tab
		readonly TextFieldWidget pathInput;
		string storageStatus = "";

		[ObjectCreator.UseCtor]
		public ModManagerLogic(Widget widget, ModData modData, Action onExit)
		{
			this.modData = modData;

			// Tabs
			tabMods = widget.Get<ButtonWidget>("TAB_MODS");
			tabDownload = widget.Get<ButtonWidget>("TAB_DOWNLOAD");
			tabStorage = widget.Get<ButtonWidget>("TAB_STORAGE");

			panelMods = widget.Get("PANEL_MODS");
			panelDownload = widget.Get("PANEL_DOWNLOAD");
			panelStorage = widget.Get("PANEL_STORAGE");

			panelMods.IsVisible = () => activeTab == "mods";
			panelDownload.IsVisible = () => activeTab == "download";
			panelStorage.IsVisible = () => activeTab == "storage";

			tabMods.IsHighlighted = () => activeTab == "mods";
			tabDownload.IsHighlighted = () => activeTab == "download";
			tabStorage.IsHighlighted = () => activeTab == "storage";

			tabMods.OnClick = () => activeTab = "mods";
			tabDownload.OnClick = () => activeTab = "download";
			tabStorage.OnClick = () => activeTab = "storage";

			// Mod list
			modList = widget.Get<ScrollPanelWidget>("MOD_LIST");
			modTemplate = widget.Get<ScrollItemWidget>("MOD_TEMPLATE");
			selectedMod = modData.Manifest.Id;

			var refreshButton = widget.Get<ButtonWidget>("REFRESH_BUTTON");
			refreshButton.OnClick = () =>
			{
				Game.RefreshInstalledMods();
				BuildModList();
			};

			// Download
			urlInput = widget.Get<TextFieldWidget>("URL_INPUT");
			downloadButton = widget.Get<ButtonWidget>("DOWNLOAD_BUTTON");
			downloadButton.OnClick = () => StartDownload(urlInput.Text);
			downloadButton.IsDisabled = () => isDownloading;

			var pasteButton = widget.Get<ButtonWidget>("PASTE_BUTTON");
			pasteButton.OnClick = () =>
			{
				try
				{
					var text = Game.Renderer.GetClipboardText();
					if (!string.IsNullOrWhiteSpace(text))
						urlInput.Text = text.Trim();
				}
				catch { }
			};

			var progressBar = widget.Get<ProgressBarWidget>("PROGRESS_BAR");
			progressBar.GetPercentage = () => downloadPercentage;

			var statusLabel = widget.Get<LabelWidget>("STATUS_LABEL");
			statusLabel.GetText = () => downloadStatus;

			// Preset mod links
			var presetCA = widget.GetOrNull<ButtonWidget>("PRESET_CA");
			if (presetCA != null)
				presetCA.OnClick = () => urlInput.Text = "https://github.com/MustaSpike/OpenRA-Combined-Arms/releases/latest/download/Combined-Arms.zip";

			var presetRV = widget.GetOrNull<ButtonWidget>("PRESET_RV");
			if (presetRV != null)
				presetRV.OnClick = () => urlInput.Text = "https://github.com/RA2-In-OpenRA/Romanovs-Vengeance/releases/latest/download/rv.oramod";

			var presetSP = widget.GetOrNull<ButtonWidget>("PRESET_SP");
			if (presetSP != null)
				presetSP.OnClick = () => urlInput.Text = "https://github.com/Shattered-Paradise/Shattered-Paradise/releases/latest/download/sp.oramod";

			// Storage
			pathInput = widget.Get<TextFieldWidget>("PATH_INPUT");
			pathInput.Text = Game.GetCustomContentPath() ?? "";

			var presetShared = widget.GetOrNull<ButtonWidget>("PRESET_SHARED");
			var presetDownload = widget.GetOrNull<ButtonWidget>("PRESET_DOWNLOAD");
			var presetDocuments = widget.GetOrNull<ButtonWidget>("PRESET_DOCUMENTS");
			if (OperatingSystem.IsAndroid())
			{
				if (presetShared != null)
					presetShared.OnClick = () => pathInput.Text = "/storage/emulated/0/OpenRA";

				if (presetDownload != null)
					presetDownload.OnClick = () => pathInput.Text = "/storage/emulated/0/Download/OpenRA";

				if (presetDocuments != null)
					presetDocuments.OnClick = () => pathInput.Text = "/storage/emulated/0/Documents/OpenRA";
			}
			else
			{
				var userHome = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
				var docsDir = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
				var sharedPath = Path.Combine(userHome, "OpenRA");
				var downloadPath = Path.Combine(userHome, "Downloads", "OpenRA");
				var docsPath = Path.Combine(string.IsNullOrEmpty(docsDir) ? userHome : docsDir, "OpenRA", "Content");

				if (presetShared != null)
				{
					presetShared.GetText = () => sharedPath;
					presetShared.OnClick = () => pathInput.Text = sharedPath;
				}

				if (presetDownload != null)
				{
					presetDownload.GetText = () => downloadPath;
					presetDownload.OnClick = () => pathInput.Text = downloadPath;
				}

				if (presetDocuments != null)
				{
					presetDocuments.GetText = () => docsPath;
					presetDocuments.OnClick = () => pathInput.Text = docsPath;
				}
			}

			var presetDefault = widget.GetOrNull<ButtonWidget>("PRESET_DEFAULT");
			if (presetDefault != null)
				presetDefault.OnClick = () => pathInput.Text = Path.Combine(Platform.SupportDir, "Content");

			var applyStorageButton = widget.Get<ButtonWidget>("APPLY_STORAGE_BUTTON");
			applyStorageButton.OnClick = ApplyStoragePath;

			var storageStatusLabel = widget.Get<LabelWidget>("STORAGE_STATUS_LABEL");
			storageStatusLabel.GetText = () => storageStatus;

			// Close button
			var closeButton = widget.Get<ButtonWidget>("CLOSE_BUTTON");
			closeButton.OnClick = () =>
			{
				Ui.CloseWindow();
				onExit?.Invoke();
			};

			BuildModList();
		}

		static string GetModDisplayName(string modId, Manifest manifest)
		{
			switch (modId.ToLowerInvariant())
			{
				case "ra": return "Command & Conquer: Red Alert";
				case "cnc": return "Command & Conquer: Tiberian Dawn";
				case "d2k": return "Dune 2000";
				case "ts": return "Command & Conquer: Tiberian Sun";
				default:
					var title = manifest.Metadata.Title;
					if (string.IsNullOrEmpty(title) || title == "mod-title")
						return modId.ToUpperInvariant();

					if (FluentProvider.TryGetMessage(title, out var translated))
						return translated;

					return title;
			}
		}

		void BuildModList()
		{
			modList.RemoveChildren();
			if (Game.Mods == null)
				return;

			var currentModId = modData.Manifest.Id;

			foreach (var kv in Game.Mods)
			{
				var modId = kv.Key;
				var manifest = kv.Value;

				var item = ScrollItemWidget.Setup(
					modTemplate,
					() => selectedMod == modId,
					() => selectedMod = modId,
					() =>
					{
						if (modId != currentModId)
							Game.SwitchMod(modId);
					});

				// Skip internal content installer helper packages, composite all, and unbundled/disabled mods (ts)
				if (modId.EndsWith("-content", StringComparison.OrdinalIgnoreCase)
					|| modId.Equals("all", StringComparison.OrdinalIgnoreCase)
					|| modId.Equals("ts", StringComparison.OrdinalIgnoreCase))
					continue;

				var isActive = modId == currentModId;
				var title = GetModDisplayName(modId, manifest);

				var version = manifest.Metadata.Version;
				if (string.IsNullOrEmpty(version) || version == "{DEV_VERSION}")
					version = Game.EngineVersion;

				var versionLabelTranslated = FluentProvider.GetMessage(ModVersion);
				var versionStr = $"{modId} ({versionLabelTranslated}: {version})";

				var titleLabel = item.Get<LabelWidget>("TITLE");
				titleLabel.GetText = () => title;

				var versionLabel = item.Get<LabelWidget>("ID_VERSION");
				versionLabel.GetText = () => versionStr;

				var statusLabel = item.Get<LabelWidget>("STATUS");
				statusLabel.GetText = () => isActive ? FluentProvider.GetMessage(ModActiveTag) : "";
				statusLabel.IsVisible = () => isActive;

				var switchButton = item.Get<ButtonWidget>("SWITCH_BUTTON");
				switchButton.GetText = () => isActive ? FluentProvider.GetMessage(ModActive) : FluentProvider.GetMessage(ModSwitch);
				switchButton.IsDisabled = () => isActive;
				if (!isActive)
				{
					var targetMod = modId;
					switchButton.OnClick = () => Game.SwitchMod(targetMod);
				}

				modList.AddChild(item);
			}
		}

		void ApplyStoragePath()
		{
			try
			{
				var path = pathInput.Text.Trim();
				if (string.IsNullOrWhiteSpace(path))
				{
					storageStatus = FluentProvider.GetMessage(StorageErrorEmpty);
					return;
				}

				Game.Settings.Game.CustomContentPath = path;
				Game.EnsureCustomContentPaths();
				Game.Settings.Game.Save();
				Game.RefreshInstalledMods();
				BuildModList();

				storageStatus = FluentProvider.GetMessage(StorageSaved);
			}
			catch (Exception ex)
			{
				storageStatus = $"Error: {ex.Message}";
			}
		}

		void StartDownload(string url)
		{
			if (isDownloading)
				return;

			if (string.IsNullOrWhiteSpace(url) || !Uri.TryCreate(url.Trim(), UriKind.Absolute, out var uri))
			{
				downloadStatus = FluentProvider.GetMessage(DownloadErrorUrl);
				return;
			}

			if (uri.Scheme != Uri.UriSchemeHttp && uri.Scheme != Uri.UriSchemeHttps)
			{
				downloadStatus = FluentProvider.GetMessage(DownloadErrorProtocol);
				return;
			}

			isDownloading = true;
			downloadPercentage = 0;
			downloadStatus = FluentProvider.GetMessage(DownloadConnecting);

			Task.Run(async () =>
			{
				try
				{
					using (var client = HttpClientFactory.Create())
					{
						using (var response = await client.GetAsync(uri, HttpCompletionOption.ResponseHeadersRead))
						{
							if (!response.IsSuccessStatusCode)
							{
								downloadStatus = $"HTTP {(int)response.StatusCode}";
								isDownloading = false;
								return;
							}

							var filename = response.Content.Headers.ContentDisposition?.FileName?.Trim('\"');
							if (string.IsNullOrEmpty(filename))
								filename = Path.GetFileName(uri.LocalPath);

							if (string.IsNullOrEmpty(filename))
								filename = "mod_" + DateTime.Now.Ticks + ".zip";

							var customMods = Game.GetCustomModsPath();
							if (string.IsNullOrEmpty(customMods))
								customMods = Path.Combine(Platform.SupportDir, "Content", "mods");

							Directory.CreateDirectory(customMods);

							var tempArchive = Path.Combine(customMods, filename + ".downloading");
							downloadStatus = $"{filename}...";

							await using (var fs = new FileStream(tempArchive, FileMode.Create, FileAccess.Write, FileShare.None))
							{
								await response.ReadAsStreamWithProgress(fs, (total, received, percentage) =>
								{
									downloadPercentage = percentage;
									if (total > 0)
										downloadStatus = $"{percentage}% ({received / 1024} KB / {total / 1024} KB)";
									else
										downloadStatus = $"{received / 1024} KB";
								}, CancellationToken.None);
							}

							downloadStatus = FluentProvider.GetMessage(DownloadInstalling);
							downloadPercentage = 100;

							var isZipOrOramod = filename.EndsWith(".zip", StringComparison.OrdinalIgnoreCase) ||
												filename.EndsWith(".oramod", StringComparison.OrdinalIgnoreCase);

							var targetSubdir = Path.GetFileNameWithoutExtension(filename);
							var modDestination = Path.Combine(customMods, targetSubdir);

							if (isZipOrOramod)
							{
								try
								{
									await using (var archive = await ZipFile.OpenReadAsync(tempArchive))
									{
										var hasDirectModYaml = archive.Entries.Any(e => e.FullName.Equals("mod.yaml", StringComparison.OrdinalIgnoreCase));
										var extractPath = hasDirectModYaml ? modDestination : customMods;

										Directory.CreateDirectory(extractPath);
										await archive.ExtractToDirectoryAsync(extractPath, overwriteFiles: true);
									}

									File.Delete(tempArchive);
								}
								catch
								{
									// Fallback: keep archive file directly
									var finalFile = Path.Combine(customMods, filename);
									if (File.Exists(finalFile))
										File.Delete(finalFile);
									File.Move(tempArchive, finalFile);
								}
							}
							else
							{
								var finalFile = Path.Combine(customMods, filename);
								if (File.Exists(finalFile))
									File.Delete(finalFile);
								File.Move(tempArchive, finalFile);
							}

							downloadStatus = FluentProvider.GetMessage(DownloadSuccess);
							isDownloading = false;

							Game.RunAfterTick(() =>
							{
								Game.RefreshInstalledMods();
								BuildModList();
							});
						}
					}
				}
				catch (Exception ex)
				{
					downloadStatus = $"Error: {ex.Message}";
					isDownloading = false;
				}
			});
		}
	}
}
