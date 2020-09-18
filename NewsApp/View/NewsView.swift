//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

enum AlertMessages {
  case limitError
}

class NewsView: UIViewController {
  // MARK: - Properties
  let refreshControl = UIRefreshControl()
  var listNews: [NewsEntity] = []
  var isFiltering: Bool = false

  var notificationToken: NotificationToken? = nil

  // MARK: - Outlets
  @IBOutlet weak var newsListTableView: UITableView!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var notFoundNewsView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    refreshControlSettings()
    tableViewSettings()
    observeRealm()
    NewsController.loadNews(isNextPage: nil) { (result) in
      switch result {
      case true:
        self.stopAnimation()
      case false:
        self.showAlert(title: "Error", message: "You have requested too many results. Developer accounts are limited to a max of 100 results. You are trying to request results 100 to 125. Please upgrade to a paid plan if you need more results.")
      }
    }
  }

  deinit {
    notificationToken?.invalidate()
  }

  // MARK: - Actions
  @IBAction func editingChangedSearchTextFiled(_ sender: UITextField) {
    if sender.text?.isEmpty == false {
      isFiltering = true
      // swiftlint:disable force_unwrapping
      listNews = DatabaseService.filterNews(predicate: sender.text!.lowercased())
    } else {
      listNews = DatabaseService.loadData()
      isFiltering = false
      checkOperatorTableViewForEmpty()
      self.view.endEditing(true)
    }
    newsListTableView.reloadData()
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
  }

  ///RealmSettings
  func observeRealm() {
    // swiftlint:disable force_try
    let realm = try! Realm()
    let results = realm.objects(NewsEntity.self)
    notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.newsListTableView else { return }
      switch changes {
      case .initial, .update:
        self?.listNews = DatabaseService.loadData()
        tableView.reloadData()
      case .error(let error):
        fatalError("\(error)")
      }
    }
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
    return 280
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //count of slots in table
    return listNews.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "NewsTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    cell.selectionStyle = .none
    let post = listNews[indexPath.row]

    cell.titleNews.text = post.title
    cell.descriptionNews.text = post.descriptionNews
    cell.authorPostNews.text = post.author
    cell.showMoreButton.isHidden = !cell.descriptionNews.isTruncated
    // swiftlint:disable force_unwrapping
    if let escapedString = post.urlToImage!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
      if let url = URL(string: escapedString) {
        cell.imageNews.af.setImage(withURL: url)
      }
    }
    cell.postTimeNews.text = TimeDateFormatters.hoursMinutesDateFormatter.string(from: post.publishedAt ?? Date())

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == listNews.count - 1, !isFiltering {
      NewsController.loadNews(isNextPage: true, completion: nil)
    }
  }
}
