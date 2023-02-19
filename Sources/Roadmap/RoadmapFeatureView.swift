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
                    .bold()

                Text(viewModel.feature.status)
                    .bold()
                    .padding(6)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(Color.red)
                    .cornerRadius(5)
                    .font(.caption)
            }
            .padding(.vertical, 4)

            Spacer()
            Text("\(viewModel.voteCount)")
                .font(.title)

            if !viewModel.feature.hasVoted {
                Button {
                    viewModel.vote()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.title)
                }
            }
        }
        .onAppear {
            viewModel.getCurrentVotes()
        }
    }
}

struct RoadmapFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapFeatureView(viewModel: .init(feature: .sample(), configuration: .sample()))
    }
}
