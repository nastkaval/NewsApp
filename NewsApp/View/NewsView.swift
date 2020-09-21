//
//  NewsView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

protocol NewsViewOutput {
  func userInterfaceDidLoad()
  func actionScrollToBottom()
  func userFilteringNews(keyWord: String)
  func userCleanFilterNews()
  func pullToRefresh()
}

protocol NewsViewInput {
  var newsArray: [NewsEntity] { get }
  func newsForIndex(_ index: Int) -> NewsEntity
}

class NewsView: UIViewController {
  // MARK: - Properties
  let refreshControl = UIRefreshControl()
  var isFiltering: Bool = false

  var output: NewsViewOutput!
  var input: NewsViewInput!

  // MARK: - Outlets
  @IBOutlet weak var newsListTableView: UITableView!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var notFoundNewsView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureVC()
    hideKeyboardWhenTappedAround()
    refreshControlSettings()
    tableViewSettings()
    output.userInterfaceDidLoad()
  }

  private func configureVC() {
    let controller = NewsController()
    controller.output = self
    self.output = controller
    self.input = controller
  }

  // MARK: - Actions
  @IBAction func editingChangedSearchTextFiled(_ sender: UITextField) {
    if sender.text?.isEmpty == false {
      isFiltering = true
      output.userFilteringNews(keyWord: sender.text!.lowercased())
    } else {
      isFiltering = false
      output.userCleanFilterNews()
    }
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
    return CGFloat(Constants.heightForCell)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //count of slots in table
    return input.newsArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "NewsTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    cell.selectionStyle = .none
    let post = input.newsForIndex(indexPath.row)
    cell.updateUI(data: post)

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == input.newsArray.count - 1, !isFiltering {
      output.actionScrollToBottom()
    }
  }
}

extension NewsView: NewsControllerOutput {
    func displayAlert() {
      self.showAlert(title: "Error", message: "You have requested too many results. Developer accounts are limited to a max of 100 results. You are trying to request results 100 to 125. Please upgrade to a paid plan if you need more results.")
    }

    func displayUpdate() {
      self.stopAnimation()
      if isFiltering {
        checkOperatorTableViewForEmpty()
      }
      self.view.endEditing(true)
      self.newsListTableView.reloadData()
    }
}
