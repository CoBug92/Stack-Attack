import SwiftUI

struct HoldControlButton: View {
	// MARK: - Properties

	let symbol: String
	let label: String
	var onPressedChanged: ((Bool) -> Void)?
	var onTap: (() -> Void)?

	@State private var isPressed = false

	// MARK: - Body

	var body: some View {
		Image(systemName: symbol)
			.font(.system(size: .holdButtonIconSize, weight: .black))
			.foregroundColor(isPressed ? Color.Theme.uiAccentLime : Color.Theme.white)
			.frame(width: .holdButtonWidth, height: .holdButtonHeight)
			.background(Color.Button.holdSurface)
			.clipShape(RoundedRectangle(cornerRadius: .holdButtonCornerRadius))
			.overlay {
				RoundedRectangle(cornerRadius: .holdButtonCornerRadius)
					.stroke(
						isPressed
							? Color.Theme.uiAccentLime
							: Color.Button.holdBorder
					)
			}
			.scaleEffect(isPressed ? .holdButtonPressedScale : 1)
			.contentShape(Rectangle())
			.accessibilityLabel(label)
			.gesture(
				DragGesture(minimumDistance: 0)
					.onChanged { _ in
						guard !isPressed else { return }
						isPressed = true
						onPressedChanged?(true)
						onTap?()
					}
					.onEnded { _ in
						isPressed = false
						onPressedChanged?(false)
					}
			)
	}
}

// MARK: - Preview

#Preview {
	HoldControlButton(
		symbol: SFSymbols.arrowUp,
		label: "Прыжок",
		onTap: {}
	)
	.padding(Margin.x8)
	.background(FlowPreviewSupport.canvas)
}

// MARK: - Constants

private extension CGFloat {
	static let holdButtonIconSize = 23.0
	static let holdButtonWidth = 82.0
	static let holdButtonHeight = 54.0
	static let holdButtonCornerRadius = 5.0
	static let holdButtonPressedScale = 0.96
}
