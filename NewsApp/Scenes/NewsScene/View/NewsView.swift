//
//  NewsView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol ViewModel {
  var imageUrl: URL? { get }
  var newsUrl: URL? { get }
  var publishedAt: Date? { get }
  var title: String { get }
  var author: String { get }
  var descriptionNews: String { get }
  var isNewsSaved: Bool { get }
}

protocol NewsViewOutput {
  func userInterfaceDidLoad()
  func loadDataCurrentPage()
  func loadDataNextPage()
  func filterNews(keyWord: String)
  func showDetailes(at index: IndexPath)
  func menuClicked()
}

protocol NewsViewInput: class {
  func provideObject(at index: IndexPath) -> ViewModel
  var count: Int { get }
}

final class NewsView: UIViewController {
  // MARK: - Properties
  private let heightForCell: CGFloat = 280
  private let refreshControl = UIRefreshControl()

  // swiftlint:disable implicitly_unwrapped_optional
  var output: NewsViewOutput!
  weak var input: NewsViewInput!

  // MARK: - Outlets
  @IBOutlet private weak var newsListTableView: UITableView!
  @IBOutlet private weak var searchTextField: UITextField!
  @IBOutlet private weak var notFoundNewsView: UIView!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    tableViewSettings()
    refreshControlSettings()
    output.userInterfaceDidLoad()
  }

  // MARK: - Actions
  @IBAction func editingChangedSearchTextFiled(_ sender: UITextField) {
    output.filterNews(keyWord: sender.text ?? "")
  }

  @IBAction func menuClicked(_ sender: UIButton) {
    output.menuClicked()
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
    output.loadDataNextPage()
  }

  private func checkOperatorTableViewForEmpty() {
    notFoundNewsView.isHidden = !newsListTableView.visibleCells.isEmpty
  }

  private func stopAnimation() {
    activityIndicator.stopAnimating()
    refreshControl.endRefreshing()
  }

  private func showActionSheet() {
    let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
    let showOffline = UIAlertAction(title: R.string.localizable.actionSheetShowOffline(), style: .default)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    optionMenu.addAction(showOffline)
    optionMenu.addAction(cancelAction)
    self.present(optionMenu, animated: true, completion: nil)
  }
}

// MARK: - Extension TableView
extension NewsView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForCell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return input.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = R.nib.newsTableViewCell.identifier
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    cell.selectionStyle = .none
    let news = input.provideObject(at: indexPath)
    cell.updateUI(title: news.title, newsDescription: news.descriptionNews, author: news.author, imageUrl: news.imageUrl, publishedAt: news.publishedAt)
    cell.showDetailesView = { bool in
      self.output.showDetailes(at: indexPath)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == input.count - 1 {
      output.loadDataNextPage()
    }
  }
}

extension NewsView: NewsControllerOutput {
  func presentView(view: DetailesView) {
    present(view, animated: true)
  }

  func displayAlert(title: String, message: String) {
    showAlert(title: title, message: message)
  }

  func displayActionSheet() {
    showActionSheet()
  }

  func displayUpdate() {
    searchTextField.endEditing(true)
    stopAnimation()
    newsListTableView.reloadData()
  }
}
