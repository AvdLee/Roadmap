//
//  RoadmapStyle.swift
//
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//
import Foundation
import SwiftUI

public struct RoadmapStyle {
    /// The image used for the upvote button
    public var upvoteIcon : Image
    
    /// The font used for the feature
    public var titleFont : Font
    
    /// The font used for the count label
    public var numberFont : Font
    
    /// The font used for the status views
    public var statusFont : Font
    
    /// The tint color of the status view
    public var statusTintColor: (String) -> Color
    
    /// The corner radius for the upvote button
    public var radius : CGFloat
    
    /// The backgroundColor of each cell
    public var cellColor : Color
    
    /// The color of the text and icon when voted
    public var selectedForegroundColor : Color
    
    /// The main tintColor for the roadmap views.
    public var tintColor : Color
    
    public init(icon: Image,
                titleFont: Font,
                numberFont: Font,
                statusFont: Font,
                statusTintColor: @escaping (String) -> Color = { _ in Color.primary },
                cornerRadius: CGFloat,
                cellColor: Color = Color.defaultCellColor,
                selectedColor: Color = .white,
                tint: Color = .accentColor) {
        
        self.upvoteIcon = icon
        self.titleFont = titleFont
        self.numberFont = numberFont
        self.statusFont = statusFont
        self.statusTintColor = statusTintColor
        self.radius = cornerRadius
        self.cellColor = cellColor
        self.selectedForegroundColor = selectedColor
        self.tintColor = tint
    }
}
