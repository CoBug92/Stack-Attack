/// Хранилище пользовательских игровых настроек и рекорда.
protocol GameSettingsStore {
	/// Загружает сохранённые настройки игры и рекорд.
	func load() -> GameSettings

	/// Сохраняет выбранный облик грузчика.
	func savePlayerAppearance(_ appearance: PlayerAppearance)

	/// Сохраняет выбранный облик манипулятора.
	func saveManipulatorAppearance(_ appearance: ManipulatorAppearance)

	/// Сохраняет выбранный фон.
	func saveBackgroundAppearance(_ appearance: BackgroundAppearance)

	/// Сохраняет состояние вибрации.
	func saveHapticsEnabled(_ enabled: Bool)

	/// Сохраняет лучший результат игрока.
	func saveHighScore(_ score: Int)
}
