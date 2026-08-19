import Foundation

struct UserDefaultsGameSettingsStore: GameSettingsStore {
	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
	}

	func load() -> GameSettings {
		GameSettings(
			highScore: userDefaults.integer(forKey: Key.highScore),
			soundEnabled: userDefaults.object(forKey: Key.soundEnabled) as? Bool ?? true,
			hapticsEnabled: userDefaults.object(forKey: Key.hapticsEnabled) as? Bool ?? true,
			backgroundMusicTrack: BackgroundMusicTrack(
				rawValue: userDefaults.string(forKey: Key.backgroundMusicTrack) ?? ""
			) ?? .puzzleGame,
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

	func saveBackgroundMusicTrack(_ track: BackgroundMusicTrack) {
		userDefaults.set(track.rawValue, forKey: Key.backgroundMusicTrack)
	}

	func saveHapticsEnabled(_ enabled: Bool) {
		userDefaults.set(enabled, forKey: Key.hapticsEnabled)
	}

	func saveSoundEnabled(_ enabled: Bool) {
		userDefaults.set(enabled, forKey: Key.soundEnabled)
	}

	func saveHighScore(_ score: Int) {
		userDefaults.set(score, forKey: Key.highScore)
	}
}

private extension UserDefaultsGameSettingsStore {
	enum Key {
		static let highScore = "stackAttackHighScore"
		static let soundEnabled = "stackAttackSoundEnabled"
		static let hapticsEnabled = "stackAttackHapticsEnabled"
		static let backgroundMusicTrack = "stackAttackBackgroundMusicTrack"
		static let playerAppearance = "stackAttackPlayerAppearance"
		static let manipulatorAppearance = "stackAttackManipulatorAppearance"
		static let backgroundAppearance = "stackAttackBackgroundAppearance"
	}
}
