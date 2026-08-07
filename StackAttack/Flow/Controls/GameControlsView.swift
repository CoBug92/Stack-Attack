import SwiftUI

struct GameControlsView: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		HStack(spacing: Margin.x6) {
			HoldControlButton(
				symbol: SFSymbols.arrowLeft,
				label: Localizations.Control.left,
				onPressedChanged: { game.setDirection(-1, isPressed: $0) }
			)

			HoldControlButton(
				symbol: SFSymbols.arrowUp,
				label: Localizations.Control.jump,
				onTap: game.pressJump
			)

			HoldControlButton(
				symbol: SFSymbols.arrowRight,
				label: Localizations.Control.right,
				onPressedChanged: { game.setDirection(1, isPressed: $0) }
			)
		}
		.allowsHitTesting(game.phase == .playing)
	}
}

// MARK: - Preview

#Preview("Playing") {
	GameControlsView(game: FlowPreviewSupport.makeGame(phase: .playing))
		.padding(Margin.x8)
		.background(FlowPreviewSupport.canvas)
}

#Preview("Ready") {
	GameControlsView(game: FlowPreviewSupport.makeGame())
		.padding(Margin.x8)
		.background(FlowPreviewSupport.canvas)
}
