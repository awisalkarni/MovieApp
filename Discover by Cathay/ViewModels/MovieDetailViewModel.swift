//
//  MovieDetailViewModel.swift
//  Discover by Cathay
//
//  Created by Awis Alkarni on 23/03/2021.
//

import Foundation
import RxSwift

//Synopsis
//Genres
//Language
//Duration

struct MovieDetailViewModel {
    let movieDetail: MovieDetail
    let disposeBag = DisposeBag()
    
    init(_ movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
    }
}

extension MovieDetailViewModel {
    var title: Observable<String> {
        return Observable<String>.just(movieDetail.title)
    }
    
    var overview: Observable<String> {
        return Observable<String>.just(movieDetail.overview)
    }
    
    var genres: Observable<String> {
        
        var genresStringArray = [String]()
        if let genres =  movieDetail.genres {
            for genre in genres {
                genresStringArray.append(genre.name)
            }
        }
        
        return Observable<String>.just(genresStringArray.count != 0 ? "Genres: \(genresStringArray.joined(separator: ", "))" : "Genres unavailable")
    }
    
    var spoken_language: Observable<String> {
        
        var languagesArray = [String]()
        
        for language in movieDetail.spoken_languages {
            languagesArray.append(language.english_name)
        }
        let languagesString = languagesArray.joined(separator: ", ")
        return Observable<String>.just(languagesArray.count != 0 ? "Languages: \(languagesString)" : "No language found")
    }
    
    var original_language: Observable<String> {
        return Observable<String>.just("Original Language: \(movieDetail.original_language)")
    }
    
    var runtime: Observable<String> {
        if let runtime = movieDetail.runtime {
            if runtime != 0 {
                return Observable<String>.just("Duration: \(secondsToHoursMinutesSeconds(minutes: runtime))")
            }
        }
        return Observable<String>.just("Duration unavailable")
    }
    
    var poster_path:Observable<String> {
        var fullPath = ""
        if let posterPath = movieDetail.poster_path {
            fullPath = "https://image.tmdb.org/t/p/w500/\(posterPath)"
        }
        return Observable<String>.just(fullPath)
    }
}

func secondsToHoursMinutesSeconds (minutes : Int) -> String {
    let (h,m) = (minutes/60, (minutes % 60))
    return "\(h) hours \(m) minutes"
}


