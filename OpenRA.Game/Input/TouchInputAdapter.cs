using System;
using System.Collections.Concurrent;
using System.Diagnostics;
using OpenRA.Primitives;
using OpenRA.Widgets;

namespace OpenRA
{
	public class TouchInputAdapter
	{
		const int SwipeMoveThreshold = 15;

		enum GestureMode
		{
			None,
			Undecided,
			SingleFingerPanning,
			BoxSelecting,
			TwoFingerGesture,
			DirectUIInteraction
		}

		public static TouchInputAdapter Instance { get; } = new();

		static bool IsUIInteraction(int2 pos)
		{
			if (Ui.CurrentWindow() != null)
				return true;

			if (Game.OrderManager?.World == null || Game.OrderManager.World.Type != WorldType.Regular)
				return true;

			var menuRoot = Ui.Root?.GetOrNull("MENU_ROOT");
			if (menuRoot != null)
			{
				foreach (var child in menuRoot.Children)
					if (child.IsVisible())
						return true;
			}

			return IsOverInteractiveWidget(Ui.Root, pos);
		}

		static bool IsOverInteractiveWidget(Widget w, int2 pos)
		{
			if (w == null || !w.IsVisible())
				return false;

			if (w.Id is "INTERACTION_CONTROLLER" or "WORLD_KEYHANDLER" or "GLOBAL_KEYHANDLER" or "PERF_ROOT" or "TOOLTIP_CONTAINER" or "MOUSE_ATTATCHMENT" or "CHAT_OVERLAY")
				return false;

			var typeName = w.GetType().Name;
			if (typeName is "WorldInteractionControllerWidget" or "ViewportControllerWidget")
				return false;

			for (var i = w.Children.Count - 1; i >= 0; i--)
				if (IsOverInteractiveWidget(w.Children[i], pos))
					return true;

			if (!w.EventBounds.Contains(pos))
				return false;

			if (typeName.Contains("Button") ||
				typeName.Contains("Checkbox") ||
				typeName.Contains("Palette") ||
				typeName.Contains("SupportPowers") ||
				typeName.Contains("Radar") ||
				typeName.Contains("Slider") ||
				typeName.Contains("ScrollPanel") ||
				typeName.Contains("ScrollItem") ||
				typeName.Contains("TextField") ||
				typeName.Contains("Tabs"))
				return true;

			if (w.Id is "SIDEBAR_BACKGROUND_TOP" or "SIDEBAR_PRODUCTION" or "SIDEBAR_MONEYBIN" or "COMMAND_BAR" or "STANCE_BAR")
				return true;

			return false;
		}

		public bool HasActiveFinger(long fingerId) => firstFingerId == fingerId || secondFingerId == fingerId;

		public int LongPressThresholdMs => Game.Settings?.Game?.TouchHoldDuration ?? 1000;

		public bool IsHolding => gestureMode == GestureMode.Undecided && firstFingerId != null && secondFingerId == null;

		public float HoldProgress
		{
			get
			{
				if (!IsHolding)
					return 0f;

				var elapsed = stopwatch.ElapsedMilliseconds - firstFingerDownTime;
				var threshold = LongPressThresholdMs;
				if (threshold <= 0)
					return 1f;

				return Math.Clamp((float)elapsed / threshold, 0f, 1f);
			}
		}

		public int2 HoldPosition => firstFingerStartPos;
		public int2 HoldCurrentPosition => firstFingerCurrentPos;

		readonly ConcurrentQueue<MouseInput> queue = new();
		readonly Stopwatch stopwatch = Stopwatch.StartNew();

		long? firstFingerId;
		int2 firstFingerStartPos;
		int2 firstFingerCurrentPos;
		int2 previousSinglePanPos;
		long firstFingerDownTime;
		GestureMode gestureMode = GestureMode.None;

		long? secondFingerId;
		int2 secondFingerPos;
		float previousPinchDistance;
		int2 previousPanCenter;

		public void PumpInputs(IInputHandler inputHandler)
		{
			// Check if long press threshold reached while finger is held stationary
			if (gestureMode == GestureMode.Undecided && firstFingerId != null && secondFingerId == null)
			{
				var elapsed = stopwatch.ElapsedMilliseconds - firstFingerDownTime;
				var moveDistance = (firstFingerCurrentPos - firstFingerStartPos).Length;

				if (elapsed >= LongPressThresholdMs && moveDistance <= SwipeMoveThreshold)
				{
					gestureMode = GestureMode.BoxSelecting;
					queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.None, firstFingerStartPos, int2.Zero, Modifiers.None, 0));
					queue.Enqueue(new MouseInput(MouseInputEvent.Down, MouseButton.Left, firstFingerStartPos, int2.Zero, Modifiers.None, 0));
				}
			}

			while (queue.TryDequeue(out var input))
				inputHandler.OnMouseInput(input);
		}

		public void OnFingerDown(long fingerId, int2 pos)
		{
			if (gestureMode == GestureMode.None)
			{
				firstFingerId = null;
				secondFingerId = null;
			}

			if (firstFingerId == null || firstFingerId == fingerId)
			{
				firstFingerId = fingerId;
				firstFingerStartPos = pos;
				firstFingerCurrentPos = pos;
				previousSinglePanPos = pos;
				firstFingerDownTime = stopwatch.ElapsedMilliseconds;

				if (IsUIInteraction(pos))
				{
					gestureMode = GestureMode.DirectUIInteraction;
					queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.None, pos, int2.Zero, Modifiers.None, 0));
					queue.Enqueue(new MouseInput(MouseInputEvent.Down, MouseButton.Left, pos, int2.Zero, Modifiers.None, 1));
				}
				else
				{
					gestureMode = GestureMode.Undecided;
				}
			}
			else if (secondFingerId == null || secondFingerId == fingerId)
			{
				secondFingerId = fingerId;
				secondFingerPos = pos;

				// Cancel any single finger gesture
				if (gestureMode == GestureMode.BoxSelecting || gestureMode == GestureMode.DirectUIInteraction)
					queue.Enqueue(new MouseInput(MouseInputEvent.Up, MouseButton.Left, firstFingerCurrentPos, int2.Zero, Modifiers.None, 0));
				else if (gestureMode == GestureMode.SingleFingerPanning)
					queue.Enqueue(new MouseInput(MouseInputEvent.Up, MouseButton.Middle, previousSinglePanPos, int2.Zero, Modifiers.None, 0));

				gestureMode = GestureMode.TwoFingerGesture;
				previousPanCenter = (firstFingerCurrentPos + secondFingerPos) / 2;
				previousPinchDistance = (firstFingerCurrentPos - secondFingerPos).Length;

				queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.None, previousPanCenter, int2.Zero, Modifiers.None, 0));
				queue.Enqueue(new MouseInput(MouseInputEvent.Down, MouseButton.Middle, previousPanCenter, int2.Zero, Modifiers.None, 0));
			}
		}

		public void OnFingerMotion(long fingerId, int2 pos)
		{
			if (firstFingerId == fingerId)
				firstFingerCurrentPos = pos;
			else if (secondFingerId == fingerId)
				secondFingerPos = pos;

			// Two-finger gestures (Pan & Pinch-to-zoom)
			if (gestureMode == GestureMode.TwoFingerGesture && firstFingerId != null && secondFingerId != null)
			{
				var currentPanCenter = (firstFingerCurrentPos + secondFingerPos) / 2;
				var panDelta = currentPanCenter - previousPanCenter;

				if (panDelta != int2.Zero)
					queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.Middle, currentPanCenter, panDelta, Modifiers.None, 0));

				previousPanCenter = currentPanCenter;

				var currentPinchDistance = (firstFingerCurrentPos - secondFingerPos).Length;
				var pinchDelta = currentPinchDistance - previousPinchDistance;

				if (Math.Abs(pinchDelta) > 15)
				{
					var zoomDelta = pinchDelta > 0 ? 1 : -1;
					queue.Enqueue(new MouseInput(MouseInputEvent.Scroll, MouseButton.None, currentPanCenter, new int2(0, zoomDelta), Modifiers.None, 0));
					previousPinchDistance = currentPinchDistance;
				}

				return;
			}

			if (gestureMode == GestureMode.DirectUIInteraction && firstFingerId != null)
			{
				queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.Left, firstFingerCurrentPos, int2.Zero, Modifiers.None, 0));
				return;
			}

			// Single finger gestures: Swipe (pan) vs Long-press (box selection)
			if (firstFingerId != null && secondFingerId == null)
			{
				var elapsed = stopwatch.ElapsedMilliseconds - firstFingerDownTime;
				var moveDistance = (firstFingerCurrentPos - firstFingerStartPos).Length;

				if (gestureMode == GestureMode.Undecided)
				{
					if (elapsed >= LongPressThresholdMs)
					{
						// Held >= threshold: Enter box selection
						gestureMode = GestureMode.BoxSelecting;
						queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.None, firstFingerStartPos, int2.Zero, Modifiers.None, 0));
						queue.Enqueue(new MouseInput(MouseInputEvent.Down, MouseButton.Left, firstFingerStartPos, int2.Zero, Modifiers.None, 0));
						queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.Left, firstFingerCurrentPos, int2.Zero, Modifiers.None, 0));
					}
					else if (moveDistance > SwipeMoveThreshold)
					{
						// Moved before threshold: Enter swipe-to-pan screen
						gestureMode = GestureMode.SingleFingerPanning;
						queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.None, firstFingerStartPos, int2.Zero, Modifiers.None, 0));
						queue.Enqueue(new MouseInput(MouseInputEvent.Down, MouseButton.Middle, firstFingerStartPos, int2.Zero, Modifiers.None, 0));
						var initialDelta = firstFingerCurrentPos - firstFingerStartPos;
						queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.Middle, firstFingerCurrentPos, initialDelta, Modifiers.None, 0));
						previousSinglePanPos = firstFingerCurrentPos;
					}
				}
				else if (gestureMode == GestureMode.SingleFingerPanning)
				{
					var panDelta = firstFingerCurrentPos - previousSinglePanPos;
					if (panDelta != int2.Zero)
					{
						queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.Middle, firstFingerCurrentPos, panDelta, Modifiers.None, 0));
						previousSinglePanPos = firstFingerCurrentPos;
					}
				}
				else if (gestureMode == GestureMode.BoxSelecting)
				{
					queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.Left, firstFingerCurrentPos, int2.Zero, Modifiers.None, 0));
				}
			}
		}

		public void OnFingerUp(long fingerId, int2 pos)
		{
			if (gestureMode == GestureMode.TwoFingerGesture)
			{
				if (firstFingerId == fingerId || secondFingerId == fingerId)
				{
					queue.Enqueue(new MouseInput(MouseInputEvent.Up, MouseButton.Middle, previousPanCenter, int2.Zero, Modifiers.None, 0));
					gestureMode = GestureMode.None;
				}

				if (firstFingerId == fingerId)
					firstFingerId = null;
				else if (secondFingerId == fingerId)
					secondFingerId = null;

				return;
			}

			if (firstFingerId == fingerId)
			{
				firstFingerId = null;

				if (gestureMode == GestureMode.DirectUIInteraction)
				{
					queue.Enqueue(new MouseInput(MouseInputEvent.Up, MouseButton.Left, pos, int2.Zero, Modifiers.None, 1));
				}
				else if (gestureMode == GestureMode.SingleFingerPanning)
				{
					queue.Enqueue(new MouseInput(MouseInputEvent.Up, MouseButton.Middle, pos, int2.Zero, Modifiers.None, 0));
				}
				else if (gestureMode == GestureMode.BoxSelecting)
				{
					queue.Enqueue(new MouseInput(MouseInputEvent.Up, MouseButton.Left, pos, int2.Zero, Modifiers.None, 0));
				}
				else if (gestureMode == GestureMode.Undecided)
				{
					// Quick single tap (< threshold, < movement threshold): Select, move, attack, or click UI
					queue.Enqueue(new MouseInput(MouseInputEvent.Move, MouseButton.None, pos, int2.Zero, Modifiers.None, 0));
					queue.Enqueue(new MouseInput(MouseInputEvent.Down, MouseButton.Left, pos, int2.Zero, Modifiers.None, 1));
					queue.Enqueue(new MouseInput(MouseInputEvent.Up, MouseButton.Left, pos, int2.Zero, Modifiers.None, 1));
				}

				gestureMode = GestureMode.None;
			}
			else if (secondFingerId == fingerId)
			{
				secondFingerId = null;
			}
		}
	}
}
