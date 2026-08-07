import SwiftUI

struct ContentView: View {
	// MARK: - Properties

	@Environment(\.scenePhase) private var scenePhase
	@StateObject private var game = GameController(settingsStore: UserDefaultsGameSettingsStore())

	// MARK: - Body

	var body: some View {
		GeometryReader { proxy in
			let horizontalInset = Margin.x7
			let availableGameWidth = max(proxy.size.width - (horizontalInset * 2), 0)

			ZStack {
				GameBackgroundView()

				VStack(spacing: 0) {
					GameHeaderView(game: game)
						.padding(.horizontal, Margin.x9)
						.padding(.bottom, Margin.x6)

					GameScoreboardView(game: game)
						.padding(.horizontal, horizontalInset)

					GameAreaView(
						game: game,
						maxWidth: availableGameWidth,
						maxHeight: proxy.size.height * .gameAreaHeightRatio
					)
					.padding(.horizontal, horizontalInset)

					GameControlsView(game: game)
						.padding(.top, Margin.x7)
				}
				.padding(.top, Margin.x4)
				.padding(.bottom, Margin.x4)

				if game.showsOverlay {
					GameOverlayCard(
						game: game,
						lime: Color.Theme.uiAccentLime,
						orange: Color.Theme.uiAccentOrange,
						maxHeight: proxy.size.height - (Margin.x6 * 2)
					)
					.padding(.horizontal, Margin.x7)
					.padding(.vertical, Margin.x6)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
					.transition(.opacity.combined(with: .scale(scale: .contentOverlayScale)))
					.zIndex(.contentOverlayZIndex)
				}
			}
			.animation(.easeOut(duration: .contentOverlayAnimationDuration), value: game.phase)
			.animation(.easeOut(duration: .contentOverlayAnimationDuration), value: game.showsOverlaySettings)
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
				if arguments.contains(.autoStartArgument) || arguments.contains(.autoPlayArgument),
					game.phase == .ready {
					game.performPrimaryAction()
				}
			}
		#endif
	}
}

// MARK: - Preview

#Preview {
	ContentView()
}

// MARK: - Constants

private extension CGFloat {
	static let gameAreaHeightRatio = 0.7
	static let contentOverlayScale = 0.97
}

private extension Double {
	static let contentOverlayAnimationDuration = 0.18
	static let contentOverlayZIndex = 1.0
}

private extension String {
	static let autoStartArgument = "--auto-start"
	static let autoPlayArgument = "--auto-play"
}
