//
//  Movie.swift
//  Discover by Cathay
//
//  Created by Awis Alkarni on 22/03/2021.
//

import Foundation

struct MovieList: Decodable {
    let results: [Movie]
    let page: Int
    let total_pages: Int
    let total_results: Int
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let release_date: String
    let poster_path: String?
    let popularity: Double
}
