//
//  RoadmapFeatureView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

struct RoadmapFeatureView: View {
    @Environment(\.dynamicTypeSize) var typeSize
    @StateObject var viewModel: RoadmapFeatureViewModel

    var body: some View {
        ZStack{
            if typeSize.isAccessibilitySize {
                verticalCell
            } else {
                horizontalCell
            }
        }
        .background(viewModel.configuration.style.cellColor)
        .clipShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
        .task {
            await viewModel.getCurrentVotes()
        }
        
    }
    
    var horizontalCell : some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.feature.title)
                    .font(viewModel.configuration.style.titleFont)
                
                if let description = viewModel.feature.description {
                    Text(description)
                        .font(viewModel.configuration.style.numberFont)
                        .foregroundColor(Color.secondary)
                }

                if let status = viewModel.feature.status {
                        Text(status)
                            .padding(6)
                            .background(Color.primary.opacity(0.05))
                            .foregroundColor(Color.primary.opacity(0.75))
                            .cornerRadius(5)
                            .font(viewModel.configuration.style.statusFont)
                }
            }
            .padding(.top, 4)

            Spacer()
            
            RoadmapVoteButton(viewModel: viewModel)
        }
        .padding()
    }
    
    var verticalCell : some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                RoadmapVoteButton(viewModel: viewModel)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.feature.title)
                    .font(viewModel.configuration.style.titleFont)
                
                if let description = viewModel.feature.description {
                    Text(description)
                        .font(viewModel.configuration.style.numberFont)
                        .foregroundColor(Color.secondary)
                }

                if let status = viewModel.feature.status {
                        Text(status)
                            .padding(6)
                            .background(Color.primary.opacity(0.05))
                            .foregroundColor(Color.primary.opacity(0.75))
                            .cornerRadius(5)
                            .font(viewModel.configuration.style.statusFont)
                }
            }
        }
        .padding()
    }
}

struct RoadmapFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapFeatureView(viewModel: .init(feature: .sample(),
                                            configuration: .sample(),
                                            alreadyVoted: {}))
    }
}
