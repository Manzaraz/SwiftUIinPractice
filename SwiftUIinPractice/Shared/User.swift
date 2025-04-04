//
//  User.swift
//  SwiftUIinPractice
//
//  Created by Christian Manzaraz on 02/04/2025.
//

import Foundation

struct UserArray: Codable {
    let users: [User]
    let total, skip, limit: Int
}

struct User: Codable, Identifiable {
    let id: Int
    let firstName, lastName: String
    let age: Int
    let email, phone, username, password: String
    let birthDate: String
    let image: String
    let height, weight: Double
    
    static var mock: User {
        User(
            id: 333,
            firstName: "Christian",
            lastName: "Manzaraz",
            age: 43,
            email: "magnusmanz@gmail.com",
            phone: "",
            username: "",
            password: "",
            birthDate: "",
            image: Constants.randomImage,
            height: 165,
            weight: 70
        )
    }
}
