enum BackgroundMusicTrack: String, CaseIterable, Identifiable {
	case puzzleGame
	case minimalTechno

	var id: String { rawValue }

	var title: String {
		switch self {
		case .puzzleGame:
			Localizations.Music.PuzzleGame.title
		case .minimalTechno:
			Localizations.Music.MinimalTechno.title
		}
	}

	var description: String {
		switch self {
		case .puzzleGame:
			Localizations.Music.PuzzleGame.description
		case .minimalTechno:
			Localizations.Music.MinimalTechno.description
		}
	}

	var resourceName: String {
		switch self {
		case .puzzleGame:
			"music-for-puzzle-game"
		case .minimalTechno:
			"minimal-techno-ambient-loop"
		}
	}
}
