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
  func showOfflineCollectionNews()
}

protocol NewsViewInput: AnyObject {
  func provideObject(at index: IndexPath) -> ViewModel
  var count: Int { get }
}

final class NewsView: UIViewController {
  // MARK: - Properties
  private let heightForCell: CGFloat = 280
  private let refreshControl = UIRefreshControl()
  weak var input: NewsViewInput?
  var output: NewsViewOutput?

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
    output?.userInterfaceDidLoad()
  }

  // MARK: - Actions
  @IBAction private func editingChangedSearchTextFiled(_ sender: UITextField) {
    if refreshControl.isDescendant(of: newsListTableView) {
      refreshControl.removeFromSuperview()
    }
    output?.filterNews(keyWord: sender.text ?? "")
  }

  @IBAction private func menuClicked(_ sender: UIButton) {
    output?.menuClicked()
  }

  // MARK: - Functions
  private func refreshControlSettings() {
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
    newsListTableView.addSubview(refreshControl)
  }

  private func tableViewSettings() {
    newsListTableView.register(R.nib.newsTableViewCell)
    newsListTableView.separatorStyle = .none
  }

  @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
    output?.loadDataNextPage()
  }

  private func checkOperatorTableViewForEmpty() {
    notFoundNewsView.isHidden = !newsListTableView.visibleCells.isEmpty
  }

  private func startAnimation() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }

  private func stopAnimation() {
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
    refreshControl.endRefreshing()
  }

  private func showActionSheet() {
    let optionMenu = UIAlertController(title: nil, message: R.string.localizable.chooseOption(), preferredStyle: .actionSheet)
    optionMenu.addAction(UIAlertAction(title: R.string.localizable.actionSheetShowOfflineCollection(), style: .default, handler: clickedShowOfflineCollectionNews))
    optionMenu.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel))
    present(optionMenu, animated: true)
  }

  private func clickedShowOfflineCollectionNews(action: UIAlertAction) {
    output?.showOfflineCollectionNews()
  }
}

// MARK: - UITableViewDataSource
extension NewsView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForCell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return input?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = R.nib.newsTableViewCell.identifier
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    cell.selectionStyle = .none
    let news = input?.provideObject(at: indexPath)
    cell.delegate = self
    cell.updateUI(title: news?.title, newsDescription: news?.descriptionNews, author: news?.author, imageUrl: news?.imageUrl, publishedAt: news?.publishedAt)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension NewsView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let input = input {
      if indexPath.row == input.count - 1 {
        output?.loadDataNextPage()
      }
    }
  }
}

// MARK: - NewsTableViewCellDelegate
extension NewsView: NewsTableViewCellDelegate {
  func showDetailesView(from cell: UITableViewCell) {
    guard let index = newsListTableView.indexPath(for: cell) else { return }
    output?.showDetailes(at: index)
  }
}

// MARK: - NewsControllerOutput
extension NewsView: NewsControllerOutput {
  func displayLoadAnimation() {
    startAnimation()
  }

  func displayAlert(title: String, message: String) {
    showAlert(message: message)
  }

  func displayActionSheet() {
    showActionSheet()
  }

  func updateUI() {
    notFoundNewsView.isHidden = true
    stopAnimation()
    newsListTableView.reloadData()
  }

  func updateUIFilteringEnd() {
    notFoundNewsView.isHidden = true
    refreshControlSettings()
    newsListTableView.reloadData()
  }

  func displayNoResultView() {
    notFoundNewsView.isHidden = false
  }
}
