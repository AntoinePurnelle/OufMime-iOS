//
//  WordModel.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 04/03/2022.
//

import Foundation

struct Word {
    let word: String
    let category: Category
}

struct Words: Codable {
    let version: Int
    let actions: [String]
    let activities: [String]
    let anatomy: [String]
    let animals: [String]
    let celebrities: [String]
    let clothes: [String]
    let events: [String]
    let fictional: [String]
    let food: [String]
    let geek: [String]
    let jobs: [String]
    let locations: [String]
    let mythology: [String]
    let nature: [String]
    let objects: [String]
    let vehicles: [String]
}
