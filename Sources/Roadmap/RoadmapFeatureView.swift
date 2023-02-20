//
//  RoadmapFeatureView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

struct RoadmapFeatureView: View {

    @StateObject var viewModel: RoadmapFeatureViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.feature.title)
                    .font(viewModel.configuration.style.titleFont)

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
        .background(viewModel.configuration.style.cellColor)
        .clipShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
        .task {
            await viewModel.getCurrentVotes()
        }
        
    }
}

struct RoadmapFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapFeatureView(viewModel: .init(feature: .sample(), configuration: .sample()))
    }
}
