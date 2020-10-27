//
//  NewsView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol NewsViewModel {
  var imageUrl: URL? { get }
  var newsUrl: URL? { get }
  var publishedAt: Date? { get }
  var title: String { get }
  var author: String { get }
  var descriptionNews: String { get }
  var isNewsSaved: Bool { get }
}

protocol NewsControllerDelegate: AnyObject {
  func userInterfaceDidLoad()
  func loadDataCurrentPage()
  func loadDataNextPage()
  func filterNews(keyWord: String)
  func showDetails(at index: IndexPath)
  func menuClicked()
  func showOfflineCollectionNews()
}

protocol NewsViewDataSource: AnyObject {
  func provideObject(at index: IndexPath) -> NewsViewModel
  var count: Int { get }
}

final class NewsView: UIViewController {
  // MARK: - Properties
  private let heightForCell: CGFloat = 280
  private let refreshControl = UIRefreshControl()
  // swiftlint:disable weak_delegate
  var delegate: (NewsControllerDelegate & NewsViewDataSource)?

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
    delegate?.userInterfaceDidLoad()
  }

  // MARK: - Actions
  @IBAction private func editingChangedSearchTextFiled(_ sender: UITextField) {
    delegate?.filterNews(keyWord: sender.text ?? "")
  }

  @IBAction private func menuClicked(_ sender: UIButton) {
    delegate?.menuClicked()
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
    delegate?.loadDataNextPage()
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
    delegate?.showOfflineCollectionNews()
  }
}

// MARK: - UITableViewDataSource
extension NewsView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForCell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return delegate?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = R.nib.newsTableViewCell.identifier
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    cell.selectionStyle = .none
    let news = delegate?.provideObject(at: indexPath)
    cell.delegate = self
    cell.updateUI(title: news?.title, newsDescription: news?.descriptionNews, author: news?.author, imageUrl: news?.imageUrl, publishedAt: news?.publishedAt)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension NewsView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let input = delegate {
      if indexPath.row == input.count - 1 {
        delegate?.loadDataNextPage()
      }
    }
  }
}

// MARK: - NewsTableViewCellDelegate
extension NewsView: NewsTableViewCellDelegate {
  func showDetailsView(from cell: UITableViewCell) {
    guard let index = newsListTableView.indexPath(for: cell) else { return }
    delegate?.showDetails(at: index)
  }
}

// MARK: - NewsControllerOutput
extension NewsView: NewsViewDelegate {
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
    searchTextField.endEditing(true)
    stopAnimation()
    newsListTableView.reloadData()
  }
}
