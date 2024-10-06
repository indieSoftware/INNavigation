import Foundation
import SwiftUI

/// The type how to show a vertical navigation.
public enum PresentationType: Sendable, Equatable {
	/// The screen will be shown in a sheet which covers only partially the screen.
	case sheet(detent: Set<PresentationDetent>)
	/// The screen will be shown modally covering the whole screen.
	case fullScreen
}
