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
using System.Threading;
using NUnit.Framework;

namespace OpenRA.Test
{
	[TestFixture]
	sealed class TouchInputAdapterTest
	{
		sealed class RecordingInputHandler : IInputHandler
		{
			public readonly List<MouseInput> Events = [];
			public void ModifierKeys(Modifiers mods) { }
			public void OnKeyInput(KeyInput input) { }
			public void OnMouseInput(MouseInput input) { Events.Add(input); }
			public void OnTextInput(string text) { }
		}

		static List<MouseInput> Drain(TouchInputAdapter adapter)
		{
			var handler = new RecordingInputHandler();
			adapter.PumpInputs(handler);
			return handler.Events;
		}

		[TestCase(TestName = "Reset releases stuck box selection and clears active fingers")]
		public void ResetReleasesStuckBoxSelect()
		{
			var adapter = new TouchInputAdapter(_ => false);
			adapter.Reset();
			Drain(adapter);

			adapter.OnFingerDown(1, new int2(200, 200));
			Assert.That(adapter.HasActiveFinger(1), Is.True);
			Assert.That(adapter.IsHolding, Is.True);

			// Simulate long-press hold elapsing to enter BoxSelecting
			Thread.Sleep(adapter.LongPressThresholdMs + 50);
			var heldEvents = Drain(adapter);
			Assert.That(heldEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Left && m.Event == MouseInputEvent.Down));

			// Window focus loss / suspend must cancel box selection with a matching Left Up
			adapter.Reset();
			Assert.That(adapter.HasActiveFinger(1), Is.False);
			Assert.That(adapter.IsHolding, Is.False);

			var resetEvents = Drain(adapter);
			Assert.That(resetEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Left && m.Event == MouseInputEvent.Up));
		}

		[TestCase(TestName = "Duplicate finger down after missed finger up closes previous gesture")]
		public void DuplicateFingerDownEndsPreviousGesture()
		{
			var adapter = new TouchInputAdapter(_ => false);
			adapter.Reset();
			Drain(adapter);

			adapter.OnFingerDown(0, new int2(150, 150));
			Thread.Sleep(adapter.LongPressThresholdMs + 50);
			var firstEvents = Drain(adapter);
			Assert.That(firstEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Left && m.Event == MouseInputEvent.Down));

			// Missed FINGERUP followed by new FINGERDOWN on same pointer id must release old Left Down first
			adapter.OnFingerDown(0, new int2(300, 300));
			var nextEvents = Drain(adapter);
			Assert.That(nextEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Left && m.Event == MouseInputEvent.Up));

			adapter.OnFingerUp(0, new int2(300, 300));
			var tapUpEvents = Drain(adapter);
			Assert.That(tapUpEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Left && m.Event == MouseInputEvent.Down));
			Assert.That(tapUpEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Left && m.Event == MouseInputEvent.Up));
		}

		[TestCase(TestName = "Two-finger gesture release clears both active finger ids")]
		public void TwoFingerReleaseClearsBothFingers()
		{
			var adapter = new TouchInputAdapter(_ => false);
			adapter.Reset();
			Drain(adapter);

			adapter.OnFingerDown(10, new int2(100, 100));
			adapter.OnFingerDown(11, new int2(200, 100));
			var startEvents = Drain(adapter);
			Assert.That(startEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Middle && m.Event == MouseInputEvent.Down));

			adapter.OnFingerUp(10, new int2(100, 100));
			var endEvents = Drain(adapter);
			Assert.That(endEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Middle && m.Event == MouseInputEvent.Up));
			Assert.That(adapter.HasActiveFinger(10), Is.False);
			Assert.That(adapter.HasActiveFinger(11), Is.False);
		}

		[TestCase(TestName = "Swipe before hold threshold pans instead of starting immediate box selection")]
		public void SwipeBeforeHoldPansMap()
		{
			var adapter = new TouchInputAdapter(_ => false);
			adapter.Reset();
			Drain(adapter);

			adapter.OnFingerDown(2, new int2(200, 200));
			Assert.That(Drain(adapter), Is.Empty);

			adapter.OnFingerMotion(2, new int2(250, 200));
			var panEvents = Drain(adapter);
			Assert.That(panEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Middle && m.Event == MouseInputEvent.Down));
			Assert.That(panEvents, Has.None.Matches<MouseInput>(m => m.Button == MouseButton.Left));

			adapter.OnFingerUp(2, new int2(250, 200));
			var upEvents = Drain(adapter);
			Assert.That(upEvents, Has.Some.Matches<MouseInput>(m => m.Button == MouseButton.Middle && m.Event == MouseInputEvent.Up));
		}
	}
}
