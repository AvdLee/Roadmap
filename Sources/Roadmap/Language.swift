//
//  Language.swift
//  Roadmap
//
//  Created by Abdullah Alhaider on 21/02/2023.
//

import Foundation

public enum Language {
    case LTR, RTL
    
    public static var code: String {
        Locale.current.language.languageCode?.identifier.lowercased() ?? "en"
    }
    
    // In case we need some custom UI for lang direction..
    public static var isRTL: Bool {
        Locale.Language(identifier: code).characterDirection == .rightToLeft
    }
}
