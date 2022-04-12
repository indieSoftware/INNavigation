//
//  SwiftUISecondView.swift
//  NavigationStackExampleDemo
//
//  Created by Alex Nagy on 08.03.2022.
//

import SwiftUI

struct SwiftUISecondView: View {
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		HStack {
			Spacer()
			VStack {
				Spacer()
				Text("SwiftUI Second")
					.bold()
				Button {
					dismiss()
				} label: {
					Text("Dismiss")
				}
				Spacer()
			}
			Spacer()
		}
		#if !os(watchOS)
		.background(Material.thinMaterial)
		#endif
		#if os(macOS)
		.frame(width: 300, height: 300)
		#endif
	}
}

struct SwiftUISecondView_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUISecondView()
	}
}
