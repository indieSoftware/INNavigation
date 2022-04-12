//
//  SwiftUIFourthView.swift
//  NavigationStackDemo
//
//  Created by Alex Nagy on 24.03.2022.
//

import SwiftUI

struct SwiftUIFourthView: View {
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		HStack {
			Spacer()
			VStack {
				Spacer()
				Text("SwiftUI Fourth")
					.bold()
				#if !os(macOS)
					Button {
						dismiss()
					} label: {
						Text("Dismiss")
					}
				#endif
				Spacer()
			}
			Spacer()
		}
	}
}

struct SwiftUIFourthView_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIFourthView()
	}
}
