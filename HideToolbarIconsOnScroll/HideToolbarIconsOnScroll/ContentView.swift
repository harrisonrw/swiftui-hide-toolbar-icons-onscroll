//
//  ContentView.swift
//  HideToolbarIconsOnScroll
//
//  Created by Robert Harrison on 2/4/25.
//

import SwiftUI

struct ToolbarButton: View {
    var icon: String
    @Binding var toolbarVisibility: Visibility
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundStyle(.white.opacity(toolbarVisibility == .visible ? 1.0 : 0.0))
                .font(.system(size: 14))
                .padding(6)
        }
        .buttonStyle(ToolbarButtonStyle(toolbarVisibility: $toolbarVisibility))
    }
}

struct ToolbarButtonStyle: ButtonStyle {
    @Binding var toolbarVisibility: Visibility
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(4)
            .background(Color.black.opacity(toolbarVisibility == .visible ? 0.8 : 0.0))
            .clipShape(Circle())
            .disabled(toolbarVisibility != .visible)
            .scaleEffect(configuration.isPressed ? 0.75 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct HomeToolbar: ToolbarContent {
    // The toolbarVisibility is passed to the ToolbarButtons to show/hide the buttons using an opacity change.
    @Binding var toolbarVisibility: Visibility
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            ToolbarButton(icon: "person.fill",
                          toolbarVisibility: $toolbarVisibility) {
                print("person pressed")
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 15) {
                ToolbarButton(icon: "cloud.fill", toolbarVisibility: $toolbarVisibility) {
                    print("cloud pressed")
                }
                
                ToolbarButton(icon: "plus", toolbarVisibility: $toolbarVisibility) {
                    print("plus pressed")
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var items: [UUID] = (1...100).compactMap { _ in UUID() }
    
    @State private var toolbarVisibility: Visibility = .visible
    @State private var lastContentOffset: CGFloat = 0.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.pink
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    LazyVStack {
                        ForEach(items, id: \.self) { item in
                            ItemView(item: item)
                        }
                    }
                    .scrollTargetLayout()
                }
                .onScrollPhaseChange { oldPhase, newPhase, context in
                    let currentOffset = context.geometry.contentOffset.y
                    let isScrollingDown = currentOffset > lastContentOffset
                    
                    switch newPhase {
                    case .interacting, .tracking:
                        break
                    case .animating, .decelerating:
                        if oldPhase == .interacting || oldPhase == .tracking {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                toolbarVisibility = isScrollingDown ? .hidden : .visible
                            }
                        }
                    case .idle:
                        if oldPhase != .idle && abs(currentOffset - lastContentOffset) > 20 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                toolbarVisibility = isScrollingDown ? .hidden : .visible
                            }
                        }
                    }
                    
                    lastContentOffset = currentOffset
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                HomeToolbar(toolbarVisibility: $toolbarVisibility)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            // Not hiding the toolbar with .toolbarVisibility() because it causes a weird animation.
            // Setting opacity in HomeToolbar instead.
//            .toolbarVisibility(toolbarVisibility, for: .navigationBar)
        }
        .statusBarHidden(toolbarVisibility != .visible)
    }
}

#Preview {
    ContentView()
}
