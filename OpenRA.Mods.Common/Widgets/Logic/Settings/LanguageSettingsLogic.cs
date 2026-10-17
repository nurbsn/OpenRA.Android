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

		readonly GameSettings gameSettings;
		string origLanguage;

		static readonly Dictionary<string, string> Languages = new()
		{
			{ "en", LanguageEn },
			{ "pl", LanguagePl },
		};

		[ObjectCreator.UseCtor]
		public LanguageSettingsLogic(ModData modData, SettingsLogic settingsLogic, string panelID, string label)
		{
			gameSettings = Game.Settings.Game;

			settingsLogic.RegisterSettingsPanel(panelID, label, InitPanel, ResetPanel);
		}

		Func<bool> InitPanel(Widget panel)
		{
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

			var btnEn = panel.GetOrNull<ButtonWidget>("BUTTON_LANG_EN");
			if (btnEn != null)
			{
				btnEn.IsHighlighted = () => (gameSettings.Language ?? "en").Equals("en", StringComparison.OrdinalIgnoreCase);
				btnEn.OnClick = () => SetLanguage("en");
			}

			var btnPl = panel.GetOrNull<ButtonWidget>("BUTTON_LANG_PL");
			if (btnPl != null)
			{
				btnPl.IsHighlighted = () => (gameSettings.Language ?? "en").Equals("pl", StringComparison.OrdinalIgnoreCase);
				btnPl.OnClick = () => SetLanguage("pl");
			}

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
