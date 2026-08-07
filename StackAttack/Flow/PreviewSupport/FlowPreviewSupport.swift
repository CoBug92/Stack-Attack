import SwiftUI

@MainActor
enum FlowPreviewSupport {
	enum Phase {
		case ready
		case playing
		case paused
		case gameOver
	}

	static let lime = Color.Theme.uiAccentLime
	static let orange = Color.Theme.uiAccentOrange
	static let border = Color.Overlay.border
	static let surface = Color.Overlay.surface
	static let canvas = Color.Background.canvas
	static let divider = Color.HUD.divider

	static func makeGame(
		phase: Phase = .ready,
		overlayScreen: GameController.OverlayScreen = .summary
	) -> GameController {
		let game = GameController(settingsStore: PreviewGameSettingsStore())

		switch phase {
		case .ready:
			break
		case .playing:
			game.performPrimaryAction()
		case .paused:
			game.performPrimaryAction()
			game.togglePause()
		case .gameOver:
			game.performPrimaryAction()
			game.endGame()
		}

		switch overlayScreen {
		case .summary:
			game.hideOverlaySettings()
		case .settings:
			game.showOverlaySettings()
		case .playerAppearance:
			game.showPlayerAppearanceSettings()
		case .manipulatorAppearance:
			game.showManipulatorAppearanceSettings()
		case .backgroundAppearance:
			game.showBackgroundAppearanceSettings()
		}

		return game
	}
}

private struct PreviewGameSettingsStore: GameSettingsStore {
	func load() -> GameSettings {
		GameSettings(
			highScore: 500,
			hapticsEnabled: false,
			playerAppearance: .cyberLoader,
			manipulatorAppearance: .drone,
			backgroundAppearance: .port
		)
	}

	func savePlayerAppearance(_ appearance: PlayerAppearance) {}

	func saveManipulatorAppearance(_ appearance: ManipulatorAppearance) {}

	func saveBackgroundAppearance(_ appearance: BackgroundAppearance) {}

	func saveHapticsEnabled(_ enabled: Bool) {}

	func saveHighScore(_ score: Int) {}
}
