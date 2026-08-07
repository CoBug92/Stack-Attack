import SwiftUI

struct GameScoreItemView: View {

    // MARK: - Properties

    let label: String
    let value: String
    let alignment: HorizontalAlignment

    // MARK: - Body

    var body: some View {
        VStack(alignment: alignment, spacing: Margin.x2) {
            Text(label)
                .appTypography(.scoreboardLabel)
                .foregroundColor(Color.HUD.textValue)

            Text(value)
                .appTypography(.scoreboardValue)
                .foregroundColor(Color.Theme.uiAccentLime)
                .contentTransition(.numericText())
        }
    }
}

// MARK: - Preview

#Preview {
    Color.Background.atmosphere
        .overlay {
            GameScoreItemView(
                label: "СЧЁТ",
                value: "001240",
                alignment: .leading
            )
        }
        .ignoresSafeArea()
}
