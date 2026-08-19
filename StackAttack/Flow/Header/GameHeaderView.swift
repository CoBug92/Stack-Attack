import SwiftUI

struct GameHeaderView: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Computed properties

	private var isStartButtonEnabled: Bool {
		game.phase == .ready
			|| game.phase == .knockedOut
			|| game.phase == .gameOver
	}

	private var startPauseButtonImage: Image {
		Image(
			systemName: game.phase == .paused
				? SFSymbols.playFill
				: SFSymbols.pauseFill
		)
	}

	private var hapticButtonImage: Image {
		Image(
			systemName: game.hapticsEnabled
				? SFSymbols.iphoneRadiowavesLeftAndRight
				: SFSymbols.iphoneSlash
		)
	}

	private var soundButtonImage: Image {
		Image(
			systemName: game.soundEnabled
				? SFSymbols.speakerWave2Fill
				: SFSymbols.speakerSlashFill
		)
	}

	// MARK: - Body

	var body: some View {
		HStack(alignment: .center) {
			Text(verbatim: Localizations.App.title)
				.appTypography(.appTitle)
				.foregroundColor(Color.Theme.white)

			Spacer()

			HStack(spacing: Margin.x4) {
				GameHeaderIconButton(
					action: game.toggleSound
				) {
					soundButtonImage
						.font(
							.system(
								size: .soundIconSize,
								weight: .black
							)
						)
						.foregroundColor(game.soundEnabled ? Color.Theme.uiAccentLime : Color.HUD.textMuted)
				}

				GameHeaderIconButton(
					action: game.toggleHaptics
				) {
					hapticButtonImage
						.font(
							.system(
								size: .hapticsIconSize,
								weight: .black
							)
						)
						.foregroundColor(game.hapticsEnabled ? Color.Theme.uiAccentLime : Color.HUD.textMuted)
				}

				GameHeaderIconButton(
					action: game.togglePause
				) {
					startPauseButtonImage
						.font(
							.system(
								size: .pauseIconSize,
								weight: .black
							)
						)
						.foregroundColor(Color.HUD.textMuted)
				}
				.disabled(isStartButtonEnabled)
			}
		}
	}
}

// MARK: - Constants

private extension CGFloat {
	static let soundIconSize: CGFloat = 14
	static let hapticsIconSize: CGFloat = 13
	static let pauseIconSize: CGFloat = 14
}

// MARK: - Preview

#Preview("Playing") {
	FlowPreviewSupport.canvas
		.overlay {
			VStack {
				GameHeaderView(
					game: FlowPreviewSupport.makeGame(phase: .playing)
				)
				GameHeaderView(
					game: FlowPreviewSupport.makeGame(phase: .paused)
				)
			}
		}
		.ignoresSafeArea()
}
