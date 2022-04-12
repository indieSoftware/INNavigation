//
//  FeedSecondView.swift
//  NavigationStackExampleDemo
//
//  Created by Alex Nagy on 08.03.2022.
//

import SwiftUI

struct FeedSecondView: View {
	@Environment(\.dismiss) private var dismiss

	var person: String

	var body: some View {
		VStack {
			Text("Hello, \(person)!")
			#if !os(macOS)
				Button {
					dismiss()
				} label: {
					Text("Dismiss")
				}
			#endif
		}
	}
}
