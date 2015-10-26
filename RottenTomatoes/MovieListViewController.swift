//
//  MovieListViewController.swift
//  RottenTomatoes
//
//  Created by Robert Xue on 10/25/15.
//  Copyright © 2015 roboxue. All rights reserved.
//

import UIKit
import SwiftyJSON

class MovieListViewController: UIViewController {
    private var _tableView: UITableView!
    private var _movies = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
        }
        title = "Movies"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    func refresh() {
        RTDataSource.getBoxOffice({ (movies) -> Void in
            self._movies = movies
            self.tableView.reloadData()
        }) { (error) -> Void in
            self._movies = [JSON]()
            self.tableView.reloadData()
        }
    }
}

extension MovieListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseId = "movie"
        let cell: RTMovieCell!
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(reuseId) as? RTMovieCell {
            cell = reuseCell
        } else {
            cell = RTMovieCell(style: .Value1, reuseIdentifier: "movie")
        }
        let movie = _movies[indexPath.row]
        cell.withMovie(movie)
        return cell
    }
}

extension MovieListViewController {
    var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
            _tableView.dataSource = self
            _tableView.tableFooterView = UIView()
            _tableView.rowHeight = CGFloat(RTMovieCellHeight)
        }
        return _tableView
    }
}
