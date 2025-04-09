//
//  ContentView.swift
//  SwiftUIinPractice
//
//  Created by Christian Manzaraz on 31/03/2025.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct ContentView: View {
    
    @Environment(\.router) var router
    @State private var users: [User] = []
    @State private var products: [Product] = []
    
    
    var body: some View {
        List {
            Button("Open Spotify") {
                router.showScreen(.fullScreenCover) { router in
                    SpotifyHomeView(viewModel: SpotifyHomeViewModel(router: router))
                }
            }
        }
        
    }
}

#Preview {
    RouterView { _ in
        ContentView()
    }
}


//extension ContentView {
//    
//    private func getData() async {
//        do {
//            products = try await DatabasesHelper().getProducts()
//            users = try await DatabasesHelper().getUsers()
//        } catch  {
//            print(error.localizedDescription)
//        }
//    }
//    
//}
