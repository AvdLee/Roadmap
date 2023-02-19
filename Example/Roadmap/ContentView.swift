//
//  ContentView.swift
//  Roadmap
//
//  Created by Jordi Bruin on 18/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    let countAPIIdentifier = "com.goodsnooze.vivid"
    
//https://api.countapi.xyz/get/com.goodsnooze.vivid/newInstall
//https://api.countapi.xyz/get/
    
    @State var features: [Feature] = []
    @AppStorage("votedIds") var votedIds: [String] = []
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("These are features that are coming to MacWhisper soon. You can vote on the ones you'd love to see me add first. If you have a suggestion for a feature that's not on this list, let me know.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .listRowBackground(Color.clear)
                
                ForEach(features.shuffled()) { feature in
                    Section {
                        FeatureCell(feature: feature)
                    }
                }
            }
            .refreshable {
                loadFeatures()
            }
            .onAppear {
                loadFeatures()
            }
            .navigationTitle("Roadmap")
            .toolbar {
                ToolbarItem {
                    Link(destination: URL(string: "mailto:jordi@goodsnooze.com")!) {
                        Text("Feature Idea")
                    }
//                    Button {
//                        NSWorkspace.shared.open(URL(string: "mailto:\(sale.purchaseEmail)")!)
//                    } label: {
//                        Text("Feature Suggestion")
//                    }

                }
            }
        }
    }
    
    func loadFeatures() {
        loadJson(fromURLString: "https://simplejsoncms.com/api/vq2juq1xhg") { result in
            switch result {
            case let .success(data):
                print(String(data: data, encoding: .utf8))
                do {
                    let features: [Feature] = try JSONDecoder().decode([Feature].self, from: data)
                    
                    DispatchQueue.main.async(execute: {
                        self.features = features
                    })
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print("error:", error.localizedDescription)
                
                DispatchQueue.main.async(execute: {
//                    self.shouldUpdate = false
                })
            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func loadJson(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
    if let url = URL(string: urlString) {
        let urlSession = URLSession(configuration: .ephemeral).dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        urlSession.resume()
    }
}
