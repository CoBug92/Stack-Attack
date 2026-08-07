import SwiftUI

struct GameOverlaySecondaryButton: View {
	// MARK: - Properties

	let title: String
	let border: Color
	let surface: Color
	let action: () -> Void

	// MARK: - Body

	var body: some View {
		Button(action: action) {
			Text(title)
				.appTypography(.secondaryButton)
				.foregroundColor(Color.Theme.white)
				.frame(maxWidth: .infinity)
				.frame(height: .secondaryButtonHeight)
				.background(surface.opacity(.secondaryButtonSurfaceOpacity))
				.clipShape(RoundedRectangle(cornerRadius: .secondaryButtonCornerRadius))
				.overlay {
					RoundedRectangle(cornerRadius: .secondaryButtonCornerRadius)
						.stroke(border)
				}
		}
		.buttonStyle(.plain)
	}
}

// MARK: - Preview

#Preview {
	GameOverlaySecondaryButton(
		title: "НАСТРОЙКИ",
		border: FlowPreviewSupport.border,
		surface: FlowPreviewSupport.surface,
		action: {}
	)
	.padding(Margin.x8)
	.background(FlowPreviewSupport.canvas)
}

// MARK: - Constants

private extension CGFloat {
	static let secondaryButtonHeight = 44.0
	static let secondaryButtonCornerRadius = 4.0
}

private extension Double {
	static let secondaryButtonSurfaceOpacity = 0.55
}
