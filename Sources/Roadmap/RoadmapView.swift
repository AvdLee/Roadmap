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
                if viewModel.features.isEmpty {
                    macLoadingItems
                } else {
                    ForEach(viewModel.features) { feature in
                        RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        } else {
            List {
                if viewModel.features.isEmpty {
                    macLoadingItems
                } else {
                    ForEach(viewModel.features) { feature in
                        Section {
                            RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                        }
                    }
                }
            }
        }
        #else
        List {
            if viewModel.features.isEmpty {
                iOSLoadingItems
            } else {
                ForEach(viewModel.features) { feature in
                    RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                        .listRowSeparator(.hidden)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        #endif
    }
    
    #if os(macOS)
    var macLoadingItems: some View {
        ForEach(1...6, id: \.self) { index in
            if #available(macOS 13.0, *) {
                RoadmapFeatureView(viewModel: RoadmapFeatureViewModel(feature: .sample(), configuration: .sample()))
                    .redacted(reason: .placeholder)
                    .listRowSeparator(.hidden)
            } else {
                RoadmapFeatureView(viewModel: RoadmapFeatureViewModel(feature: .sample(), configuration: .sample()))
                    .redacted(reason: .placeholder)
            }
        }
    }
    #else
    var iOSLoadingItems: some View {
        ForEach(1...6, id: \.self) { index in
            RoadmapFeatureView(viewModel: RoadmapFeatureViewModel(feature: .sample(), configuration: .sample()))
                .listRowSeparator(.hidden)
                .redacted(reason: .placeholder)
        }
    }
    #endif

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
