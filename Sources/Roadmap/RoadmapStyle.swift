//
//  RoadmapStyle.swift
//  
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import Foundation
import SwiftUI

public enum RoadmapStyle {
    case standard
    case playful
    case classy
    case technical
    
    var iconName : String {
        switch self {
        case .standard:
            return "arrowtriangle.up.fill"
        case .playful:
            return "arrow.up"
        case .classy, .technical:
            return "chevron.up"
        }
    }
    
    var fontDesign : Font.Design {
        switch self {
        case .playful:
            return .rounded
        case .classy:
            return .serif
        case .technical:
            return .monospaced
        default:
            return .default
        }
    }
    
    var titleFont: Font {
        #if os(macOS)
            if #available(macOS 13.0, *) {
                return Font.system(.headline, design: self.fontDesign, weight: .bold)
            } else {
                return Font.headline
            }
        #else
            return Font.system(.headline, design: self.fontDesign, weight: .bold)
        #endif
    }
    
    var bodyFont: Font {
        #if os(macOS)
            if #available(macOS 13.0, *) {
                return Font.system(.body, design: self.fontDesign, weight: .medium).monospacedDigit()
            } else {
                return Font.body.monospacedDigit()
            }
        #else
            return Font.system(.body, design: self.fontDesign, weight: .medium).monospacedDigit()
        #endif
    }
    
    var captionFont: Font {
        #if os(macOS)
            if #available(macOS 13.0, *) {
                return Font.system(.caption, design: self.fontDesign, weight: .bold)
            } else {
                return Font.caption
            }
        #else
            return Font.system(.caption, design: self.fontDesign, weight: .bold)
        #endif
    }
    
    
    var radius : CGFloat {
        switch self {
        case .classy:
            return 4
        case .technical:
            return 0
        case .playful:
            return 15
        default:
            return 10
        }
    }
}
