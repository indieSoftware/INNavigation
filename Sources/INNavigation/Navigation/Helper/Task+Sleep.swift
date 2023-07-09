import Foundation
import INCommons

extension Task where Success == Never, Failure == Never {
	/// Sleeps for the appropriate time for the corresponding step.
	/// This ensures that a thread is waiting for a transition animation has been ended
	/// before the next one can be applied.
	/// If the time is not respected correctly then this can lead to screen discrepancies.
	static func sleep(forRoutingDirection routingDirection: RoutingDirection) async {
		let duration: Double
		switch routingDirection {
		case .horizontal:
			duration = .routerTransitionDurationHorizontal
		case .vertical:
			duration = .routerTransitionDurationVertical
		case .none:
			return
		case let .custom(customDuration):
			precondition(customDuration >= 0)
			duration = customDuration
		}
		try? await Task.sleep(seconds: duration)
	}
}
