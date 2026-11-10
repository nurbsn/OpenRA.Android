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

using System.Collections.Generic;
using OpenRA.Graphics;
using OpenRA.Mods.Common.Graphics;
using OpenRA.Mods.Common.Traits;
using OpenRA.Orders;
using OpenRA.Primitives;
using OpenRA.Traits;

namespace OpenRA.Mods.Common.Orders
{
	public class SetRallyPointOrderGenerator : IOrderGenerator
	{
		readonly Actor producer;
		readonly RallyPoint rallyPoint;

		public SetRallyPointOrderGenerator(Actor producer, RallyPoint rallyPoint)
		{
			this.producer = producer;
			this.rallyPoint = rallyPoint;
		}

		public MouseButton ActionButton => Game.Settings.Game.ResolveActionButton(MouseActionType.GlobalCommand);
		public MouseButton CancelButton => Game.Settings.Game.ResolveCancelButton(MouseActionType.GlobalCommand);

		public IEnumerable<Order> Order(World world, CPos cell, int2 worldPixel, MouseInput mi)
		{
			if (mi.Button == ActionButton && mi.Event == MouseInputEvent.Down)
			{
				if (!world.Map.Contains(cell) || !producer.IsInWorld || producer.IsDead)
				{
					world.CancelInputMode();
					return [];
				}

				Game.Sound.PlayNotification(world.Map.Rules, producer.Owner, "Speech", rallyPoint.Info.Notification, producer.Owner.Faction.InternalName);
				TextNotificationsManager.AddTransientLine(producer.Owner, rallyPoint.Info.TextNotification);

				world.CancelInputMode();
				var target = Target.FromCell(world, cell);
				return [new Order("SetRallyPoint", producer, target, false) { SuppressVisualFeedback = true }];
			}

			if (mi.Button == CancelButton && mi.Event == MouseInputEvent.Up)
				world.CancelInputMode();

			return [];
		}

		public void Tick(World world)
		{
			if (!producer.IsInWorld || producer.IsDead || (world.LocalPlayer != null && world.LocalPlayer.WinState != WinState.Undefined))
				world.CancelInputMode();
		}

		public IEnumerable<IRenderable> Render(WorldRenderer wr, World world) { yield break; }

		public IEnumerable<IRenderable> RenderAboveShroud(WorldRenderer wr, World world)
		{
			if (!producer.IsInWorld || producer.IsDead)
				yield break;

			var mouseCell = wr.Viewport.ViewToWorld(Viewport.LastMousePos);
			if (!world.Map.Contains(mouseCell))
				yield break;

			var exit = producer.NearestExitOrDefault(world.Map.CenterOfCell(mouseCell));
			var start = producer.CenterPosition + (exit?.Info.SpawnOffset ?? WVec.Zero);
			var end = world.Map.CenterOfCell(mouseCell);

			yield return new LineAnnotationRenderable(start, end, 2, Color.FromArgb(200, Color.White));
		}

		public IEnumerable<IRenderable> RenderAnnotations(WorldRenderer wr, World world) { yield break; }

		public string GetCursor(World world, CPos cell, int2 worldPixel, MouseInput mi)
		{
			return world.Map.Contains(cell) ? rallyPoint.Info.Cursor : "generic-blocked";
		}

		public void Deactivate() { }

		public bool HandleKeyPress(KeyInput e)
		{
			if (e.Key == Keycode.ESCAPE)
			{
				producer.World.CancelInputMode();
				return true;
			}

			return false;
		}

		public void SelectionChanged(World world, IEnumerable<Actor> selected) { }
	}
}
