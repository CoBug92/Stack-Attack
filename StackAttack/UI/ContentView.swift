import SpriteKit
import SwiftUI

struct ContentView: View {
	// MARK: - Properties

	@Environment(\.scenePhase) private var scenePhase
	@StateObject private var game = GameController(settingsStore: UserDefaultsGameSettingsStore())

	private let lime = Color(.Button.primary)
	private let orange = Color(.Theme.accentOrange)

	// MARK: - Body

	var body: some View {
		GeometryReader { proxy in
			ZStack {
				Color(.Theme.canvas)
					.ignoresSafeArea()

				LinearGradient(
					colors: [Color(.Theme.atmosphere), Color(.Theme.clear)],
					startPoint: .top,
					endPoint: .center
				)
				.opacity(0.65)
				.ignoresSafeArea()

				VStack(spacing: 0) {
					header
						.padding(.horizontal, 18)
						.padding(.bottom, 12)

					scoreboard
						.padding(.horizontal, 14)

					gameArea(maxHeight: proxy.size.height * 0.7)
						.padding(.horizontal, 14)

					controls
						.padding(.top, 14)
				}
				.padding(.top, 8)
				.padding(.bottom, 8)
			}
		}
		.onDisappear {
			game.setDirection(-1, isPressed: false)
			game.setDirection(1, isPressed: false)
		}
		.onChange(of: scenePhase) { _, newPhase in
			if newPhase != .active {
				game.pauseIfNeeded()
			}
		}
		#if DEBUG
			.onAppear {
				let arguments = ProcessInfo.processInfo.arguments
				if arguments.contains("--auto-start") || arguments.contains("--auto-play"),
					game.phase == .ready {
					game.performPrimaryAction()
				}
			}
		#endif
	}

	// MARK: - Private views

	private var header: some View {
		HStack(alignment: .center) {
			VStack(alignment: .leading, spacing: 2) {
				Text(Localizations.Hud.port)
					.font(.system(size: 9, weight: .bold, design: .monospaced))
					.tracking(2)
					.foregroundStyle(orange)
				Text("STACK ATTACK")
					.font(.system(size: 25, weight: .black, design: .monospaced))
					.tracking(-1.5)
			}
			Spacer()
			Button(action: game.togglePause) {
				Image(systemName: game.phase == .paused ? "play.fill" : "pause.fill")
					.font(.system(size: 14, weight: .black))
			}
			.foregroundStyle(Color("HUD/muted"))
			.frame(width: 38, height: 36)
			.background(Color("HUD/surface"))
			.clipShape(RoundedRectangle(cornerRadius: 4))
			.overlay {
				RoundedRectangle(cornerRadius: 4)
					.stroke(Color("HUD/divider"))
			}
			.disabled(game.phase == .ready || game.phase == .knockedOut || game.phase == .gameOver)
		}
	}

	private var scoreboard: some View {
		HStack {
			scoreItem(
				label: Localizations.Hud.score, value: padded(game.score, length: 6), alignment: .leading)
			Spacer()
			scoreItem(
				label: Localizations.Hud.highScore,
				value: padded(max(game.score, game.highScore), length: 6),
				alignment: .center
			)
			Spacer()
			scoreItem(
				label: Localizations.Hud.level, value: padded(game.level, length: 2), alignment: .trailing)
		}
		.padding(.horizontal, 13)
		.padding(.vertical, 10)
		.background(Color("HUD/panel"))
		.overlay(alignment: .top) {
			Rectangle()
				.fill(Color("HUD/divider"))
				.frame(height: 1)
		}
	}

	private func scoreItem(label: String, value: String, alignment: HorizontalAlignment) -> some View {
		VStack(alignment: alignment, spacing: 3) {
			Text(label)
				.font(.system(size: 8, weight: .regular, design: .monospaced))
				.tracking(1.2)
				.foregroundStyle(Color("HUD/value"))
			Text(value)
				.font(.system(size: 17, weight: .bold, design: .monospaced))
				.tracking(1.2)
				.foregroundStyle(lime)
				.contentTransition(.numericText())
		}
	}

	private func gameArea(maxHeight: CGFloat) -> some View {
		ZStack {
			SpriteView(scene: game.scene, options: [.ignoresSiblingOrder])
				.aspectRatio(3 / 4, contentMode: .fit)
				.frame(maxHeight: maxHeight)
				.background(Color(.Theme.canvas))
				.clipShape(RoundedRectangle(cornerRadius: 4))
				.overlay {
					RoundedRectangle(cornerRadius: 4)
						.stroke(Color("HUD/divider"))
				}

			if game.showsOverlay {
				GameOverlayCard(game: game, lime: lime, orange: orange)
					.padding(24)
					.transition(.opacity.combined(with: .scale(scale: 0.97)))
			}
		}
		.frame(maxWidth: .infinity)
		.animation(.easeOut(duration: 0.18), value: game.phase)
	}

	private var controls: some View {
		HStack(spacing: 12) {
			HoldControlButton(
				symbol: "arrow.left",
				label: Localizations.Control.left,
				onPressedChanged: { game.setDirection(-1, isPressed: $0) }
			)
			HoldControlButton(
				symbol: "arrow.up", label: Localizations.Control.jump, onTap: game.pressJump)
			HoldControlButton(
				symbol: "arrow.right",
				label: Localizations.Control.right,
				onPressedChanged: { game.setDirection(1, isPressed: $0) }
			)
		}
		.allowsHitTesting(game.phase == .playing)
	}

	// MARK: - Private methods

	private func padded(_ value: Int, length: Int) -> String {
		String(format: "%0\(length)d", value)
	}
}

// MARK: - Preview

#Preview {
	ContentView()
}
