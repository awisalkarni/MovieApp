//
//  MovieViewModel.swift
//  Discover by Cathay
//
//  Created by Awis Alkarni on 22/03/2021.
//

import Foundation
import RxSwift

struct MovieListViewModel {
    let moviesVM: [MovieViewModel]
    let movies: [Movie]
    let page: Int
}

extension MovieListViewModel {
    init(withMovies movies: [Movie], andData data: MovieList) {
        self.moviesVM = movies.compactMap(MovieViewModel.init)
        self.movies = movies
        self.page = data.page
    }
}

extension MovieListViewModel {
    func movieAt(_ index: Int) -> MovieViewModel {
        return self.moviesVM[index]
    }
    
    func getMovies() -> [Movie] {
        return self.movies
    }
    
    func getPage() -> Int {
        return page
    }
}

struct MovieViewModel {
    let movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
    }
}

extension MovieViewModel {
    var title: Observable<String> {
        return Observable<String>.just(movie.title)
    }
    
    var overview:Observable<String> {
        return Observable<String>.just(movie.overview)
    }
    
    var popularity:Observable<String> {
        return Observable<String>.just("Popularity: \(movie.popularity)")
    }
    
    var poster_path:Observable<String> {
        var fullPath = ""
        if let posterPath = movie.poster_path {
            fullPath = "https://image.tmdb.org/t/p/w500/\(posterPath)"
        }
        return Observable<String>.just(fullPath)
    }
    
    var id: Observable<Int> {
        return Observable<Int>.just(movie.id)
    }
}
