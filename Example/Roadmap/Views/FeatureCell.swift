//
//  FeatureCell.swift
//  Roadmap
//
//  Created by Jordi Bruin on 18/02/2023.
//

import SwiftUI

struct FeatureCell: View {
    
    let feature: Feature
    
    @State var voteCount = 0
    
    @AppStorage("votedIds") var votedIds: [String] = []
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(feature.title)
                    .bold()
                
                Text(feature.status.title)
                    .bold()
                    .padding(6)
                    .background(feature.status.color.opacity(0.1))
                    .foregroundColor(feature.status.color)
                    .cornerRadius(5)
                    .font(.caption)
            }
            .padding(.vertical, 4)
            
            Spacer()
            Text(voteCount == 0 ? "" : "\(voteCount)")
                .font(.title)
            
//            if !votedIds.contains(feature.id) {
                Button {
                    if votedIds.contains(feature.id) {
                        print("already voted for this, can't vote again")
                    } else {
                        vote()
                    }
                    
                } label: {
                    Image(systemName: votedIds.contains(feature.id) ? "checkmark.circle.fill" : "arrow.up.circle.fill")
                        .foregroundColor(votedIds.contains(feature.id) ? Color.green.opacity(0.7) : Color.blue.opacity(0.7))
                        .font(.title)
                }
//            }
        }
        .onAppear {
            getCurrentVotes()
        }
    }
    
    func vote() {
        if let url = URL(string: "https://api.countapi.xyz/hit/roadmaptest/feature\(feature.id)") {
            let urlSession = URLSession(configuration: .ephemeral).dataTask(with: url) { (data, response, error) in
                if let error = error {
//                    completion(.failure(error))
                    print("error while voting")
                }
                
                if let data = data {
                    votedIds.append(feature.id)
                    print("Succesfully voted")
                    voteCount += 1
                }
            }
            urlSession.resume()
        }
    }
    
    func getCurrentVotes() {
        loadJson(fromURLString: "https://api.countapi.xyz/get/roadmaptest/feature\(feature.id)") { result in
            switch result {
            case let .success(data):
                do {
                    let count: Count = try JSONDecoder().decode(Count.self, from: data)
                    
                    if let countValue = count.value {
                        voteCount = countValue
                    } else {
                        voteCount = 0
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print("error:", error.localizedDescription)
            }
        }
    }
}


struct FeatureCell_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCell(feature: Feature(id: "1", title: "Title", status: .launched))
    }
}
