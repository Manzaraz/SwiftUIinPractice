//
//  SpotifyPlaylistView.swift
//  SwiftUIinPractice
//
//  Created by Christian Manzaraz on 04/04/2025.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct SpotifyPlaylistView: View {
    var product: Product = .mock
    var user: User = .mock
    
    @Environment(\.router) var router

    @State private var products = [Product]()
    @State private var showHeader = true
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    PlaylistHeaderCell(
                        height: 250,
                        title: product.title,
                        subtitle: product.brand ?? ""   ,
                        imageName: product.thumbnail)
                    .readingFrame { frame in
                        showHeader = frame.maxY < 140
                    }                    
                    
                    PlaylistDescriptionCell(
                        descriptionText: product.description,
                        userName: user.firstName,
                        subheadline: product.category,
                        onAddToPlaylistPressed: nil,
                        onDownloadPressed: nil,
                        onSharePressed: nil,
                        onEllipsisPressed: nil,
                        onShufflePressed: nil,
                        onPlayPressed: nil
                    )
                        .padding(.horizontal, 16)
                    
                    ForEach(products) { product in
                        SongRowCell(
                            imageSize: 50,
                            imageName: product.firstImage,
                            title: product.title,
                            subtitle: product.brand) {
                                goToPlaylistView(product: product)
                            } onEllipisPressed: {
                                // do something when the ellipsis is pressed
                            }
                    }
                    .padding(.leading, 16)
                }
            }
            .scrollIndicators(.hidden)
            
            header
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .task {
            await getData()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    RouterView { _ in
        SpotifyPlaylistView()
    }
}


extension SpotifyPlaylistView {
    private var header: some View {
        ZStack {
            Text(product.title)
                .font(.headline)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color.spotifyBlack)
                .offset(y: showHeader ? 0 : -40)
                .opacity(showHeader ? 1 : 0)
            
            Image(systemName: "chevron.left")
                .font(.title3)
                .padding(10)
                .background(showHeader ? Color.black.opacity(0.001) : Color.spotifyGray.opacity(0.7))
                .clipShape(Circle())
                .onTapGesture {
                    router.dismissScreen()                    
                }
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(.spotifyWhite)
        .animation(.smooth(duration: 0.25), value: showHeader)
    }
    
    private func goToPlaylistView(product: Product) {
        router.showScreen(.push) { _ in
            SpotifyPlaylistView(product: product, user: user)
        }
    }
}


extension SpotifyPlaylistView {
    private func getData() async {
        do {
            products = try await DatabasesHelper().getProducts()
            
        } catch  {
            print(error.localizedDescription)
        }
    }
}

