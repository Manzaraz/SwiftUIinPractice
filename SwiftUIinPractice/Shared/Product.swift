//
//  Product.swift
//  SwiftUIinPractice
//
//  Created by Christian Manzaraz on 02/04/2025.
//

import Foundation

struct ProductArray: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

struct Product: Codable, Identifiable {
    let id: Int
    let title, description: String
    let price, discountPercentage, rating: Double
    let stock: Int
    let tags: [String]
    let brand: String?
    let category: String
    let images: [String]
    let thumbnail: String
    
    var firstImage: String {
        images.first ?? Constants.randomImage
    }
}

struct ProductRow: Identifiable {
    let id = UUID().uuidString
    let title: String
    let products: [Product]
}

//enum ProductCategory: String, Codable {
//    case beauty = "beauty"
//    case fragrances = "fragrances"
//    case furniture = "furniture"
//    case groceries = "groceries"
//}
