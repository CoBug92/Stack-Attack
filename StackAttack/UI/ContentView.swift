import SpriteKit
import SwiftUI

struct ContentView: View {
	// MARK: - Properties

	@Environment(\.scenePhase) private var scenePhase
	@StateObject private var game = GameController(settingsStore: UserDefaultsGameSettingsStore())

	private let lime = Color(red: 0.776, green: 0.937, blue: 0.38)
	private let orange = Color(red: 1, green: 0.51, blue: 0.28)
	private let canvas = Color(red: 0.035, green: 0.067, blue: 0.11)
	private let atmosphere = Color(red: 0.12, green: 0.22, blue: 0.28)
	private let playfieldBackground = Color(red: 0.05, green: 0.09, blue: 0.14)
	private let hudSurface = Color(red: 0.06, green: 0.1, blue: 0.15)
	private let hudPanel = Color(red: 0.065, green: 0.11, blue: 0.165)
	private let hudDivider = Color(red: 0.18, green: 0.26, blue: 0.31)
	private let hudMuted = Color(red: 0.57, green: 0.65, blue: 0.61)
	private let hudValue = Color(red: 0.56, green: 0.65, blue: 0.61)

	// MARK: - Body

	var body: some View {
		GeometryReader { proxy in
			let horizontalInset: CGFloat = 14
			let availableGameWidth = max(proxy.size.width - (horizontalInset * 2), 0)

			ZStack {
				canvas
					.ignoresSafeArea()

				LinearGradient(
					colors: [atmosphere, .clear],
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
						.padding(.horizontal, horizontalInset)

					gameArea(
						maxWidth: availableGameWidth,
						maxHeight: proxy.size.height * 0.7
					)
					.padding(.horizontal, horizontalInset)

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
				Text("ПОРТ №35")
					.font(.system(size: 9, weight: .bold, design: .monospaced))
					.tracking(2)
					.foregroundColor(orange)
				Text("STACK ATTACK")
					.font(.system(size: 25, weight: .black, design: .monospaced))
					.tracking(-1.5)
					.foregroundColor(.white)
			}
			Spacer()
			Button(action: game.togglePause) {
				Image(systemName: game.phase == .paused ? "play.fill" : "pause.fill")
					.font(.system(size: 14, weight: .black))
			}
			.buttonStyle(.plain)
			.foregroundColor(hudMuted)
			.frame(width: 38, height: 36)
			.background(hudSurface)
			.clipShape(RoundedRectangle(cornerRadius: 4))
			.overlay {
				RoundedRectangle(cornerRadius: 4)
					.stroke(hudDivider)
			}
			.disabled(game.phase == .ready || game.phase == .knockedOut || game.phase == .gameOver)
		}
		.foregroundColor(.white)
	}

	private var scoreboard: some View {
		HStack {
			scoreItem(
				label: "СЧЁТ", value: padded(game.score, length: 6), alignment: .leading)
			Spacer()
			scoreItem(
				label: "РЕКОРД",
				value: padded(max(game.score, game.highScore), length: 6),
				alignment: .center
			)
			Spacer()
			scoreItem(
				label: "УРОВЕНЬ", value: padded(game.level, length: 2), alignment: .trailing)
		}
		.padding(.horizontal, 13)
		.padding(.vertical, 10)
		.background(hudPanel)
		.overlay(alignment: .top) {
			Rectangle()
				.fill(hudDivider)
				.frame(height: 1)
		}
	}

	private func scoreItem(label: String, value: String, alignment: HorizontalAlignment) -> some View {
		VStack(alignment: alignment, spacing: 3) {
			Text(label)
				.font(.system(size: 8, weight: .regular, design: .monospaced))
				.tracking(1.2)
				.foregroundColor(hudValue)
			Text(value)
				.font(.system(size: 17, weight: .bold, design: .monospaced))
				.tracking(1.2)
				.foregroundColor(lime)
				.contentTransition(.numericText())
		}
	}

	private func gameArea(maxWidth: CGFloat, maxHeight: CGFloat) -> some View {
		ZStack {
			SpriteView(scene: game.scene, options: [.ignoresSiblingOrder])
				.aspectRatio(3 / 4, contentMode: .fit)
				.frame(maxWidth: maxWidth, maxHeight: maxHeight)
				.background(playfieldBackground)
				.clipShape(RoundedRectangle(cornerRadius: 4))
				.overlay {
					RoundedRectangle(cornerRadius: 4)
						.stroke(hudDivider)
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
				label: "Влево",
				onPressedChanged: { game.setDirection(-1, isPressed: $0) }
			)
			HoldControlButton(symbol: "arrow.up", label: "Прыжок", onTap: game.pressJump)
			HoldControlButton(
				symbol: "arrow.right",
				label: "Вправо",
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
