import Foundation

/// The type how to show a vertical navigation.
public enum PresentationType: Sendable {
	/// The screen will be shown in a sheet which covers only partially the screen.
	case sheet
	/// The screen will be shown modally covering the whole screen.
	case fullScreen
}
