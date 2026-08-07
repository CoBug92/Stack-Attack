import SwiftUI

struct GameControlsView: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		HStack(spacing: Margin.x6) {
			HoldControlButton(
				symbol: SFSymbols.arrowLeft,
				label: .moveLeft,
				onPressedChanged: { game.setDirection(-1, isPressed: $0) }
			)

			HoldControlButton(
				symbol: SFSymbols.arrowUp,
				label: .jump,
				onTap: game.pressJump
			)

			HoldControlButton(
				symbol: SFSymbols.arrowRight,
				label: .moveRight,
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

// MARK: - Constants

private extension String {
	static let moveLeft = "Влево"
	static let jump = "Прыжок"
	static let moveRight = "Вправо"
}
