//
//  ColorExtensions.swift
//  
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import SwiftUI

extension Color {
    
    static public var defaultCellColor : Color {
        #if os(macOS) || os(watchOS)
            return Color.primary.opacity(0.08)
        #else
            return Color(uiColor: .secondarySystemFill)
        #endif
    }
}
