import INNavigation
import SwiftUI

struct INNavigationExampleView: View {
	var body: some View {
		Text(INNavigationVersion.version.description)
	}
}

struct INNavigationExampleView_Previews: PreviewProvider {
	static var previews: some View {
		INNavigationExampleView()
	}
}
