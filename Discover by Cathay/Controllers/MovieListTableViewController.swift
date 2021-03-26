//
//  MovieListTableViewController.swift
//  Discover by Cathay
//
//  Created by Awis Alkarni on 22/03/2021.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class MovieListTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    private var movieListVM: MovieListViewModel!
    private var movieDetailVM: MovieDetailViewModel!
    
    private var pullControl = UIRefreshControl()
    var page = 1
    var sortBy = "release_date.desc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
                if #available(iOS 10.0, *) {
                    tableView.refreshControl = pullControl
                } else {
                    tableView.addSubview(pullControl)
                }
        
        loadMovies(forPage: page, isFromScroll: false)
    }

    @objc private func refreshListData(_ sender: Any) {
        loadMovies(forPage: page, isFromScroll: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieListVM == nil ? 0 : self.movieListVM.moviesVM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            fatalError("MovieTableViewCell not found")
        }
        
        let movieVM = self.movieListVM.movieAt(indexPath.row)
        
        movieVM.title
            .asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        movieVM.poster_path
            .subscribe(onNext: { fullPath in
                cell.posterImageView.sd_setImage(with: URL(string: fullPath), placeholderImage: UIImage(named: "placeholder.png"))
            }).disposed(by: disposeBag)
        
        movieVM.popularity
            .asDriver(onErrorJustReturn: "")
            .drive(cell.popularityLabel.rx.text)
            .disposed(by: disposeBag)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovieId = self.movieListVM.movieAt(indexPath.row).id
        
        selectedMovieId.subscribe(onNext: { id in
            self.loadMovieDetail(usingId: id)
        }).disposed(by: disposeBag)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            guard let destinationNC = segue.destination as? UINavigationController,
                  let detailVC = destinationNC.viewControllers.first as? MovieDetailViewController else {
                fatalError("MovieDetailViewController not found")
            }
            
            detailVC.movieDetailVM = self.movieDetailVM
        } else {
            guard let sortVC = segue.destination as? SortListTableViewController else {
                fatalError("SortListTableViewController not found")
            }
            
            sortVC.selectedSort.subscribe(onNext: { [weak self] selectedSortItem in
                DispatchQueue.main.async {
                    self?.loadMovies(forPage: 1, isFromScroll: false, sortBy: selectedSortItem)
                }
            }).disposed(by: disposeBag)
        }
    }
    
    
    
    var isLoading = false
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.movieListVM.movies.count - 1
        if !isLoading && indexPath.row == lastElement {
            isLoading = true
            loadMovies(forPage: page + 1, isFromScroll: true)
        }
    }

    
    private func loadMovieDetail(usingId id: Int){
        
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=328c283cd27bd1877d9080ccb1604c91"
        let resource = Resource<MovieDetail>(url: URL(string: url)!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { [weak self] movieDetail in
                
                self?.movieDetailVM = MovieDetailViewModel(movieDetail)
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "showDetailSegue", sender: self?.tableView)
                }
            }).disposed(by: disposeBag)
    }
    
    
    private func loadMovies(forPage page: Int = 1, isFromScroll: Bool = false, sortBy sort: String = "release_date.desc"){
        
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&primary_release_date.lte=2021-12-31&sort_by=\(sort)&page=\(page)"
        
        let resource = Resource<MovieList>(url: URL(string: url)!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { movieList in
                var movies = movieList.results
                
                if isFromScroll && self.movieListVM != nil {
                    let existingMovies = self.movieListVM.movies
                    movies = existingMovies + movies
                } else {
                    movies = movieList.results
                }
                
                self.movieListVM = MovieListViewModel(withMovies: movies, andData: movieList)
                self.page = movieList.page
                self.isLoading = false
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.pullControl.endRefreshing()
                }
            }).disposed(by: disposeBag)
        
    }
    
    
}
