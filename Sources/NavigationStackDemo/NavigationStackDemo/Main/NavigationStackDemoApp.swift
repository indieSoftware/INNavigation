//
//  NavigationStackDemoApp.swift
//  NavigationStackDemotvOS
//
//  Created by Alex Nagy on 24.03.2022.
//

import SwiftUI

@main
struct NavigationStackDemoApp: App {
	@StateObject private var homeContainerNavigation = HomeContainer.Navigation()
	@StateObject private var feedContainerNavigation = FeedContainer.Navigation()
	@StateObject private var postsContainerNavigation = PostsContainer.Navigation()
	@StateObject private var settingsContainerNavigation = SettingsContainer.Navigation()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(homeContainerNavigation)
				.environmentObject(feedContainerNavigation)
				.environmentObject(postsContainerNavigation)
				.environmentObject(settingsContainerNavigation)
				.onOpenURL { _ in
					//                    deepLink()
				}
				.onAppear {
					//                    deepLink()
				}
		}

		#if os(watchOS)
			WKNotificationScene(controller: NotificationController.self, category: "myCategory")
		#endif
	}

	func deepLink() {
		$homeContainerNavigation.flow.present(.homeSecond, options: .init(style: .sheet)) {
			$homeContainerNavigation.flow.present(.homeThird(title: "Deep Link"))
		}
	}
}
