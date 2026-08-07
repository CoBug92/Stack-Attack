import SwiftUI

struct GameHeaderIconButton<Label: View>: View {

	// MARK: - Properties

	let action: () -> Void
	@ViewBuilder let label: () -> Label

	// MARK: - Body

	var body: some View {
		Button(action: action) {
			label()
                .frame(equal: .buttonLenght)
				.background(Color.HUD.surface)
				.clipShape(
					RoundedRectangle(
                        cornerRadius: .buttonCornerRadius
					)
				)
				.overlay {
					RoundedRectangle(
						cornerRadius: .buttonCornerRadius
					)
					.stroke(Color.HUD.divider)
				}
		}
		.buttonStyle(.plain)
	}
}

// MARK: - Preview

#Preview {
	GameHeaderIconButton(action: {}) {
		Image(systemName: SFSymbols.pauseFill)
			.font(.system(size: 14, weight: .black))
			.foregroundColor(FlowPreviewSupport.lime)
	}
}

// MARK: - Constants

private extension CGFloat {
    static let buttonLenght: CGFloat = 38
	static let buttonCornerRadius: CGFloat = 4
}
