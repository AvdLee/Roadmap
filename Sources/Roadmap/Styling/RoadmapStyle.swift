//
//  RoadmapStyle.swift
//  
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import Foundation
import SwiftUI

public struct RoadmapStyle {
    let upvoteIcon : Image
    let titleFont : Font
    let numberFont : Font
    let statusFont : Font
    let radius : CGFloat
    
    public init(icon: Image, titleFont: Font, numberFont: Font, statusFont: Font, cornerRadius: CGFloat) {
        self.upvoteIcon = icon
        self.titleFont = titleFont
        self.numberFont = numberFont
        self.statusFont = statusFont
        self.radius = cornerRadius
    }
}
