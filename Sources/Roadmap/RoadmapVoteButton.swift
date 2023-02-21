//
//  RoadmapVoteButton.swift
//  
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import SwiftUI


struct RoadmapVoteButton : View {
    @ObservedObject var viewModel : RoadmapFeatureViewModel
    @Environment(\.dynamicTypeSize) var typeSize
    
    @State private var isHovering = false
    @State private var showNumber = false
    @State private var hasVoted = false
    
    var body: some View {
        Button {
            if !viewModel.feature.hasVoted {
                    viewModel.vote()
                #if os(iOS)
                let haptic = UIImpactFeedbackGenerator(style: .soft)
                haptic.impactOccurred()
                #endif
            }
        } label: {
            ZStack {
                
                
                if typeSize.isAccessibilitySize {
                    HStack(spacing: isHovering ? 2 : 0) {
                        viewModel.configuration.style.upvoteIcon
                            .foregroundColor(hasVoted ? viewModel.configuration.style.selectedForegroundColor : viewModel.configuration.style.tintColor)
                            .imageScale(.large)
                            .font(Font.system(size: 17, weight: .medium))
                            .frame(maxWidth: 24, maxHeight: 24)
                        
                        if showNumber {
                            Text("\(viewModel.voteCount)")
                                .lineLimit(1)
                                .foregroundColor(hasVoted ? viewModel.configuration.style.selectedForegroundColor : viewModel.configuration.style.tintColor)
                                .minimumScaleFactor(0.5)
                                .font(viewModel.configuration.style.numberFont)
                        }
                    }
                    .padding(viewModel.configuration.style.radius)
                    .frame(minHeight: 64)
                    .background(backgroundView)
                } else {
                    VStack(spacing: isHovering ? 2 : 0) {
                        viewModel.configuration.style.upvoteIcon
                            .foregroundColor(hasVoted ? viewModel.configuration.style.selectedForegroundColor : viewModel.configuration.style.tintColor)
                            .imageScale(.large)
                            .font(viewModel.configuration.style.numberFont)
                            .frame(maxWidth: 24, maxHeight: 24)
                        
                        if showNumber {
                            Text("\(viewModel.voteCount)")
                                .lineLimit(1)
                                .foregroundColor(hasVoted ? viewModel.configuration.style.selectedForegroundColor : viewModel.configuration.style.tintColor)
                                .minimumScaleFactor(0.5)
                                .font(viewModel.configuration.style.numberFont)
                        }
                    }
                    .padding(viewModel.configuration.style.radius)
                    .frame(minWidth: 56, minHeight: 64)
                    .background(backgroundView)
                }
                
            }
            .contentShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
            .overlay(overlayBorder)
        }
        .buttonStyle(.plain)
        .onChange(of: viewModel.voteCount) { newCount in
            if newCount > 0 {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.4, blendDuration: 0)) {
                    showNumber = true
                }
            }
        }
        .onChange(of: viewModel.feature.hasVoted) { newVote in
            withAnimation(.spring(response: 0.45, dampingFraction: 0.4, blendDuration: 0)) {
                hasVoted = newVote
            }
        }
        .onHover { newHover in
            if !hasVoted {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                    isHovering = newHover
                }
            }
        }
        .onAppear {
            showNumber = viewModel.voteCount > 0
            withAnimation(.spring(response: 0.45, dampingFraction: 0.4, blendDuration: 0)) {
                hasVoted = viewModel.feature.hasVoted
            }
        }
        .accessibilityHint(Text("Vote for \(viewModel.feature.featureTitle)"))
        .help("Vote for \(viewModel.feature.featureTitle)")
        .animateAccessible()
        .accessibilityShowsLargeContentViewer()
    }
    
    @ViewBuilder
    var overlayBorder : some View {
        if isHovering {
            RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous)
                .stroke(viewModel.configuration.style.tintColor, lineWidth: 1)
        }
    }
    
    private var backgroundView : some View {
        viewModel.configuration.style.tintColor
            .opacity(hasVoted ? 1 : 0.1)
            .clipShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
    }
    
}
