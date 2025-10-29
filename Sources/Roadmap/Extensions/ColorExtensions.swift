//
//  ColorExtensions.swift
//  
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import SwiftUI

extension Color {
    
    static public var defaultCellColor : Color {
        #if os(macOS)
            .primary.opacity(0.08)
        #else
            Color(uiColor: .secondarySystemFill)
        #endif
    }
}
