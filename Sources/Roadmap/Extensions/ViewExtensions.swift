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
    public func loadingView(_ isLoading: Bool) -> some View {
        if isLoading {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                Spacer()
            }
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

