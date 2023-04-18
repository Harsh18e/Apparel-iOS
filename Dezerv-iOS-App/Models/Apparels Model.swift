//
//  Apparels Model.swift
//  Dezerv-iOS-App
//
//  Created by Harsh Kumar Agrawal on 18/04/23.
//

import Foundation

// MARK: - Apparel
struct Apparel: Codable {
    let id: Int
    let title: String?
    let price: Double?
    let description: String?
    let category: Category?
    let image: String?
    let rating: Rating?
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
    case home = "Home Page - Apparels"
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double?
    let count: Int?
}

typealias Apparels = [Apparel]
