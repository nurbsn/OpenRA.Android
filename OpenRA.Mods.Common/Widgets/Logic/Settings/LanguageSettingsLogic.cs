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
using System.Collections.Generic;
using System.Linq;
using OpenRA.Widgets;

namespace OpenRA.Mods.Common.Widgets.Logic
{
	public class LanguageSettingsLogic : ChromeLogic
	{
		[FluentReference]
		const string LanguageEn = "button-language-en";

		[FluentReference]
		const string LanguagePl = "button-language-pl";

		[FluentReference]
		const string LanguageDe = "button-language-de";

		[FluentReference]
		const string LanguageEs = "button-language-es";

		[FluentReference]
		const string LanguageFr = "button-language-fr";

		[FluentReference]
		const string LanguagePt = "button-language-pt";

		[FluentReference]
		const string LanguageIt = "button-language-it";

		[FluentReference]
		const string LanguageRu = "button-language-ru";

		readonly GameSettings gameSettings;
		string origLanguage;

		static readonly Dictionary<string, string> Languages = new()
		{
			{ "en", LanguageEn },
			{ "pl", LanguagePl },
			{ "de", LanguageDe },
			{ "es", LanguageEs },
			{ "fr", LanguageFr },
			{ "pt", LanguagePt },
			{ "it", LanguageIt },
			{ "ru", LanguageRu },
		};

		[ObjectCreator.UseCtor]
		public LanguageSettingsLogic(ModData modData, SettingsLogic settingsLogic, string panelID, string label)
		{
			gameSettings = Game.Settings.Game;

			settingsLogic.RegisterSettingsPanel(panelID, label, InitPanel, ResetPanel);
		}

		Func<bool> InitPanel(Widget panel)
		{
			var scrollPanel = panel.Get<ScrollPanelWidget>("SETTINGS_SCROLLPANEL");
			origLanguage = gameSettings.Language ?? "en";

			var dropdown = panel.GetOrNull<DropDownButtonWidget>("LANGUAGE_DROPDOWN");
			if (dropdown != null)
			{
				dropdown.GetText = () =>
				{
					var current = gameSettings.Language ?? "en";
					if (Languages.TryGetValue(current, out var fluentKey))
						return FluentProvider.GetMessage(fluentKey);

					return current;
				};

				dropdown.OnMouseDown = _ => ShowLanguageDropdown(dropdown);
			}

			foreach (var code in Languages.Keys)
			{
				var langCode = code;
				var btn = panel.GetOrNull<ButtonWidget>("BUTTON_LANG_" + langCode.ToUpperInvariant());
				if (btn != null)
				{
					btn.IsHighlighted = () => (gameSettings.Language ?? "en").Equals(langCode, StringComparison.OrdinalIgnoreCase);
					btn.OnClick = () => SetLanguage(langCode);
				}
			}

			SettingsUtils.AdjustSettingsScrollPanelLayout(scrollPanel);

			return () => origLanguage != gameSettings.Language;
		}

		void SetLanguage(string langCode)
		{
			if (gameSettings.Language == langCode)
				return;

			gameSettings.Language = langCode;
			gameSettings.Save();

			try
			{
				FluentProvider.Reload(Game.ModData.Manifest, Game.ModData.DefaultFileSystem);
			}
			catch { }
		}

		void ShowLanguageDropdown(DropDownButtonWidget dropdown)
		{
			var options = Languages.Keys.ToList();

			ScrollItemWidget SetupItem(string code, ScrollItemWidget template)
			{
				var item = ScrollItemWidget.Setup(template,
					() => (gameSettings.Language ?? "en").Equals(code, StringComparison.OrdinalIgnoreCase),
					() => SetLanguage(code));

				var label = item.Get<LabelWidget>("LABEL");
				label.GetText = () => FluentProvider.GetMessage(Languages[code]);

				return item;
			}

			dropdown.ShowDropDown("LABEL_DROPDOWN_TEMPLATE", 300, options, SetupItem);
		}

		Action ResetPanel(Widget panel)
		{
			return () =>
			{
				SetLanguage("en");
			};
		}
	}
}
