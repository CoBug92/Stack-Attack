import SwiftUI

struct ManipulatorAppearanceSection: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		OverlayAppearanceSelectionView(
			previewContent: .manipulator(game.selectedManipulatorAppearance),
			options: ManipulatorAppearance.allCases,
			selectedOption: game.selectedManipulatorAppearance,
			title: \.title,
			description: \.description,
			selectionAction: game.selectManipulatorAppearance
		)
	}
}

// MARK: - Preview

#Preview {
	ManipulatorAppearanceSection(game: FlowPreviewSupport.makeGame(overlayScreen: .manipulatorAppearance))
		.padding(Margin.x8)
		.background(FlowPreviewSupport.canvas)
}
