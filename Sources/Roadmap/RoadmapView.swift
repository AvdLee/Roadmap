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
    @State private var selectedFilter: String
    @Binding var selectedFeature: RoadmapFeature?
    
    private var filterHorizontalPadding: CGFloat {
        #if os(macOS)
        return 12
        #else
        return 22
        #endif
    }
    
    private var filterTopPadding: CGFloat {
        #if os(macOS)
        return 12
        #else
        return 0
        #endif
    }
    
    public var body: some View {
            featuresList
                .scrollContentHidden()
                .listStyle(.plain)
                .conditionalSearchable(if: viewModel.allowSearching, text: $viewModel.searchText)
    }
    
    var featuresList: some View {
        VStack {
            if viewModel.allowsFilterByStatus {
                HStack(spacing: 8) {
                    Text("Filter:")
                    Picker("", selection: $selectedFilter) {
                        ForEach(viewModel.statuses, id: \.self) {
                            Text($0.localizedCapitalized)
                        }
                    }
                    .fixedSize()
                    .tint(.primary)
                    .pickerStyle(.menu)
                    .onChange(of: selectedFilter, perform: { newValue in
                        viewModel.filterFeatures(by: newValue)
                    })
                    Spacer()
                }
                .padding(.horizontal, filterHorizontalPadding)
                .padding(.top, filterTopPadding)
            }
            
            List {
                header
                ForEach(viewModel.filteredFeatures) { feature in
                    RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                        .macOSListRowSeparatorHidden()
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            selectedFeature = feature
                        }
                }
                footer
            }
        }
    }
}

public extension RoadmapView where Header == EmptyView, Footer == EmptyView {
    init(configuration: RoadmapConfiguration, selectedFeature: Binding<RoadmapFeature?> = .constant(nil)) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: EmptyView(), selectedFilter: "", selectedFeature: selectedFeature)
    }
}

public extension RoadmapView where Header: View, Footer == EmptyView {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, selectedFeature: Binding<RoadmapFeature?> = .constant(nil)) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: EmptyView(), selectedFilter: "", selectedFeature: selectedFeature)
    }
}

public extension RoadmapView where Header == EmptyView, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder footer: () -> Footer, selectedFeature: Binding<RoadmapFeature?> = .constant(nil)) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: footer(), selectedFilter: "", selectedFeature: selectedFeature)
    }
}

public extension RoadmapView where Header: View, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, @ViewBuilder footer: () -> Footer, selectedFeature: Binding<RoadmapFeature?> = .constant(nil)) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: footer(), selectedFilter: "", selectedFeature: selectedFeature)
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(configuration: .sampleURL())
    }
}
