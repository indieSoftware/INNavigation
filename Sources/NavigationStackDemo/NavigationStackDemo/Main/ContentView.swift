//
//  ContentView.swift
//  NavigationStackExampleDemo
//
//  Created by Alex Nagy on 08.03.2022.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		TabView {
			HomeContainer()
				.tabItem {
					Image(systemName: "house")
					Text("Home")
				}

			FeedContainer()
				.tabItem {
					Image(systemName: "tray")
					Text("Feed")
				}

			PostsContainer()
				.tabItem {
					Image(systemName: "folder")
					Text("Posts")
				}

			SettingsContainer()
				.tabItem {
					Image(systemName: "gear")
					Text("Settings")
				}

			NavigationView {
				SwiftUIFirstView()
			}
			.tabItem {
				Image(systemName: "swift")
				Text("SwiftUI")
			}
		}
		#if os(macOS)
		.padding(.top, 9)
		#endif
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
