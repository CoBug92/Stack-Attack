import SpriteKit
import SwiftUI
import UIKit

@MainActor
final class GameController: ObservableObject {
	enum OverlayScreen {
		case summary
		case settings
		case backgroundMusic
		case playerAppearance
		case manipulatorAppearance
		case backgroundAppearance
	}

	// MARK: - Observable properties

	@Published private(set) var phase: GamePhase = .ready
	@Published private(set) var score = 0
	@Published private(set) var highScore: Int
	@Published private(set) var level = 1
	@Published private(set) var clearedLines = 0
	@Published var soundEnabled = true
	@Published var hapticsEnabled = true
	@Published private(set) var overlayScreen: OverlayScreen = .summary
	@Published private(set) var selectedBackgroundMusicTrack: BackgroundMusicTrack
	@Published private(set) var selectedPlayerAppearance: PlayerAppearance
	@Published private(set) var selectedManipulatorAppearance: ManipulatorAppearance
	@Published private(set) var selectedBackgroundAppearance: BackgroundAppearance

	// MARK: - Properties

	private let settingsStore: any GameSettingsStore
	private let musicPlayer: any GameMusicPlaying
	private let allowsGameOver: Bool
	private var isSceneActive = false

	lazy var scene: GameScene = {
		let scene = GameScene(
			size: CGSize(width: 480, height: 640),
			controller: self,
			allowsGameOver: allowsGameOver
		)
		scene.scaleMode = .aspectFit
		return scene
	}()

	// MARK: - Init

	init(
		settingsStore: any GameSettingsStore,
		musicPlayer: any GameMusicPlaying = BundledBackgroundMusicPlayer()
	) {
		self.settingsStore = settingsStore
		self.musicPlayer = musicPlayer
		#if DEBUG
			allowsGameOver = !ProcessInfo.processInfo.arguments.contains(.screenshotModeArgument)
		#else
			allowsGameOver = true
		#endif

		let settings = settingsStore.load()
		highScore = settings.highScore
		soundEnabled = settings.soundEnabled
		hapticsEnabled = settings.hapticsEnabled
		selectedBackgroundMusicTrack = settings.backgroundMusicTrack
		selectedPlayerAppearance = settings.playerAppearance
		selectedManipulatorAppearance = settings.manipulatorAppearance
		selectedBackgroundAppearance = settings.backgroundAppearance
		musicPlayer.setTrack(settings.backgroundMusicTrack)
	}

	// MARK: - Computed properties

	var overlayKicker: String {
		switch phase {
		case .ready: Localizations.Overlay.Ready.kicker
		case .paused: Localizations.Overlay.Paused.kicker
		case .knockedOut: ""
		case .gameOver: Localizations.Overlay.Gameover.kicker
		case .playing: ""
		}
	}

	var overlayTitle: String {
		switch phase {
		case .ready: Localizations.Overlay.Ready.title
		case .paused: Localizations.Overlay.Paused.title
		case .knockedOut: ""
		case .gameOver: Localizations.Overlay.Gameover.title
		case .playing: ""
		}
	}

	var overlayText: String {
		switch phase {
		case .ready: Localizations.Overlay.Ready.text
		case .paused: Localizations.Overlay.Paused.text
		case .knockedOut: ""
		case .gameOver: Localizations.Overlay.Gameover.text(score)
		case .playing: ""
		}
	}

	var primaryActionTitle: String {
		switch phase {
		case .ready: Localizations.Overlay.Ready.action
		case .paused: Localizations.Overlay.Paused.action
		case .knockedOut: ""
		case .gameOver: Localizations.Overlay.Gameover.action
		case .playing: ""
		}
	}

	var showsOverlay: Bool {
		phase == .ready || phase == .paused || phase == .gameOver
	}

	var showsOverlaySettings: Bool {
		overlayScreen != .summary && (phase == .ready || phase == .paused)
	}

	var canOpenOverlaySettings: Bool {
		phase == .ready || phase == .paused
	}

	// MARK: - Public methods

	func performPrimaryAction() {
		switch phase {
		case .ready, .gameOver:
			score = 0
			level = 1
			clearedLines = 0
			overlayScreen = .summary
			phase = .playing
			scene.startNewGame()
			impact(.medium)
		case .paused:
			scene.resetTiming()
			overlayScreen = .summary
			phase = .playing
			impact(.light)
		case .playing, .knockedOut:
			break
		}
	}

	func togglePause() {
		switch phase {
		case .playing:
			scene.clearInput()
			overlayScreen = .summary
			phase = .paused
		case .paused:
			scene.resetTiming()
			overlayScreen = .summary
			phase = .playing
		case .ready, .knockedOut, .gameOver:
			break
		}
	}

	func pauseIfNeeded() {
		if phase == .playing {
			scene.clearInput()
			overlayScreen = .summary
			phase = .paused
		}
	}

	func showOverlaySettings() {
		guard canOpenOverlaySettings else { return }
		overlayScreen = .settings
	}

	func showPlayerAppearanceSettings() {
		guard canOpenOverlaySettings else { return }
		overlayScreen = .playerAppearance
	}

	func showBackgroundMusicSettings() {
		guard canOpenOverlaySettings else { return }
		overlayScreen = .backgroundMusic
	}

	func showManipulatorAppearanceSettings() {
		guard canOpenOverlaySettings else { return }
		overlayScreen = .manipulatorAppearance
	}

	func showBackgroundAppearanceSettings() {
		guard canOpenOverlaySettings else { return }
		overlayScreen = .backgroundAppearance
	}

	func hideOverlaySettings() {
		switch overlayScreen {
		case .summary:
			break
		case .settings:
			overlayScreen = .summary
		case .backgroundMusic, .playerAppearance, .manipulatorAppearance, .backgroundAppearance:
			overlayScreen = .settings
		}
	}

	func toggleHaptics() {
		setHapticsEnabled(!hapticsEnabled)
	}

	func toggleSound() {
		setSoundEnabled(!soundEnabled)
	}

	func setHapticsEnabled(_ enabled: Bool) {
		hapticsEnabled = enabled
		settingsStore.saveHapticsEnabled(enabled)
	}

	func setSoundEnabled(_ enabled: Bool) {
		soundEnabled = enabled
		settingsStore.saveSoundEnabled(enabled)
		syncMusicPlayback()
	}

	func setSceneActive(_ isActive: Bool) {
		isSceneActive = isActive
		syncMusicPlayback()
	}

	func setDirection(_ direction: Int, isPressed: Bool) {
		guard phase == .playing else {
			scene.clearInput()
			return
		}
		scene.setDirection(direction, isPressed: isPressed)
	}

	func pressJump() {
		guard phase == .playing else { return }
		scene.pressJump()
		impact(.light)
	}

	func beginKnockout() {
		guard phase == .playing else { return }
		phase = .knockedOut
		scene.clearInput()
		guard hapticsEnabled else { return }
		UINotificationFeedbackGenerator().notificationOccurred(.error)
	}

	func finishKnockout() {
		guard phase == .knockedOut else { return }
		finishGame()
	}

	func registerBox() {
		score += 10 * level
		impact(.soft)
	}

	func registerClearedLines(_ count: Int) {
		score += count * count * 250 * level
		clearedLines += count
		level = min(20, 1 + clearedLines / 4)
		impact(.rigid)
	}

	func endGame() {
		guard phase == .playing else { return }
		finishGame()
	}

	func selectPlayerAppearance(_ appearance: PlayerAppearance) {
		selectedPlayerAppearance = appearance
		settingsStore.savePlayerAppearance(appearance)
		applySelectedAppearances()
	}

	func selectBackgroundMusicTrack(_ track: BackgroundMusicTrack) {
		selectedBackgroundMusicTrack = track
		settingsStore.saveBackgroundMusicTrack(track)
		musicPlayer.setTrack(track)
		syncMusicPlayback()
	}

	func selectManipulatorAppearance(_ appearance: ManipulatorAppearance) {
		selectedManipulatorAppearance = appearance
		settingsStore.saveManipulatorAppearance(appearance)
		applySelectedAppearances()
	}

	func selectBackgroundAppearance(_ appearance: BackgroundAppearance) {
		selectedBackgroundAppearance = appearance
		settingsStore.saveBackgroundAppearance(appearance)
		applySelectedAppearances()
	}

	// MARK: - Private methods

	private func finishGame() {
		if score > highScore {
			highScore = score
			settingsStore.saveHighScore(score)
		}
		overlayScreen = .summary
		phase = .gameOver
	}

	private func applySelectedAppearances() {
		scene.setAppearances(
			player: selectedPlayerAppearance,
			manipulator: selectedManipulatorAppearance,
			background: selectedBackgroundAppearance
		)
	}

	private func syncMusicPlayback() {
		guard soundEnabled, isSceneActive else {
			musicPlayer.stop()
			return
		}

		musicPlayer.play()
	}

	private func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
		guard hapticsEnabled else { return }
		UIImpactFeedbackGenerator(style: style).impactOccurred()
	}
}

// MARK: - Constants

private extension String {
	static let screenshotModeArgument = "--screenshot-mode"
}
