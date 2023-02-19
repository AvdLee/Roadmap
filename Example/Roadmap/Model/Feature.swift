//
//  Feature.swift
//  Roadmap
//
//  Created by Jordi Bruin on 18/02/2023.
//

import Foundation
import SwiftUI

struct Feature: Codable, Identifiable {
    let id: String
    let title: String
    let status: Status
}

enum Status: String, Codable {
    case launched
    case planned
    case finished
    case inProgress
    case researching
    
    var title: String {
        switch self {
        case .launched:
            return "Launched"
        case .planned:
            return "Planned"
        case .inProgress:
            return "In Progress"
        case .researching:
            return "Researching"
        case .finished:
            return "Finished"
        }
    }
    
    var color: Color {
        switch self {
        case .launched:
            return .blue
        case .planned:
            return .orange
        case .inProgress:
            return .red
        case .finished:
            return .green
        case .researching:
            return .purple
        }
    }
}
