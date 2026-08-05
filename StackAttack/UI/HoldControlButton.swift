import SwiftUI

struct HoldControlButton: View {
	let symbol: String
	let label: String
	var onPressedChanged: ((Bool) -> Void)?
	var onTap: (() -> Void)?

	@State private var isPressed = false

	var body: some View {
		Image(systemName: symbol)
			.font(.system(size: 23, weight: .black))
			.foregroundStyle(isPressed ? Color(.Button.primary) : Color(.Theme.onDark))
			.frame(width: 82, height: 54)
			.background(Color(.Button.surface))
			.clipShape(RoundedRectangle(cornerRadius: 5))
			.overlay {
				RoundedRectangle(cornerRadius: 5)
					.stroke(
						isPressed
							? Color(.Button.primary)
							: Color(.Button.border)
					)
			}
			.scaleEffect(isPressed ? 0.96 : 1)
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
