import SwiftUI

struct OverlayAppearanceSelectionView<Option: Identifiable & Hashable>: View {
	// MARK: - Properties

	let previewContent: AppearancePreviewView.Content
	let options: [Option]
	let selectedOption: Option
	let title: (Option) -> String
	let description: (Option) -> String
	let selectionAction: (Option) -> Void

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: Margin.x7) {
			AppearancePreviewView(content: previewContent)

			VStack(spacing: Margin.x2) {
				ForEach(options) { option in
					Button {
						selectionAction(option)
					} label: {
						AppearanceSelectionCard(
							title: title(option),
							description: description(option),
							isSelected: option == selectedOption
						)
					}
					.buttonStyle(.plain)
				}
			}
		}
	}
}

// MARK: - Preview

#Preview {
	OverlayAppearanceSelectionView(
		previewContent: .player(.cyberLoader),
		options: PlayerAppearance.allCases,
		selectedOption: .cyberLoader,
		title: \.title,
		description: \.description,
		selectionAction: { _ in }
	)
	.padding(Margin.x8)
	.background(FlowPreviewSupport.canvas)
}
