//
//  RoadmapVoteButton.swift
//
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import SwiftUI

@available(macOS 14.0, iOS 17.0, visionOS 1.0, *)
struct RoadmapVoteButton: View {
    @State var viewModel: RoadmapFeatureViewModel
    @Environment(\.dynamicTypeSize) private var typeSize
    
    @State private var isHovering = false
    @State private var showNumber = false
    @State private var hasVoted = false
    
    var body: some View {
        Button {
            guard viewModel.canVote else { return }
            Task {
                if !viewModel.feature.hasVoted {
                    await viewModel.vote()
                    announceAccessibility("Added vote")
                } else {
                    await viewModel.unvote()
                    announceAccessibility("Removed vote")
                }
                #if os(iOS)
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                #endif
            }
        } label: {
            ZStack {
                if typeSize.isAccessibilitySize {
                    HStack(spacing: isHovering ? 2 : 0) {
                        icon.accessibilityHidden(true)
                        if showNumber { numberText }
                    }
                    .padding(viewModel.configuration.style.radius)
                    .frame(minHeight: 64)
                    .background(backgroundView)
                } else {
                    VStack(spacing: isHovering ? 6 : 4) {
                        icon.accessibilityHidden(true)
                        if showNumber { numberText }
                    }
                    .frame(minWidth: 56)
                    .frame(height: 64)
                    .background(backgroundView)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
            .overlay(overlayBorder)
        }
        .buttonStyle(.plain)
        #if os(visionOS)
        .buttonBorderShape(.roundedRectangle(radius: viewModel.configuration.style.radius))
        .clipShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
        #endif
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Vote"))
        .accessibilityValue(Text(accessibilityValue))
        .accessibilityHint(Text(viewModel.canVote
                                ? (hasVoted
                                   ? "Double-tap to remove your vote for \(viewModel.feature.localizedFeatureTitle)"
                                   : "Double-tap to vote for \(viewModel.feature.localizedFeatureTitle)")
                                : "Voting unavailable"))
        .accessibilityAddTraits(.isButton)
        .accessibilityAddTraits(hasVoted ? .isSelected : [])
        .accessibilityRespondsToUserInteraction(viewModel.canVote)
        .accessibilityShowsLargeContentViewer()
        .accessibilityIdentifier("roadmap_vote_button")
        .disabled(!viewModel.canVote)
        .onChange(of: viewModel.voteCount) { _, newCount in
            if newCount > 0 {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.4)) {
                    showNumber = true
                }
            }
        }
        .onChange(of: viewModel.feature.hasVoted) { _, newVote in
            withAnimation(.spring(response: 0.45, dampingFraction: 0.4)) {
                hasVoted = newVote
            }
        }
        .onHover { newHover in
            if viewModel.canVote && !hasVoted {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isHovering = newHover
                }
            }
        }
        .onAppear {
            showNumber = viewModel.voteCount > 0
            withAnimation(.spring(response: 0.45, dampingFraction: 0.4)) {
                hasVoted = viewModel.feature.hasVoted
            }
        }
        .help(viewModel.canVote
              ? (!viewModel.feature.hasVoted
                 ? Text("Vote for \(viewModel.feature.localizedFeatureTitle)")
                 : Text("Remove vote for \(viewModel.feature.localizedFeatureTitle)"))
              : Text("Voting unavailable"))
        .animateAccessible()
    }
    
    // MARK: - Pieces
    
    private var icon: some View {
        Group {
            if viewModel.canVote {
                if !viewModel.feature.hasVoted {
                    viewModel.configuration.style.upvoteIcon
                } else {
                    viewModel.configuration.style.unvoteIcon
                }
            }
        }
        .foregroundColor(hasVoted ? viewModel.configuration.style.selectedForegroundColor
                                  : viewModel.configuration.style.tintColor)
        .imageScale(.large)
        .font(typeSize.isAccessibilitySize ? .system(size: 17, weight: .medium)
                                           : viewModel.configuration.style.numberFont)
        .frame(maxWidth: typeSize.isAccessibilitySize ? 24 : 20,
               maxHeight: typeSize.isAccessibilitySize ? 24 : 20)
        .minimumScaleFactor(0.75)
    }
    
    private var numberText: some View {
        Text("\(viewModel.voteCount)")
            .lineLimit(1)
            .foregroundColor(hasVoted ? viewModel.configuration.style.selectedForegroundColor
                                      : viewModel.configuration.style.tintColor)
            .font(viewModel.configuration.style.numberFont)
            .minimumScaleFactor(typeSize.isAccessibilitySize ? 0.5 : 0.9)
    }
    
    @ViewBuilder
    private var overlayBorder: some View {
        if isHovering {
            RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous)
                .stroke(viewModel.configuration.style.tintColor, lineWidth: 1)
        }
    }
    
    private var backgroundView: some View {
        viewModel.configuration.style.tintColor
            .opacity(hasVoted ? 1 : 0.1)
            .clipShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
    }
    
    // MARK: - A11y helpers
    
    private var accessibilityValue: String {
        let c = viewModel.voteCount
        if c == 0 { return "0 votes" }
        if c == 1 { return "1 vote" }
        return "\(c) votes"
    }
    
    private func announceAccessibility(_ text: String) {
        #if os(iOS)
        UIAccessibility.post(notification: .announcement, argument: text)
        #endif
    }
}
