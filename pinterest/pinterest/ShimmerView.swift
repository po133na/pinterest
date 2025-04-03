//
//  ShimmerView.swift
//  pinterest
//
//  Created by Polina Stelmakh on 03.04.2025.
//


import SwiftUI

struct ShimmerView: View {
    @State private var opacity: Double = 0.3

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.gray.opacity(opacity))
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    opacity = 0.6
                }
            }
    }
}
