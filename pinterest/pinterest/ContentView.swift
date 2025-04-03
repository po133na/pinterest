//
//  ContentView.swift
//  pinterest
//
//  Created by Polina Stelmakh on 03.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PinterestViewModel()

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.images) { image in
                            AsyncImage(url: URL(string: image.url)) { phase in
                                switch phase {
                                case .empty:
                                    ShimmerView()
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 16, height: 250)
                                        .cornerRadius(15)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 16, height: CGFloat.random(in: 220...300))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .shadow(radius: 5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.white.opacity(0.8), lineWidth: 2)
                                        )
                                case .failure:
                                    Button(action: {
                                        viewModel.retryLoading(image: image)
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    }) {
                                        Image(systemName: "arrow.clockwise.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.red)
                                            .shadow(radius: 5)
                                    }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                Button(action: {
                    viewModel.fetchImages()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    Label("More images", systemImage: "photo.fill")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.pink]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .bold()
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                        .padding(.horizontal, 15)
                }
            }
            .navigationTitle("Pinterest")
            .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    ContentView()
}
