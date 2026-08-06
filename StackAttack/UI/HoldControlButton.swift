import SwiftUI

struct HoldControlButton: View {
	let symbol: String
	let label: String
	var onPressedChanged: ((Bool) -> Void)?
	var onTap: (() -> Void)?

	@State private var isPressed = false

	private let lime = Color(red: 0.776, green: 0.937, blue: 0.38)
	private let surface = Color(red: 0.08, green: 0.14, blue: 0.2)
	private let border = Color(red: 0.25, green: 0.33, blue: 0.38)

	var body: some View {
		Image(systemName: symbol)
			.font(.system(size: 23, weight: .black))
			.foregroundColor(isPressed ? lime : .white)
			.frame(width: 82, height: 54)
			.background(surface)
			.clipShape(RoundedRectangle(cornerRadius: 5))
			.overlay {
				RoundedRectangle(cornerRadius: 5)
					.stroke(
						isPressed
							? lime
							: border
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
