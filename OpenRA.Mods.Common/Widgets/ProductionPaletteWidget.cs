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
using System.Globalization;
using System.Linq;
using System.Numerics;
using OpenRA.Graphics;
using OpenRA.Mods.Common.Lint;
using OpenRA.Mods.Common.Orders;
using OpenRA.Mods.Common.Traits;
using OpenRA.Mods.Common.Traits.Render;
using OpenRA.Network;
using OpenRA.Primitives;
using OpenRA.Widgets;

namespace OpenRA.Mods.Common.Widgets
{
	public class ProductionIcon
	{
		public ActorInfo Actor;
		public string Name;
		public HotkeyReference Hotkey;
		public Sprite Sprite;
		public PaletteReference Palette;
		public PaletteReference IconClockPalette;
		public PaletteReference IconDarkenPalette;
		public Vector2 Pos;
		public List<ProductionItem> Queued;
		public ProductionQueue ProductionQueue;
	}

	public class ProductionPaletteWidget : Widget
	{
		const int QueueButtonWidth = 42;
		const int QueueButtonHeight = 36;
		const int QueueButtonSpacing = 4;
		const int QueueButtonCount = 6;
		const int TotalQueuePanelHeight = QueueButtonCount * QueueButtonHeight + (QueueButtonCount - 1) * QueueButtonSpacing;
		const int QueuePanelMargin = 8;

		public enum ReadyTextStyleOptions { Solid, AlternatingColor, Blinking }
		public readonly ReadyTextStyleOptions ReadyTextStyle = ReadyTextStyleOptions.AlternatingColor;
		public readonly Color TextColor = Color.White;
		public readonly Color ReadyTextAltColor = Color.Gold;
		public readonly int Columns = 3;
		public readonly int2 IconSize = new(64, 48);
		public readonly int2 IconMargin = int2.Zero;
		public readonly int2 IconSpriteOffset = int2.Zero;

		public readonly Vector2 QueuedOffset = new(4, 2);

		public readonly Vector2 BulkOffset = new(4, 2);
		public readonly TextAlign QueuedTextAlign = TextAlign.Left;

		public readonly string ClickSound = ChromeMetrics.Get<string>("ClickSound");
		public readonly string ClickDisabledSound = ChromeMetrics.Get<string>("ClickDisabledSound");
		public readonly string TooltipContainer;
		public readonly string TooltipTemplate = "PRODUCTION_TOOLTIP";

		// Note: LinterHotkeyNames assumes that these are disabled by default
		public readonly string HotkeyPrefix = null;
		public readonly int HotkeyCount = 0;
		public readonly HotkeyReference SelectProductionBuildingHotkey = new();

		public readonly string ClockAnimation = "clock";
		public readonly string ClockSequence = "idle";
		public readonly string ClockPalette = "chrome";

		public readonly string NotBuildableAnimation = "clock";
		public readonly string NotBuildableSequence = "idle";
		public readonly string NotBuildablePalette = "chrome";

		public readonly string OverlayFont = "TinyBold";
		public readonly string SymbolsFont = "Symbols";

		public readonly bool DrawTime = true;

		[FluentReference]
		public string ReadyText = "";

		[FluentReference]
		public string HoldText = "";

		public readonly string InfiniteSymbol = "\u221E";

		public int DisplayedIconCount { get; private set; }
		public int TotalIconCount { get; private set; }
		public event Action<int, int> OnIconCountChanged = (a, b) => { };

		public ProductionIcon TooltipIcon { get; private set; }
		public Func<ProductionIcon> GetTooltipIcon;
		public readonly World World;
		readonly ModData modData;
		readonly OrderManager orderManager;

		public int MinimumRows = 4;
		public int MaximumRows = int.MaxValue;

		public int IconRowOffset = 0;
		public int MaxIconRowOffset = int.MaxValue;

		readonly Lazy<TooltipContainerWidget> tooltipContainer;
		ProductionQueue currentQueue;
		HotkeyReference[] hotkeys;

		public ProductionQueue CurrentQueue
		{
			get => currentQueue;
			set
			{
				currentQueue = value;
				selectedIcon = null;
				if (currentQueue != null)
					UpdateCachedProductionIconOverlays();

				RefreshIcons();
			}
		}

		enum QueueButtonType { AddFive, SubtractOne, PauseResume, CancelAll, SetRallyPoint, Close }
		ProductionIcon selectedIcon;
		QueueButtonType? pressedQueueButton;
		SpriteFont boldFont;

		public override bool EventBoundsContains(int2 location)
		{
			if (selectedIcon != null && GetQueuePanelRect().Contains(location))
				return true;

			foreach (var rect in icons.Keys)
				if (rect.Contains(location))
					return true;

			foreach (var child in Children)
				if (child.IsVisible() && child.EventBoundsContains(location))
					return true;

			return false;
		}

		public override Rectangle EventBounds
		{
			get
			{
				if (selectedIcon != null)
				{
					var panelRect = GetQueuePanelRect();
					if (eventBounds.IsEmpty)
						return panelRect;

					return Rectangle.Union(eventBounds, panelRect);
				}

				return eventBounds;
			}
		}

		Dictionary<Rectangle, ProductionIcon> icons = [];
		Animation cantBuild;
		Animation clock;
		Rectangle eventBounds = Rectangle.Empty;

		readonly WorldRenderer worldRenderer;

		SpriteFont overlayFont, symbolFont;
		Vector2 iconOffset, holdOffset, readyOffset, timeOffset, infiniteOffset;

		Player cachedQueueOwner;
		IProductionIconOverlay[] pios;

		[CustomLintableHotkeyNames]
		public static IEnumerable<string> LinterHotkeyNames(MiniYamlNode widgetNode, Action<string> emitError)
		{
			var prefix = "";
			var prefixNode = widgetNode.Value.NodeWithKeyOrDefault("HotkeyPrefix");
			if (prefixNode != null)
				prefix = prefixNode.Value.Value;

			var count = 0;
			var countNode = widgetNode.Value.NodeWithKeyOrDefault("HotkeyCount");
			if (countNode != null)
				count = FieldLoader.GetValue<int>("HotkeyCount", countNode.Value.Value);

			if (count == 0)
				return [];

			if (string.IsNullOrEmpty(prefix))
				emitError($"{widgetNode.Location} must define HotkeyPrefix if HotkeyCount > 0.");

			return Exts.MakeArray(count, i => prefix + (i + 1).ToStringInvariant("D2"));
		}

		[ObjectCreator.UseCtor]
		public ProductionPaletteWidget(ModData modData, OrderManager orderManager, World world, WorldRenderer worldRenderer)
		{
			this.modData = modData;
			this.orderManager = orderManager;
			World = world;
			this.worldRenderer = worldRenderer;
			GetTooltipIcon = () => TooltipIcon;
			tooltipContainer = Exts.Lazy(() =>
				Ui.Root.Get<TooltipContainerWidget>(TooltipContainer));
		}

		public override void Initialize(WidgetArgs args)
		{
			base.Initialize(args);

			clock = new Animation(World, ClockAnimation);
			cantBuild = new Animation(World, NotBuildableAnimation);
			cantBuild.PlayFetchIndex(NotBuildableSequence, () => 0);
			hotkeys = Exts.MakeArray(HotkeyCount,
				i => modData.Hotkeys[HotkeyPrefix + (i + 1).ToStringInvariant("D2")]);

			overlayFont = Game.Renderer.Fonts[OverlayFont];
			Game.Renderer.Fonts.TryGetValue(SymbolsFont, out symbolFont);
			if (!Game.Renderer.Fonts.TryGetValue("Bold", out boldFont))
				boldFont = overlayFont;

			iconOffset = 0.5f * IconSize.ToVector2() + IconSpriteOffset.ToVector2();
			HoldText = FluentProvider.GetMessage(HoldText);
			holdOffset = iconOffset - overlayFont.Measure(HoldText).ToVector2() / 2;
			ReadyText = FluentProvider.GetMessage(ReadyText);
			readyOffset = iconOffset - overlayFont.Measure(ReadyText).ToVector2() / 2;

			if (ChromeMetrics.TryGet("InfiniteOffset", out infiniteOffset))
				infiniteOffset += QueuedOffset;
			else
				infiniteOffset = QueuedOffset;
		}

		public void ScrollDown()
		{
			if (CanScrollDown)
				IconRowOffset++;
		}

		public bool CanScrollDown
		{
			get
			{
				var totalRows = (TotalIconCount + Columns - 1) / Columns;

				return IconRowOffset < totalRows - MaxIconRowOffset;
			}
		}

		public void ScrollUp()
		{
			if (CanScrollUp)
				IconRowOffset--;
		}

		public bool CanScrollUp => IconRowOffset > 0;

		public void ScrollToTop()
		{
			IconRowOffset = 0;
		}

		public IEnumerable<ActorInfo> AllBuildables
		{
			get
			{
				if (CurrentQueue == null)
					return [];

				return CurrentQueue.AllItems().OrderBy(a => a.TraitInfo<BuildableInfo>().BuildPaletteOrder);
			}
		}

		public override void Tick()
		{
			TotalIconCount = AllBuildables.Count();

			if (CurrentQueue != null && (CurrentQueue.Actor == null || CurrentQueue.Actor.Disposed || !CurrentQueue.Actor.IsInWorld))
				CurrentQueue = null;

			if (CurrentQueue != null)
			{
				if (CurrentQueue.Actor.Owner != cachedQueueOwner)
					UpdateCachedProductionIconOverlays();

				RefreshIcons();
			}

			if (selectedIcon != null)
			{
				if (World.OrderGenerator is PlaceBuildingOrderGenerator || CurrentQueue == null)
					selectedIcon = null;
				else
				{
					var currentSelected = icons.Values.FirstOrDefault(i => i.Name == selectedIcon.Name);
					if (currentSelected == null && !CurrentQueue.AllItems().Any(a => a.Name == selectedIcon.Name))
						selectedIcon = null;
					else if (currentSelected != null)
						selectedIcon = currentSelected;
				}
			}
		}

		public override void MouseEntered()
		{
			if (TooltipContainer != null)
				tooltipContainer.Value.SetTooltip(TooltipTemplate,
					new WidgetArgs() { { "player", World.LocalPlayer }, { "getTooltipIcon", GetTooltipIcon }, { "world", World }, { "productionPalette", this } });
		}

		public override void MouseExited()
		{
			if (TooltipContainer != null)
				tooltipContainer.Value.RemoveTooltip();
		}

		Rectangle GetQueuePanelRect()
		{
			var anchorX = RenderBounds.X;
			var anchorY = RenderBounds.Y;

			// In RA, D2K, and TS, ProductionPalette sits inside a narrow SIDEBAR_PRODUCTION container.
			// In C&C, it is parented to fullscreen PLAYER_WIDGETS (Bounds 0,0,0,0), so anchor beside PRODUCTION_BACKGROUND.
			if (Parent != null && Parent.RenderBounds.X > 0 && Parent.RenderBounds.Width > 0 && Parent.RenderBounds.Width < Game.Renderer.Resolution.Width / 2)
			{
				anchorX = Parent.RenderBounds.X;
				anchorY = Parent.RenderBounds.Y;
			}
			else if (Parent?.GetOrNull("PRODUCTION_BACKGROUND") is Widget prodBg && prodBg.RenderBounds.X > 0)
			{
				anchorX = Math.Min(anchorX, prodBg.RenderBounds.X);
				anchorY = Math.Min(anchorY, prodBg.RenderBounds.Y);
			}

			var panelX = anchorX - QueueButtonWidth - QueuePanelMargin;
			var panelY = anchorY + 4;

			if (panelX < 0)
				panelX = 0;

			var screenHeight = Game.Renderer.Resolution.Height;
			if (panelY + TotalQueuePanelHeight > screenHeight - 4)
				panelY = Math.Max(0, screenHeight - TotalQueuePanelHeight - 4);

			return new Rectangle(panelX, panelY, QueueButtonWidth, TotalQueuePanelHeight);
		}

		Rectangle GetQueueButtonRect(int index)
		{
			var panel = GetQueuePanelRect();
			return new Rectangle(panel.X, panel.Y + index * (QueueButtonHeight + QueueButtonSpacing), panel.Width, QueueButtonHeight);
		}

		static bool IsValidActor(Actor a) => a != null && !a.Disposed && a.IsInWorld && !a.IsDead;

		Actor GetRallyProducer()
		{
			var selectedBuilding = World.Selection.Actors.FirstOrDefault(a => IsValidActor(a) && a.Owner == World.LocalPlayer && a.TraitOrDefault<RallyPoint>() != null);
			if (selectedBuilding != null)
				return selectedBuilding;

			if (CurrentQueue == null)
				return null;

			var producer = CurrentQueue.MostLikelyProducer();
			return producer.Trait != null && IsValidActor(producer.Actor) ? producer.Actor : null;
		}

		void HandleQueueButtonClick(QueueButtonType type)
		{
			if (selectedIcon == null || CurrentQueue == null)
				return;

			var queuedItems = CurrentQueue.AllQueued().Where(a => a.Item == selectedIcon.Name).ToList();
			var firstItem = queuedItems.FirstOrDefault();

			switch (type)
			{
				case QueueButtonType.AddFive:
				{
					var buildable = CurrentQueue.BuildableItems().FirstOrDefault(a => a.Name == selectedIcon.Name);
					if (buildable != null)
					{
						if (CurrentQueue.Info.PayUpFront &&
							currentQueue.GetProductionCost(buildable) > CurrentQueue.Actor.Owner.PlayerActor.Trait<PlayerResources>().GetCashAndResources())
						{
							Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickDisabledSound, null);
							return;
						}

						var canQueue = CurrentQueue.CanQueue(buildable, out var notification, out var textNotification);
						if (!CurrentQueue.AllQueued().Any())
						{
							Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", notification, World.LocalPlayer.Faction.InternalName);
							TextNotificationsManager.AddTransientLine(World.LocalPlayer, textNotification);
						}

						if (canQueue)
						{
							Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
							World.IssueOrder(Order.StartProduction(CurrentQueue.Actor, selectedIcon.Name, 5, true));
						}
						else
							Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickDisabledSound, null);
					}
					else
						Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickDisabledSound, null);

					break;
				}

				case QueueButtonType.SubtractOne:
				{
					if (queuedItems.Count > 0)
					{
						Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
						Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", CurrentQueue.Info.CancelledAudio, World.LocalPlayer.Faction.InternalName);
						TextNotificationsManager.AddTransientLine(World.LocalPlayer, CurrentQueue.Info.CancelledTextNotification);
						World.IssueOrder(Order.CancelProduction(CurrentQueue.Actor, selectedIcon.Name, 1));
					}
					else
						Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickDisabledSound, null);

					break;
				}

				case QueueButtonType.PauseResume:
				{
					if (firstItem != null && !CurrentQueue.Info.DisallowPaused)
					{
						if (firstItem.Paused)
						{
							Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
							Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", CurrentQueue.Info.QueuedAudio, World.LocalPlayer.Faction.InternalName);
							TextNotificationsManager.AddTransientLine(World.LocalPlayer, CurrentQueue.Info.QueuedTextNotification);
							World.IssueOrder(Order.PauseProduction(CurrentQueue.Actor, selectedIcon.Name, false));
						}
						else
						{
							Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
							Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", CurrentQueue.Info.OnHoldAudio, World.LocalPlayer.Faction.InternalName);
							TextNotificationsManager.AddTransientLine(World.LocalPlayer, CurrentQueue.Info.OnHoldTextNotification);
							World.IssueOrder(Order.PauseProduction(CurrentQueue.Actor, selectedIcon.Name, true));
						}
					}
					else
						Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickDisabledSound, null);

					break;
				}

				case QueueButtonType.CancelAll:
				{
					if (queuedItems.Count > 0)
					{
						Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
						Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", CurrentQueue.Info.CancelledAudio, World.LocalPlayer.Faction.InternalName);
						TextNotificationsManager.AddTransientLine(World.LocalPlayer, CurrentQueue.Info.CancelledTextNotification);
						World.IssueOrder(Order.CancelProduction(CurrentQueue.Actor, selectedIcon.Name, queuedItems.Count));
					}
					else
						Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickDisabledSound, null);

					break;
				}

				case QueueButtonType.SetRallyPoint:
				{
					var rallyProducer = GetRallyProducer();
					var rp = IsValidActor(rallyProducer) ? rallyProducer.TraitOrDefault<RallyPoint>() : null;
					if (rp != null)
					{
						Game.Sound.PlayNotification(World.Map.Rules, null, "Sounds", ClickSound, null);
						if (World.OrderGenerator is SetRallyPointOrderGenerator)
							World.CancelInputMode();
						else
							World.OrderGenerator = new SetRallyPointOrderGenerator(rallyProducer, rp);
					}
					else
						Game.Sound.PlayNotification(World.Map.Rules, null, "Sounds", ClickDisabledSound, null);

					break;
				}

				case QueueButtonType.Close:
				{
					Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
					if (World.OrderGenerator is SetRallyPointOrderGenerator)
						World.CancelInputMode();

					selectedIcon = null;
					break;
				}
			}
		}

		public override bool HandleMouseInput(MouseInput mi)
		{
			if (selectedIcon != null)
			{
				var panelRect = GetQueuePanelRect();
				if (panelRect.Contains(mi.Location))
				{
					if (mi.Event == MouseInputEvent.Down)
					{
						for (var i = 0; i < QueueButtonCount; i++)
						{
							var btnRect = GetQueueButtonRect(i);
							if (btnRect.Contains(mi.Location))
							{
								pressedQueueButton = (QueueButtonType)i;
								HandleQueueButtonClick((QueueButtonType)i);
								break;
							}
						}
					}
					else if (mi.Event == MouseInputEvent.Up)
						pressedQueueButton = null;

					return true;
				}
			}

			if (mi.Event == MouseInputEvent.Up)
				pressedQueueButton = null;

			var icon = icons.Where(i => i.Key.Contains(mi.Location))
				.Select(i => i.Value).FirstOrDefault();

			if (mi.Event == MouseInputEvent.Move)
				TooltipIcon = icon;

			if (mi.Event == MouseInputEvent.Scroll)
			{
				if (mi.Delta.Y < 0 && CanScrollDown)
				{
					ScrollDown();
					Ui.ResetTooltips();
					Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
				}
				else if (mi.Delta.Y > 0 && CanScrollUp)
				{
					ScrollUp();
					Ui.ResetTooltips();
					Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
					return true;
				}
			}

			if (icon == null)
				return false;

			// Eat mouse-up events
			if (mi.Event != MouseInputEvent.Down)
				return true;

			var item = icon.Queued.FirstOrDefault();
			if (item != null && item.Done && World.Map.Rules.Actors[item.Item].HasTraitInfo<BuildingInfo>())
				selectedIcon = null;
			else
				selectedIcon = icon;

			return HandleEvent(icon, mi.Button, mi.Modifiers);
		}

		protected bool PickUpCompletedBuildingIcon(ProductionItem item)
		{
			if (item == null)
				return false;

			var actor = World.Map.Rules.Actors[item.Item];

			if (item.Done && actor.HasTraitInfo<BuildingInfo>())
			{
				World.OrderGenerator = new PlaceBuildingOrderGenerator(CurrentQueue, item.Item, worldRenderer);
				return true;
			}

			return false;
		}

		public void PickUpCompletedBuilding()
		{
			PickUpCompletedBuildingIcon(CurrentQueue.CurrentItem());
		}

		bool HandleLeftClick(ProductionItem item, ProductionIcon icon, int handleCount, Modifiers modifiers)
		{
			if (PickUpCompletedBuildingIcon(item))
			{
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
				return true;
			}

			if (item != null && item.Paused)
			{
				// Resume a paused item
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", CurrentQueue.Info.QueuedAudio, World.LocalPlayer.Faction.InternalName);
				TextNotificationsManager.AddTransientLine(World.LocalPlayer, CurrentQueue.Info.QueuedTextNotification);

				World.IssueOrder(Order.PauseProduction(CurrentQueue.Actor, icon.Name, false));
				return true;
			}

			var buildable = CurrentQueue.BuildableItems().FirstOrDefault(a => a.Name == icon.Name);

			if (buildable != null)
			{
				if (CurrentQueue.Info.PayUpFront &&
					currentQueue.GetProductionCost(buildable) > CurrentQueue.Actor.Owner.PlayerActor.Trait<PlayerResources>().GetCashAndResources())
					return false;
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);

				// Queue a new item
				var canQueue = CurrentQueue.CanQueue(buildable, out var notification, out var textNotification);

				if (!CurrentQueue.AllQueued().Any())
				{
					Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", notification, World.LocalPlayer.Faction.InternalName);
					TextNotificationsManager.AddTransientLine(World.LocalPlayer, textNotification);
				}

				if (canQueue)
				{
					var queued = !modifiers.HasModifier(Modifiers.Ctrl);
					World.IssueOrder(Order.StartProduction(CurrentQueue.Actor, icon.Name, handleCount, queued));
					return true;
				}
			}

			return false;
		}

		bool HandleRightClick(ProductionItem item, ProductionIcon icon, int handleCount)
		{
			if (CurrentQueue is BulkProductionQueue bulkProductionQueue && !bulkProductionQueue.HasDeliveryStarted())
			{
				var readyActors = bulkProductionQueue.GetActorsReadyForDelivery();
				if (readyActors.Any(a => a.Actor.Name == icon.Name))
				{
					World.IssueOrder(
						new Order("ReturnOrder", CurrentQueue.Actor, false)
						{
							ExtraData = (uint)handleCount,
							TargetString = icon.Name
						});
					Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
					return true;
				}
				else
					return false;
			}

			if (item == null)
				return false;

			Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);

			if (CurrentQueue.Info.DisallowPaused || item.Paused || item.Done || item.TotalCost == item.RemainingCost || !item.Started)
			{
				// Instantly cancel items that haven't started, have finished, or if the queue doesn't support pausing
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", CurrentQueue.Info.CancelledAudio, World.LocalPlayer.Faction.InternalName);
				TextNotificationsManager.AddTransientLine(World.LocalPlayer, CurrentQueue.Info.CancelledTextNotification);

				World.IssueOrder(Order.CancelProduction(CurrentQueue.Actor, icon.Name, handleCount));
			}
			else
			{
				// Pause an existing item
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", CurrentQueue.Info.OnHoldAudio, World.LocalPlayer.Faction.InternalName);
				TextNotificationsManager.AddTransientLine(World.LocalPlayer, CurrentQueue.Info.OnHoldTextNotification);

				World.IssueOrder(Order.PauseProduction(CurrentQueue.Actor, icon.Name, true));
			}

			return true;
		}

		bool HandleMiddleClick(ProductionItem item, ProductionIcon icon, int handleCount)
		{
			if (item != null)
			{
				// Directly cancel, skipping "on-hold"
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickSound, null);
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Speech", CurrentQueue.Info.CancelledAudio, World.LocalPlayer.Faction.InternalName);
				TextNotificationsManager.AddTransientLine(World.LocalPlayer, CurrentQueue.Info.CancelledTextNotification);

				World.IssueOrder(Order.CancelProduction(CurrentQueue.Actor, icon.Name, handleCount));
				return true;
			}

			return false;
		}

		bool HandleEvent(ProductionIcon icon, MouseButton btn, Modifiers modifiers)
		{
			var startCount = modifiers.HasModifier(Modifiers.Shift) ? 5 : 1;

			// PERF: avoid an unnecessary enumeration by casting back to its known type
			var cancelCount = modifiers.HasModifier(Modifiers.Ctrl) ? ((List<ProductionItem>)CurrentQueue.AllQueued()).Count : startCount;
			var item = icon.Queued.FirstOrDefault();
			var handled = btn == MouseButton.Left ? HandleLeftClick(item, icon, startCount, modifiers)
				: btn == MouseButton.Right ? HandleRightClick(item, icon, cancelCount)
				: btn == MouseButton.Middle && HandleMiddleClick(item, icon, cancelCount);

			if (!handled)
				Game.Sound.PlayNotification(World.Map.Rules, World.LocalPlayer, "Sounds", ClickDisabledSound, null);

			return true;
		}

		public override bool HandleKeyPress(KeyInput e)
		{
			if (e.Event == KeyInputEvent.Up || CurrentQueue == null)
				return false;

			if (SelectProductionBuildingHotkey.IsActivatedBy(e))
				return SelectProductionBuilding();

			var batchModifiers = e.Modifiers.HasModifier(Modifiers.Shift) ? Modifiers.Shift : Modifiers.None;

			// HACK: enable production if the shift key is pressed
			e.Modifiers &= ~Modifiers.Shift;
			var toBuild = icons.Values.FirstOrDefault(i => i.Hotkey != null && i.Hotkey.IsActivatedBy(e));
			return toBuild != null && HandleEvent(toBuild, MouseButton.Left, batchModifiers);
		}

		bool SelectProductionBuilding()
		{
			var viewport = worldRenderer.Viewport;
			var selection = World.Selection;

			if (CurrentQueue == null)
				return true;

			var facility = CurrentQueue.MostLikelyProducer().Actor;

			if (!IsValidActor(facility) || facility.OccupiesSpace == null)
				return true;

			if (selection.Actors.Count == 1 && selection.Contains(facility))
				viewport.Center(selection.Actors);
			else
				selection.Combine(World, [facility], false, true);

			Game.Sound.PlayNotification(World.Map.Rules, null, "Sounds", ClickSound, null);
			return true;
		}

		void UpdateCachedProductionIconOverlays()
		{
			if (CurrentQueue?.Actor == null || CurrentQueue.Actor.Disposed)
			{
				cachedQueueOwner = null;
				pios = [];
				return;
			}

			cachedQueueOwner = CurrentQueue.Actor.Owner;
			pios = cachedQueueOwner.PlayerActor.TraitsImplementing<IProductionIconOverlay>().ToArray();
		}

		public void RefreshIcons()
		{
			icons = [];
			var producer = CurrentQueue != null ? CurrentQueue.MostLikelyProducer() : default;
			if (CurrentQueue == null || producer.Trait == null || producer.Actor == null || producer.Actor.Disposed)
			{
				if (DisplayedIconCount != 0)
				{
					OnIconCountChanged(DisplayedIconCount, 0);
					DisplayedIconCount = 0;
				}

				return;
			}

			var oldIconCount = DisplayedIconCount;
			DisplayedIconCount = 0;

			var rb = RenderBounds;
			var faction = producer.Trait.Faction;

			foreach (var item in AllBuildables.Skip(IconRowOffset * Columns).Take(MaxIconRowOffset * Columns))
			{
				var x = DisplayedIconCount % Columns;
				var y = DisplayedIconCount / Columns;
				var rect = new Rectangle(rb.X + x * (IconSize.X + IconMargin.X), rb.Y + y * (IconSize.Y + IconMargin.Y), IconSize.X, IconSize.Y);

				var rsi = item.TraitInfo<RenderSpritesInfo>();
				var icon = new Animation(World, rsi.GetImage(item, faction));
				var bi = item.TraitInfo<BuildableInfo>();
				icon.Play(bi.Icon);

				var palette = bi.IconPaletteIsPlayerPalette ? bi.IconPalette + producer.Actor.Owner.InternalName : bi.IconPalette;

				var pi = new ProductionIcon()
				{
					Actor = item,
					Name = item.Name,
					Hotkey = DisplayedIconCount < HotkeyCount ? hotkeys[DisplayedIconCount] : null,
					Sprite = icon.Image,
					Palette = worldRenderer.Palette(palette),
					IconClockPalette = worldRenderer.Palette(ClockPalette),
					IconDarkenPalette = worldRenderer.Palette(NotBuildablePalette),
					Pos = rect.Location.ToVector2(),
					Queued = currentQueue.AllQueued().Where(a => a.Item == item.Name).ToList(),
					ProductionQueue = currentQueue
				};

				icons.Add(rect, pi);
				DisplayedIconCount++;
			}

			eventBounds = icons.Keys.Union();

			if (oldIconCount != DisplayedIconCount)
				OnIconCountChanged(oldIconCount, DisplayedIconCount);
		}

		public override void Draw()
		{
			timeOffset = iconOffset - overlayFont.Measure(WidgetUtils.FormatTime(0, World.Timestep)).ToVector2() / 2;

			if (CurrentQueue == null)
				return;

			var buildableItems = CurrentQueue.BuildableItems();

			// Icons
			Game.Renderer.EnableAntialiasingFilter();
			foreach (var icon in icons.Values)
			{
				WidgetUtils.DrawSpriteCentered(icon.Sprite, icon.Palette, icon.Pos + iconOffset);

				// Draw the ProductionIconOverlay's sprites
				foreach (var pio in pios.Where(p => p.IsOverlayActive(icon.Actor)))
					WidgetUtils.DrawSpriteCentered(pio.Sprite, worldRenderer.Palette(pio.Palette), icon.Pos + iconOffset + pio.Offset(IconSize.ToVector2()));

				// Build progress
				if (icon.Queued.Count > 0)
				{
					var first = icon.Queued[0];
					clock.PlayFetchIndex(ClockSequence,
						() => (first.TotalTime - first.RemainingTime)
							* (clock.CurrentSequence.Length - 1) / first.TotalTime);
					clock.Tick();

					WidgetUtils.DrawSpriteCentered(clock.Image, icon.IconClockPalette, icon.Pos + iconOffset);
				}
				else if (!buildableItems.Any(a => a.Name == icon.Name))
					WidgetUtils.DrawSpriteCentered(cantBuild.Image, icon.IconDarkenPalette, icon.Pos + iconOffset);
			}

			Game.Renderer.DisableAntialiasingFilter();

			// Overlays
			foreach (var icon in icons.Values)
			{
				var total = icon.Queued.Count;
				if (total > 0)
				{
					var first = icon.Queued[0];
					var waiting = !CurrentQueue.IsProducing(first) && !first.Done;
					if (first.Done)
					{
						if (CurrentQueue is not BulkProductionQueue)
						{
							if (ReadyTextStyle == ReadyTextStyleOptions.Solid || orderManager.LocalFrameNumber * worldRenderer.World.Timestep / 360 % 2 == 0)
								overlayFont.DrawTextWithContrast(ReadyText, icon.Pos + readyOffset, TextColor, Color.Black, 1);
							else if (ReadyTextStyle == ReadyTextStyleOptions.AlternatingColor)
								overlayFont.DrawTextWithContrast(ReadyText, icon.Pos + readyOffset, ReadyTextAltColor, Color.Black, 1);
						}
					}
					else if (first.Paused)
						overlayFont.DrawTextWithContrast(HoldText,
							icon.Pos + holdOffset,
							TextColor, Color.Black, 1);
					else if (!waiting && DrawTime)
						overlayFont.DrawTextWithContrast(WidgetUtils.FormatTime(first.Queue.RemainingTimeActual(first), World.Timestep),
							icon.Pos + timeOffset,
							TextColor, Color.Black, 1);

					if (first.Infinite && symbolFont != null)
						symbolFont.DrawTextWithContrast(InfiniteSymbol,
							icon.Pos + infiniteOffset,
							TextColor, Color.Black, 1);
					else if (total > 1 || waiting)
					{
						var pos = QueuedOffset;
						if (QueuedTextAlign != TextAlign.Left)
						{
							var size = overlayFont.Measure(total.ToString(NumberFormatInfo.CurrentInfo));

							pos = QueuedTextAlign == TextAlign.Center ?
								new Vector2(QueuedOffset.X - size.X / 2, QueuedOffset.Y) :
								new Vector2(QueuedOffset.X - size.X, QueuedOffset.Y);
						}

						overlayFont.DrawTextWithContrast(total.ToString(NumberFormatInfo.CurrentInfo),
							icon.Pos + pos,
							TextColor, Color.Black, 1);
					}
				}

				if (CurrentQueue is BulkProductionQueue bulkProductionQueue)
				{
					var readyActors = bulkProductionQueue.GetActorsReadyForDelivery().
						Count(a => a.Actor.Name == icon.Name);
					overlayFont.DrawTextWithContrast(readyActors.ToString(NumberFormatInfo.CurrentInfo),
						icon.Pos + BulkOffset, TextColor, Color.Black, 1);
				}
			}

			// Queue Control Panel
			if (selectedIcon != null && CurrentQueue != null)
			{
				var selEntry = icons.FirstOrDefault(kvp => kvp.Value.Name == selectedIcon.Name);
				if (selEntry.Value != null)
				{
					var selRect = selEntry.Key;
					var selTl = new Vector3(selRect.Left, selRect.Top, 0);
					var selBr = new Vector3(selRect.Right, selRect.Bottom, 0);
					Game.Renderer.RgbaColorRenderer.DrawRect(selTl, selBr, 2, Color.Gold);
				}

				var factionSuffix = ResolveFactionSuffix();
				var panelBackground = ResolveFirstCollection(
					factionSuffix != null ? "panel-black-" + factionSuffix : null,
					"dialog4",
					"panel-black");
				var buttonImage = ResolveFirstCollection(
					factionSuffix != null ? "sidebar-button-" + factionSuffix : null,
					"sidebar-button",
					factionSuffix != null ? "button-" + factionSuffix : null,
					"button") ?? "button";

				var panelRect = GetQueuePanelRect();
				var bgPad = panelBackground == "dialog4" ? 4 : 3;
				var bgRect = new Rectangle(panelRect.X - bgPad, panelRect.Y - bgPad, panelRect.Width + 2 * bgPad, panelRect.Height + 2 * bgPad);
				if (panelBackground != null)
					WidgetUtils.DrawPanel(panelBackground, bgRect);
				else
				{
					WidgetUtils.FillRectWithColor(bgRect, Color.FromArgb(190, 15, 15, 20));
					Game.Renderer.RgbaColorRenderer.DrawRect(
						new Vector3(bgRect.Left, bgRect.Top, 0),
						new Vector3(bgRect.Right, bgRect.Bottom, 0),
						1, Color.FromArgb(140, 70, 70, 75));
				}

				var queuedItems = CurrentQueue.AllQueued().Where(a => a.Item == selectedIcon.Name).ToList();
				var firstItem = queuedItems.FirstOrDefault();
				var isPaused = firstItem != null && firstItem.Paused;

				var rallyProducer = GetRallyProducer();
				var hasRallyPoint = IsValidActor(rallyProducer) && rallyProducer.TraitOrDefault<RallyPoint>() != null;
				var isRallyActive = World.OrderGenerator is SetRallyPointOrderGenerator;

				var font = boldFont ?? overlayFont;
				var visualHeight = ChromeMetrics.Get<int>("ButtonDepth");
				var textColorNormal = ChromeMetrics.Get<Color>("ButtonTextColor");
				var textColorDisabled = ChromeMetrics.Get<Color>("ButtonTextColorDisabled");
				var textColorHighlight = Color.FromArgb(255, 220, 90);
				var textShadowColor = ChromeMetrics.Get<Color>("ButtonTextContrastColorDark");
				var iconShadowColor = Color.FromArgb(180, textShadowColor);

				for (var i = 0; i < QueueButtonCount; i++)
				{
					var btnRect = GetQueueButtonRect(i);
					var btnType = (QueueButtonType)i;
					var isPressed = pressedQueueButton == btnType;

					var disabled = false;
					var highlighted = false;

					switch (btnType)
					{
						case QueueButtonType.AddFive:
							break;
						case QueueButtonType.SubtractOne:
							disabled = queuedItems.Count == 0;
							break;
						case QueueButtonType.PauseResume:
							disabled = firstItem == null || CurrentQueue.Info.DisallowPaused;
							highlighted = isPaused;
							break;
						case QueueButtonType.CancelAll:
							disabled = queuedItems.Count == 0;
							break;
						case QueueButtonType.SetRallyPoint:
							disabled = !hasRallyPoint;
							highlighted = isRallyActive;
							break;
						case QueueButtonType.Close:
							break;
					}

					ButtonWidget.DrawBackground(buttonImage, btnRect, disabled, isPressed || highlighted, false, highlighted);

					var contentOffset = (isPressed || highlighted) ? new Vector2(visualHeight, visualHeight) : Vector2.Zero;
					var textColor = disabled ? textColorDisabled : (highlighted ? textColorHighlight : textColorNormal);

					switch (btnType)
					{
						case QueueButtonType.AddFive:
						{
							const string text = "+5";
							var textSize = font.Measure(text);
							var textPos = new Vector2(
								btnRect.X + (btnRect.Width - textSize.X) / 2f,
								btnRect.Y + (btnRect.Height - textSize.Y) / 2f) + contentOffset;
							font.DrawTextWithShadow(text, textPos, textColor, textShadowColor, 1);
							break;
						}

						case QueueButtonType.SubtractOne:
						{
							const string text = "-1";
							var textSize = font.Measure(text);
							var textPos = new Vector2(
								btnRect.X + (btnRect.Width - textSize.X) / 2f,
								btnRect.Y + (btnRect.Height - textSize.Y) / 2f) + contentOffset;
							font.DrawTextWithShadow(text, textPos, textColor, textShadowColor, 1);
							break;
						}

						case QueueButtonType.PauseResume:
						{
							var text = isPaused ? ">" : "||";
							var textSize = font.Measure(text);
							var textPos = new Vector2(
								btnRect.X + (btnRect.Width - textSize.X) / 2f,
								btnRect.Y + (btnRect.Height - textSize.Y) / 2f) + contentOffset;
							font.DrawTextWithShadow(text, textPos, textColor, textShadowColor, 1);
							break;
						}

						case QueueButtonType.CancelAll:
						{
							var cx = btnRect.X + btnRect.Width / 2f + contentOffset.X;
							var cy = btnRect.Y + btnRect.Height / 2f + contentOffset.Y;
							const float r = 7.5f;

							// Shadow (1px offset)
							DrawCircleWithSlash(cx + 1, cy + 1, r, 16, iconShadowColor);

							// Foreground
							DrawCircleWithSlash(cx, cy, r, 16, textColor);
							break;
						}

						case QueueButtonType.SetRallyPoint:
						{
							var cx = btnRect.X + btnRect.Width / 2f + contentOffset.X;
							var cy = btnRect.Y + btnRect.Height / 2f + contentOffset.Y;

							// Shadow (1px offset)
							DrawFlagIcon(cx + 1, cy + 1, iconShadowColor);

							// Foreground
							DrawFlagIcon(cx, cy, textColor);
							break;
						}

						case QueueButtonType.Close:
						{
							const string text = "X";
							var textSize = font.Measure(text);
							var textPos = new Vector2(
								btnRect.X + (btnRect.Width - textSize.X) / 2f,
								btnRect.Y + (btnRect.Height - textSize.Y) / 2f) + contentOffset;
							font.DrawTextWithShadow(text, textPos, textColor, textShadowColor, 1);
							break;
						}
					}
				}
			}
		}

		string ResolveFactionSuffix()
		{
			var faction = World.LocalPlayer?.Faction.InternalName;
			if (string.IsNullOrEmpty(faction))
				return null;

			return ChromeMetrics.TryGet<string>($"FactionSuffix-{faction}", out var mapped)
				? mapped
				: faction;
		}

		static string ResolveFirstCollection(params string[] candidates)
		{
			foreach (var candidate in candidates)
			{
				if (!string.IsNullOrEmpty(candidate) && ChromeProvider.Collections.ContainsKey(candidate))
					return candidate;
			}

			return null;
		}

		static void DrawCircleWithSlash(float cx, float cy, float r, int segments, Color color)
		{
			var cr = Game.Renderer.RgbaColorRenderer;
			var step = (float)(2 * Math.PI / segments);
			for (var s = 0; s < segments; s++)
			{
				var a1 = s * step;
				var a2 = (s + 1) * step;
				var p1 = new Vector3(cx + r * (float)Math.Cos(a1), cy + r * (float)Math.Sin(a1), 0);
				var p2 = new Vector3(cx + r * (float)Math.Cos(a2), cy + r * (float)Math.Sin(a2), 0);
				cr.DrawLine(p1, p2, 2f, color);
			}

			var offset = r * 0.7071f;
			var start = new Vector3(cx - offset, cy - offset, 0);
			var end = new Vector3(cx + offset, cy + offset, 0);
			cr.DrawLine(start, end, 2f, color);
		}

		static void DrawFlagIcon(float cx, float cy, Color color)
		{
			var cr = Game.Renderer.RgbaColorRenderer;

			// Flag pole: vertical line
			cr.DrawLine(new Vector3(cx - 4f, cy - 8f, 0), new Vector3(cx - 4f, cy + 8f, 0), 2f, color);

			// Pole base: horizontal line
			cr.DrawLine(new Vector3(cx - 7f, cy + 8f, 0), new Vector3(cx - 1f, cy + 8f, 0), 2f, color);

			// Flag cloth: triangle
			var pTop = new Vector3(cx - 3f, cy - 8f, 0);
			var pTip = new Vector3(cx + 6f, cy - 4f, 0);
			var pBottom = new Vector3(cx - 3f, cy, 0);
			cr.FillRect(pTop, pTip, pBottom, pBottom, color);
		}

		public override string GetCursor(int2 pos)
		{
			if (selectedIcon != null && GetQueuePanelRect().Contains(pos))
				return base.GetCursor(pos);

			var icon = icons.Where(i => i.Key.Contains(pos))
				.Select(i => i.Value).FirstOrDefault();

			return icon != null ? base.GetCursor(pos) : null;
		}
	}
}
