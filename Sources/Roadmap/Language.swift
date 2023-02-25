//
//  Language.swift
//  Roadmap
//
//  Created by Abdullah Alhaider on 21/02/2023.
//

import Foundation

enum Language {
    case LTR, RTL
    
    static var code: String {
        Bundle.main.preferredLocalizations.first ?? "en"
    }
}
