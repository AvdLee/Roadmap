//
//  RoadmapView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

public struct RoadmapView: View {
    @StateObject var viewModel: RoadmapViewModel
    
    public var body: some View {
        
        #if os(macOS)
        if #available(macOS 13.0, *) {
            List {
                ForEach(viewModel.features) { feature in
                    RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                        .listRowSeparator(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        } else {
            List {
                ForEach(viewModel.features) { feature in
                    Section {
                        RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                    }
                }
            }
        }
        #else
        List {
            ForEach(viewModel.features) { feature in
                RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                    .listRowSeparator(.hidden)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .refreshable {
            viewModel.refresh()
        }
        #endif
    }

}

public extension RoadmapView {
    init(configuration: RoadmapConfiguration) {
        self.init(viewModel: .init(configuration: configuration))
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(configuration: .sample())
    }
}
