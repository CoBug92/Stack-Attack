import SwiftUI

struct BackgroundAppearanceSection: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		OverlayAppearanceSelectionView(
			previewContent: .background(game.selectedBackgroundAppearance),
			options: BackgroundAppearance.allCases,
			selectedOption: game.selectedBackgroundAppearance,
			title: \.title,
			description: \.description,
			selectionAction: game.selectBackgroundAppearance
		)
	}
}

// MARK: - Preview

#Preview {
	BackgroundAppearanceSection(game: FlowPreviewSupport.makeGame(overlayScreen: .backgroundAppearance))
		.padding(Margin.x8)
		.background(FlowPreviewSupport.canvas)
}
