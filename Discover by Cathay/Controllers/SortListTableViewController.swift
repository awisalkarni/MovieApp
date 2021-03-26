//
//  SortListTableViewController.swift
//  Discover by Cathay
//
//  Created by Awis Alkarni on 25/03/2021.
//

import Foundation
import UIKit
import RxSwift

class SortListTableViewController: UITableViewController {

    //  available sort items
    //, popularity.asc, popularity.desc, release_date.asc, release_date.desc, revenue.asc, revenue.desc, primary_release_date.asc, primary_release_date.desc, original_title.asc, original_title.desc, vote_average.asc, vote_average.desc, vote_count.asc, vote_count.desc
    let sortItems = [
        "release_date.desc",
        "release_date.asc",
        "original_title.asc",
        "popularity.desc"
    ]
    
    var selectedSort = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortItems.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSort.onNext(sortItems[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
}
