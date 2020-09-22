//
//  NewsView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol TableViewDataSource {
  func count() -> Int
  func titleNewsForIndex(_ index: Int) -> String
  func newsDescriptionForIndex(_ index: Int) -> String
  func authorPostNewsForIndex(_ index: Int) -> String
  func imageUrlStrForIndex(_ index: Int) -> String
  func publishedAtForIndex(_ index: Int) -> Date
}

protocol NewsViewOutput: class {
  func userInterfaceDidLoad()
  func loadData()
  func userFilteringNews(keyWord: String)
  func pullToRefresh()
}

protocol NewsViewInput: class {
  var newsListTableDataSource: TableViewDataSource { get }
}

class NewsView: UIViewController {
  // MARK: - Properties
  private let heightForCell: Int = 280
  private let refreshControl = UIRefreshControl()
  private var dataSource: TableViewDataSource!

  weak var output: NewsViewOutput!
  var input: NewsViewInput! {
    didSet {
        dataSource = input.newsListTableDataSource
    }
}

  // MARK: - Outlets
  @IBOutlet private weak var newsListTableView: UITableView!
  @IBOutlet private weak var searchTextField: UITextField!
  @IBOutlet private weak var notFoundNewsView: UIView!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    NewsController().configure(viewController: self)
    hideKeyboardWhenTappedAround()
    refreshControlSettings()
    tableViewSettings()
    output.userInterfaceDidLoad()
  }

  // MARK: - Actions
  @IBAction func editingChangedSearchTextFiled(_ sender: UITextField) {
    output.userFilteringNews(keyWord: sender.text!)
  }

  // MARK: - Functions
  private func refreshControlSettings() {
    refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
    newsListTableView.addSubview(refreshControl)
  }

  private func tableViewSettings() {
    newsListTableView.register(R.nib.newsTableViewCell)
  }

  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    output.pullToRefresh()
  }

  private func checkOperatorTableViewForEmpty() {
    notFoundNewsView.isHidden = !newsListTableView.visibleCells.isEmpty
  }

  private func stopAnimation() {
    activityIndicator.stopAnimating()
    refreshControl.endRefreshing()
  }
}

// MARK: - Extension TableView
extension NewsView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(heightForCell)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "NewsTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    cell.selectionStyle = .none
    cell.updateUI(title: dataSource.titleNewsForIndex(indexPath.row), newsDescription: dataSource.newsDescriptionForIndex(indexPath.row), author: dataSource.authorPostNewsForIndex(indexPath.row), imageUrlStr: dataSource.imageUrlStrForIndex(indexPath.row), publishedAt: dataSource.publishedAtForIndex(indexPath.row))

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == dataSource.count() - 1 {
      output.loadData()
    }
  }
}

extension NewsView: NewsControllerOutput {
  func displayAlert(title: String, message: String) {
      self.showAlert(title: title, message: message)
    }

    func displayUpdate() {
      self.stopAnimation()
      self.view.endEditing(true)
      self.newsListTableView.reloadData()
    }
}
