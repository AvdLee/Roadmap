//
//  RoadmapTemplates.swift
//  
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import SwiftUI
public enum RoadmapTemplate : CaseIterable {
    case standard
    case playful
    case classy
    case technical
    
    public var style : RoadmapStyle {
        switch self {
        case .standard:
            return RoadmapStyle(icon: Image(systemName: "arrowtriangle.up.fill"),
                                titleFont: self.titleFont,
                                numberFont: self.numberFont,
                                statusFont: self.captionFont,
                                cornerRadius: 10)
        case .playful:
            return RoadmapStyle(icon: Image(systemName: "arrow.up"),
                                titleFont: self.titleFont,
                                numberFont: self.numberFont,
                                statusFont: self.captionFont,
                                cornerRadius: 15)
        case .classy:
            return RoadmapStyle(icon: Image(systemName: "chevron.up"),
                                titleFont: self.titleFont,
                                numberFont: self.numberFont,
                                statusFont: self.captionFont,
                                cornerRadius: 5)
        case .technical:
            return RoadmapStyle(icon: Image(systemName: "chevron.up"),
                                titleFont: self.titleFont,
                                numberFont: self.numberFont,
                                statusFont: self.captionFont,
                                cornerRadius: 2)
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
    
    var numberFont: Font {
        #if os(macOS)
            if #available(macOS 13.0, *) {
                return Font.system(.body, design: self.fontDesign, weight: .semibold).monospacedDigit()
            } else {
                return Font.body.monospacedDigit()
            }
        #else
            return Font.system(.body, design: self.fontDesign, weight: .semibold).monospacedDigit()
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
}
