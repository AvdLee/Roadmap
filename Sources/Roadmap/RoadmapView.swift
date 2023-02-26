//
//  RoadmapView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

public struct RoadmapView<Header: View, Footer: View>: View {
    @StateObject var viewModel: RoadmapViewModel
    let header: Header
    let footer: Footer

    public var body: some View {
        
        #if os(macOS)
        if #available(macOS 13.0, *) {
            List {
                Section {
                    ForEach(viewModel.features) { feature in
                        RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                } header: {
                    header
                } footer: {
                    footer
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        } else {
            List {
                Section {
                    ForEach(viewModel.features) { feature in
                        Section {
                            RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                        }
                    }
                } header: {
                    header
                } footer: {
                    footer
                }
            }
        }
        #else
        List {
            Section {
                ForEach(viewModel.features) { feature in
                    RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                        .listRowSeparator(.hidden)
                }
            } header: {
                header
            } footer: {
                footer
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        #endif
    }

}

public extension RoadmapView where Header == EmptyView, Footer == EmptyView {
    init(configuration: RoadmapConfiguration) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: EmptyView())
    }
}

public extension RoadmapView where Header: View, Footer == EmptyView {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: EmptyView())
    }
}

public extension RoadmapView where Header == EmptyView, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder footer: () -> Footer) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: footer())
    }
}

public extension RoadmapView where Header: View, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, @ViewBuilder footer: () -> Footer) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: footer())
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(configuration: .sample())
    }
}
