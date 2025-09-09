//
//  RoadmapStyle.swift
//
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//
import Foundation
import SwiftUI

public struct RoadmapStyle: Sendable {
    /// The image used for the upvote button
    public var upvoteIcon: Image
    
    /// The image used for the unvote button
    public var unvoteIcon: Image
    
    /// The font used for the feature
    public var titleFont: Font
    
    /// The font used for the count label
    public var numberFont: Font
    
    /// The font used for the status views
    public var statusFont: Font
    
    /// The tint color of the status view
    public var statusTintColor: @Sendable (String) -> Color
    
    /// The corner radius for the upvote button
    public var radius: CGFloat
    
    /// The backgroundColor of each cell
    public var cellColor: Color?

    /// The backgroundMaterial of each cell
    public var cellMaterial: Material?

    /// The color of the text and icon when voted
    public var selectedForegroundColor: Color
    
    /// The main tintColor for the roadmap views.
    public var tintColor: Color
    
    /// Define a `RoadmapStyle` to customise Roadmap to your needs
    /// - Parameters:
    ///   - upvoteIcon: Image view that you want to use for the upvote icon 24x24 of size is best
    ///   - unvoteIcon: Image view that you want to use for the upvote icon 24x24 of size is best
    ///   - titleFont: The font you want
    ///   - numberFont: The font used for the count label
    ///   - statusFont: The font used for the status views
    ///   - statusTintColor: The tint color of the status view
    ///   - cornerRadius: The corner radius for the upvote button
    ///   - cellColor: The backgroundColor of each cell
    ///   - cellMaterial: The backgroundMaterial of each cell
    ///   - selectedColor: The color of the text and icon when voted
    ///   - tint: The main tintColor for the roadmap views.
    public init(upvoteIcon: Image,
                unvoteIcon: Image,
                titleFont: Font,
                numberFont: Font,
                statusFont: Font,
                statusTintColor: @escaping @Sendable (String) -> Color = { _ in Color.primary },
                cornerRadius: CGFloat,
                cellColor: Color? = nil,
                cellMaterial: Material? = nil,
                selectedColor: Color = .white,
                tint: Color = .accentColor)
    {
        self.upvoteIcon = upvoteIcon
        self.unvoteIcon = unvoteIcon
        self.titleFont = titleFont
        self.numberFont = numberFont
        self.statusFont = statusFont
        self.statusTintColor = statusTintColor
        self.radius = cornerRadius
        self.cellColor = cellColor
        self.cellMaterial = cellMaterial
        self.selectedForegroundColor = selectedColor
        self.tintColor = tint
    }

    /// Cell background based on current platform
    ///
    /// If current platform is `visionOS`, `cellMaterial` will be preferred. `cellColor` instead.
    var cellBackground: some ShapeStyle {
        #if os(visionOS)
            if let cellMaterial {
                return AnyShapeStyle(cellMaterial)
            } else if let cellColor {
                return AnyShapeStyle(cellColor)
            } else {
                return AnyShapeStyle(Material.defaultCellMaterial)
            }
        #else
            if let cellColor {
                return AnyShapeStyle(cellColor)
            } else if let cellMaterial {
                return AnyShapeStyle(cellMaterial)
            } else {
                return AnyShapeStyle(Color.defaultCellColor)
            }
        #endif
    }
}
