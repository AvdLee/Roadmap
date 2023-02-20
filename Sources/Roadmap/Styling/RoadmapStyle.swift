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
    let upvoteIcon : Image
    
    /// The font used for the feature
    let titleFont : Font
    
    /// The font used for the count label
    let numberFont : Font
    
    /// The font used for the status views
    let statusFont : Font
    
    /// The corner radius for the upvote button
    let radius : CGFloat
    
    public init(icon: Image, titleFont: Font, numberFont: Font, statusFont: Font, cornerRadius: CGFloat) {
        self.upvoteIcon = icon
        self.titleFont = titleFont
        self.numberFont = numberFont
        self.statusFont = statusFont
        self.radius = cornerRadius
    }
}
