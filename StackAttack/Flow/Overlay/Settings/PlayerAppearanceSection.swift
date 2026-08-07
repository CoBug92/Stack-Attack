import SwiftUI

struct PlayerAppearanceSection: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		OverlayAppearanceSelectionView(
			previewContent: .player(game.selectedPlayerAppearance),
			options: PlayerAppearance.allCases,
			selectedOption: game.selectedPlayerAppearance,
			title: \.title,
			description: \.description,
			selectionAction: game.selectPlayerAppearance
		)
	}
}

// MARK: - Preview

#Preview {
	PlayerAppearanceSection(game: FlowPreviewSupport.makeGame(overlayScreen: .playerAppearance))
		.padding(Margin.x8)
		.background(FlowPreviewSupport.canvas)
}
