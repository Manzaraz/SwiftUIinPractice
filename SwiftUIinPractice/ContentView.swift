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
    
    @State private var users: [User] = []
    @State private var products: [Product] = []
    
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                ForEach(products) { product in
                    Text(product.title)
                        .font(.title3)
                        .foregroundStyle(.spotifyGreen)
                    
                }
            }
        }
        .padding()
        .task {
            await getData()
        }
    }
    
    
    private func getData() async {
        do {
            products = try await DatabasesHelper().getProducts()
            users = try await DatabasesHelper().getUsers()
        } catch  {
            print(error.localizedDescription)
        }
    }

}

#Preview {
    ContentView()
}
