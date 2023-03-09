//
//  File.swift
//  
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import SwiftUI

extension View {
    public func animateAccessible() -> some View {
        modifier(ReduceMotionnModifier())
    }

    @ViewBuilder
    func scrollContentHidden() -> some View {
        if #available(iOS 16.0, *), #available(macOS 13.0, *) {
            self.scrollContentBackground(.hidden)
        } else {
            self
        }
    }

    @ViewBuilder
    func macOSListRowSeparatorHidden() -> some View {
        if #available(macOS 13.0, *) {
            self.listRowSeparator(.hidden)
        } else {
            self
        }
    }

    @ViewBuilder
    func conditionalSearchable(if condition: Bool, text: Binding<String>) -> some View {
        if condition {
            self.searchable(text: text)
        } else {
            self
        }
    }
}

private struct ReduceMotionnModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reducedMotion

    func body(content: Content) -> some View {
        content.transaction { if reducedMotion { $0.animation = nil } }
    }
}
