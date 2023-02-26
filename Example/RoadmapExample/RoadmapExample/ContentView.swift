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
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/k2f11wikc6")!,
        namespace: "roadmaptest"
    )

    var body: some View {
        #if os(macOS)
            roadmapView
        #else
        NavigationView {
            roadmapView
        }
        #endif
    }

    private var roadmapView: some View {
        RoadmapView(
            configuration: configuration,
            header: {
                GroupBox {
                    Text("These are features that are coming to RocketSim soon. You can vote on the ones you'd love to see me add first. [Let me know](https://github.com/AvdLee/RocketSimApp/issues/new?assignees=AvdLee&labels=enhancement&template=feature_request.md) if you have a suggestion for a feature that needs to be added to this list.")
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(10)
                }.padding(.horizontal, 20)
                    .padding(.vertical, 20)
            }, footer: {
                HStack {
                    Spacer()
                    Text("Feature Voting with [Roadmap](https://github.com/AvdLee/Roadmap)")
                    Spacer()
                }.padding(.vertical, 10)
            })
            .navigationTitle("Roadmap Example")
            .toolbar {
                ToolbarItem {
                    Link(destination: URL(string: "https://github.com/AvdLee/Roadmap")!) {
                        Image(systemName: "questionmark.app.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
