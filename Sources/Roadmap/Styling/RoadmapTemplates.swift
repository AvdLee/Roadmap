//
//  RoadmapTemplates.swift
//
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import SwiftUI
public enum RoadmapTemplate: CaseIterable {
    case standard
    case playful
    case classy
    case technical
    
    public var style: RoadmapStyle {
        switch self {
        case .standard:
            return RoadmapStyle(upvoteIcon: Image(systemName: "arrowtriangle.up.fill"),
                                unvoteIcon: Image(systemName: "arrowtriangle.down.fill"),
                                titleFont: self.titleFont,
                                numberFont: self.numberFont,
                                statusFont: self.captionFont,
                                cornerRadius: 10)
        case .playful:
            return RoadmapStyle(upvoteIcon: Image(systemName: "arrow.up"),
                                unvoteIcon: Image(systemName: "arrow.down"),
                                titleFont: self.titleFont,
                                numberFont: self.numberFont,
                                statusFont: self.captionFont,
                                cornerRadius: 15)
        case .classy:
            return RoadmapStyle(upvoteIcon: Image(systemName: "chevron.up"),
                                unvoteIcon: Image(systemName: "chevron.down"),
                                titleFont: self.titleFont,
                                numberFont: self.numberFont,
                                statusFont: self.captionFont,
                                cornerRadius: 5)
        case .technical:
            return RoadmapStyle(upvoteIcon: Image(systemName: "chevron.up"),
                                unvoteIcon: Image(systemName: "chevron.down"),
                                titleFont: self.titleFont,
                                numberFont: self.numberFont,
                                statusFont: self.captionFont,
                                cornerRadius: 2)
        }
    }
    
    var fontDesign: Font.Design {
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
            if #available(iOS 16.0, *) {
                return Font.system(.headline, design: self.fontDesign, weight: .bold)
            } else {
                return Font.system(.headline, design: self.fontDesign).weight(.bold)
            }
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
            if #available(iOS 16.0, *) {
                return Font.system(.body, design: self.fontDesign, weight: .semibold).monospacedDigit()
            } else {
                return Font.system(.body, design: self.fontDesign).weight(.semibold).monospacedDigit()
            }
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
            if #available(iOS 16.0, *) {
                return Font.system(.caption, design: self.fontDesign, weight: .bold)
            } else {
                return Font.system(.caption, design: self.fontDesign).weight(.bold)
            }
        #endif
    }
}
