//
//  Logger.swift
//  bleeplist
//
//  Created by Maarten Borsje on 21/09/2023.
//

import Foundation
import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static let subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let roadmap = Logger(subsystem: subsystem, category: "Roadmap")
}
