//
//  ContentView.swift
//  RoadmapExample
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Roadmap
import SwiftUI

struct ContentView: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!,
        namespace: "roadmaptest"
    )

    var body: some View {
        RoadmapView(configuration: configuration)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
