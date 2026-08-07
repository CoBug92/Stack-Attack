import Foundation

struct UserDefaultsGameSettingsStore: GameSettingsStore {
	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
	}

	func load() -> GameSettings {
		GameSettings(
			highScore: userDefaults.integer(forKey: Key.highScore),
			hapticsEnabled: userDefaults.object(forKey: Key.hapticsEnabled) as? Bool ?? true,
			playerAppearance: PlayerAppearance(
				rawValue: userDefaults.string(forKey: Key.playerAppearance) ?? "")
				?? .loader,
			manipulatorAppearance: ManipulatorAppearance(
				rawValue: userDefaults.string(forKey: Key.manipulatorAppearance) ?? "")
				?? .gantry,
			backgroundAppearance: BackgroundAppearance(
				rawValue: userDefaults.string(forKey: Key.backgroundAppearance) ?? "")
				?? .port
		)
	}

	func savePlayerAppearance(_ appearance: PlayerAppearance) {
		userDefaults.set(appearance.rawValue, forKey: Key.playerAppearance)
	}

	func saveManipulatorAppearance(_ appearance: ManipulatorAppearance) {
		userDefaults.set(appearance.rawValue, forKey: Key.manipulatorAppearance)
	}

	func saveBackgroundAppearance(_ appearance: BackgroundAppearance) {
		userDefaults.set(appearance.rawValue, forKey: Key.backgroundAppearance)
	}

	func saveHapticsEnabled(_ enabled: Bool) {
		userDefaults.set(enabled, forKey: Key.hapticsEnabled)
	}

	func saveHighScore(_ score: Int) {
		userDefaults.set(score, forKey: Key.highScore)
	}
}

private extension UserDefaultsGameSettingsStore {
	enum Key {
		static let highScore = "stackAttackHighScore"
		static let hapticsEnabled = "stackAttackHapticsEnabled"
		static let playerAppearance = "stackAttackPlayerAppearance"
		static let manipulatorAppearance = "stackAttackManipulatorAppearance"
		static let backgroundAppearance = "stackAttackBackgroundAppearance"
	}
}
