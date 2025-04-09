//
//  SpotifyHomeView.swift
//  SwiftUIinPractice
//
//  Created by Christian Manzaraz on 02/04/2025.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

@Observable
final class SpotifyHomeViewModel {
    let router: AnyRouter
    
    var currentUser: User? = nil 
    var selectedCategory: Category? = nil
    var products: [Product] = []
    var productRows: [ProductRow] = []
    
    init(router: AnyRouter) {
        self.router = router
        self.currentUser = currentUser
        self.selectedCategory = selectedCategory
        self.products = products
        self.productRows = productRows
    }
}


struct SpotifyHomeView: View {
    
    @State var viewModel: SpotifyHomeViewModel
    
    @Environment(\.router) var router

    @State private var currentUser: User? = nil
    @State private var selectedCategory: Category? = nil
    @State private var products: [Product] = []
    @State private var productRows: [ProductRow] = []
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVStack (spacing: 1, pinnedViews: [.sectionHeaders]) {
                    Section {
                        VStack (spacing: 16) {
                            recentsSection
                                .padding(.horizontal, 16)
                            
                            if let product = products.first {
                                newReleaseSection(product: product)
                                    .padding(.horizontal, 16)
                            }
                            
                            listRows
                        }
                        
                    } header: {
                        header
                    }
                }
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .clipped()
            
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    RouterView { router in
        SpotifyHomeView(viewModel: SpotifyHomeViewModel(router: router))
    }
}

extension SpotifyHomeView {
    private var header: some View {
        HStack (spacing: 0) {
            ZStack {
                if let currentUser {
                    ImageLoaderView(urlString: currentUser.image)
                        .background(.spotifyWhite)
                        .clipShape(Circle())
                        .onTapGesture {
                            router.dismissScreen()
                        }
                }
            }
            .frame(width: 35, height: 35)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(Category.allCases, id: \.self) { category in
                        SpotifyCategoryCell(
                            title: category.rawValue.capitalized,
                            isSelected: category == selectedCategory
                        )
                        .onTapGesture {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, 24)
        .padding(.leading, 8)
        .background(.spotifyBlack)
    }
    
    
    private var recentsSection: some View {
        NonLazyVGrid(
            columns: 2,
            alignment: .center,
            spacing: 10,
            items: products) { product in
                if let product {
                    SpotifyRecentsCell(
                        imageName: product.firstImage,
                        title: product.title
                    )
                    .asButton(.press) {
                        goToPlaylistView(product: product)
                    }
                }
            }
    }
    
    
    private func goToPlaylistView(product: Product) {
        guard let currentUser else { return }
        router.showScreen(.push) { _ in
            SpotifyPlaylistView(product: product, user: currentUser)
        }
    }
    
    
    private func newReleaseSection(product: Product) -> some View {
        SpotifyNewReleaseCell(
            imageName: product.firstImage,
            headline: product.brand,
            subHeadline: product.category,
            title: product.title,
            subTitle: product.description,
            onAddToPlaylistPressed: {
                // TODO: Add to playlist feature8
            },
            onPlayPressed: {
                // TODO: Play button action
                goToPlaylistView(product: product)
            })
    }
    
    
    private var listRows: some View {
        ForEach(productRows) { row in
            VStack(spacing: 8) {
                Text(row.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.spotifyWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(row.products) { product in
                            ImageTitleRowCell(
                                imageSize: 120,
                                imageName: product.firstImage,
                                title: product.title
                            )
                            .asButton(.press) {
                                goToPlaylistView(product: product)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}


extension SpotifyHomeView {
    private func getData() async {
        guard products.isEmpty else { return }
        
        do {
            currentUser = try await DatabasesHelper().getUsers().first
            products = try await Array(DatabasesHelper().getProducts().prefix(8))
            
            var rows: [ProductRow] = []
            // MARK: - Rows sortered by Brands
            let allBrands = Set(products.map({ $0.brand }))
            for brand in allBrands {
                rows.append(ProductRow(
                    // let products = self.products.filter { $0.brand ?? "" == brand }
                    title: brand?.capitalized ?? "",
                    products: products))
            }

            // MARK: - If you want the rows orderd by Categories
//            let allCategories = Set(products.map({ $0.category }))
//            for category in allCategories {
//                let products = self.products.filter { $0.category == category }
//                rows.append(ProductRow(
//                    title: category.capitalized,
//                    products: products))
//            }
            productRows = rows
            
        } catch  {
            print(error.localizedDescription)
        }
    }
}
