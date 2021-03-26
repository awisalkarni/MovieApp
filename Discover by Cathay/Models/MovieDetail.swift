//
//  MovieDetail.swift
//  Discover by Cathay
//
//  Created by Awis Alkarni on 23/03/2021.
//

import Foundation

//Synopsis
//Genres
//Language
//Duration

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let overview: String
    let original_language: String
    let genres: [Genre]?
    let runtime: Int?
    let spoken_languages: [SpokenLanguage]
    let poster_path: String?
}

struct SpokenLanguage:Decodable {
    let english_name: String
    let iso_639_1: String
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
