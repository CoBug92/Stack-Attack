import SwiftUI

struct GameBackgroundView: View {
	// MARK: - Body

	var body: some View {
		ZStack {
			Color.Background.canvas
				.ignoresSafeArea()

			LinearGradient(
				colors: [Color.Background.atmosphere, .clear],
				startPoint: .top,
				endPoint: .center
			)
			.opacity(.backgroundAtmosphereOpacity)
			.ignoresSafeArea()
		}
	}
}

// MARK: - Preview

#Preview {
	GameBackgroundView()
}

// MARK: - Constants

private extension Double {
	static let backgroundAtmosphereOpacity = 0.65
}
