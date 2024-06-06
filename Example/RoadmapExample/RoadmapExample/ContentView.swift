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
        namespace: "roadmaptest",
        allowVotes: true,
        allowSearching: true,
        allowsFilterByStatus: true
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
                    HStack {
                        Text("You can add a header to introduce your users to your Roadmap.")
                            .padding(10)
                        Spacer()
                    }
                        .frame(maxWidth: .infinity)
                }.padding(.vertical, 20)
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
