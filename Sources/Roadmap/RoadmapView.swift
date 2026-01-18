//
//  RoadmapView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

@available(macOS 14.0, iOS 17.0, visionOS 1.0, *)
public struct RoadmapView<Header: View, Footer: View>: View {
    @State var viewModel: RoadmapViewModel
    let header: Header
    let footer: Footer
    @State private var selectedFilter: String
    
    private var filterHorizontalPadding: CGFloat {
        #if os(macOS)
        return 12
        #elseif os(visionOS)
        return 42
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
                    .onChange(of: selectedFilter) { _, newValue in
                        viewModel.filterFeatures(by: newValue)
                    }
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
                    #if os(iOS)
                        .listRowInsets(.init(top: 0, leading: 16, bottom: 16, trailing: 16))
                    #endif
                }
                footer
            }
        }
    }
}

@available(macOS 14.0, iOS 17.0, visionOS 1.0, *)
public extension RoadmapView where Header == EmptyView, Footer == EmptyView {
    init(configuration: RoadmapConfiguration) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: EmptyView(), selectedFilter: RoadmapViewModel.allStatusFilter)
    }
}

@available(macOS 14.0, iOS 17.0, visionOS 1.0, *)
public extension RoadmapView where Header: View, Footer == EmptyView {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: EmptyView(), selectedFilter: RoadmapViewModel.allStatusFilter)
    }
}

@available(macOS 14.0, iOS 17.0, visionOS 1.0, *)
public extension RoadmapView where Header == EmptyView, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder footer: () -> Footer) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: footer(), selectedFilter: RoadmapViewModel.allStatusFilter)
    }
}

@available(macOS 14.0, iOS 17.0, visionOS 1.0, *)
public extension RoadmapView where Header: View, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, @ViewBuilder footer: () -> Footer) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: footer(), selectedFilter: RoadmapViewModel.allStatusFilter)
    }
}

@available(macOS 14.0, iOS 17.0, visionOS 1.0, *)
#Preview {
    RoadmapView(configuration: .sampleURL())
}
