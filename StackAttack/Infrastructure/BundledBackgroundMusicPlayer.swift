import AVFoundation
import Foundation

protocol GameMusicPlaying: AnyObject {
	func play()
	func stop()
	func setTrack(_ track: BackgroundMusicTrack)
}

final class BundledBackgroundMusicPlayer: GameMusicPlaying {
	// MARK: - Properties

	private var audioPlayer: AVAudioPlayer?
	private var selectedTrack: BackgroundMusicTrack = .puzzleGame
	private var isPlaying = false

	// MARK: - Public methods

	func play() {
		guard !isPlaying else { return }

		do {
			try configureAudioSession()
			if audioPlayer == nil {
				try configurePlayer(for: selectedTrack)
			}
			audioPlayer?.play()
			isPlaying = true
		} catch {
			audioPlayer?.stop()
			isPlaying = false
		}
	}

	func stop() {
		guard isPlaying else { return }

		audioPlayer?.stop()
		audioPlayer?.currentTime = 0
		isPlaying = false

		do {
			try AVAudioSession.sharedInstance().setActive(
				false,
				options: [.notifyOthersOnDeactivation]
			)
		} catch {
			return
		}
	}

	func setTrack(_ track: BackgroundMusicTrack) {
		let shouldResume = isPlaying
		selectedTrack = track

		do {
			try configurePlayer(for: track)
			if shouldResume {
				try configureAudioSession()
				audioPlayer?.play()
			}
		} catch {
			audioPlayer = nil
			isPlaying = false
		}
	}

	// MARK: - Private methods

	private func configureAudioSession() throws {
		let session = AVAudioSession.sharedInstance()
		try session.setCategory(.ambient, options: [.mixWithOthers])
		try session.setActive(true)
	}

	private func configurePlayer(for track: BackgroundMusicTrack) throws {
		let resourceURL = try resolvedURL(for: track)
		let player = try AVAudioPlayer(contentsOf: resourceURL)
		player.numberOfLoops = -1
		player.volume = .musicTrackVolume
		player.prepareToPlay()
		audioPlayer = player
	}

	private func resolvedURL(for track: BackgroundMusicTrack) throws -> URL {
		if let directURL = Bundle.main.url(
			forResource: track.resourceName,
			withExtension: .musicTrackFileExtension
		) {
			return directURL
		}

		if let nestedURL = Bundle.main.url(
			forResource: track.resourceName,
			withExtension: .musicTrackFileExtension,
			subdirectory: .musicTrackSubdirectory
		) {
			return nestedURL
		}

		throw NSError(
			domain: .musicErrorDomain,
			code: .musicFileMissingCode,
			userInfo: [
				NSLocalizedDescriptionKey: "Missing bundled track: \(track.resourceName)."
			]
		)
	}
}

final class NoOpGameMusicPlayer: GameMusicPlaying {
	func play() {}

	func stop() {}

	func setTrack(_ track: BackgroundMusicTrack) {}
}

private extension Float {
	static let musicTrackVolume: Float = 0.62
}

private extension String {
	static let musicTrackFileExtension = "mp3"
	static let musicTrackSubdirectory = "Resources/Audio"
	static let musicErrorDomain = "StackAttack.BundledBackgroundMusicPlayer"
}

private extension Int {
	static let musicFileMissingCode = 1
}
