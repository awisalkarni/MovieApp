//
//  MovieDetailViewController.swift
//  Discover by Cathay
//
//  Created by Awis Alkarni on 22/03/2021.
//

import Foundation
import RxSwift
import RxCocoa
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    var movieDetailVM: MovieDetailViewModel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        movieDetailVM.title
            .subscribe(onNext: { [weak self] title in
                self?.title = title
            }).disposed(by: disposeBag)
        
        movieDetailVM.overview
            .asDriver(onErrorJustReturn: "")
            .drive(overviewLabel.rx.text)
            .disposed(by: disposeBag)
        
        movieDetailVM.spoken_language
            .asDriver(onErrorJustReturn: "")
            .drive(languageLabel.rx.text)
            .disposed(by: disposeBag)
        
            //todo genres
        movieDetailVM.genres
            .asDriver(onErrorJustReturn: "")
            .drive(genresLabel.rx.text)
            .disposed(by: disposeBag)
        
        movieDetailVM.runtime
            .asDriver(onErrorJustReturn: "")
            .drive(durationLabel.rx.text)
            .disposed(by: disposeBag)
        
        movieDetailVM.poster_path
            .subscribe(onNext: {[weak self] fullPath in
                self?.posterImageView.sd_setImage(with: URL(string: fullPath), placeholderImage: UIImage(named: "placeholder.png"))
            }).disposed(by: disposeBag)
        
    }

    
}
