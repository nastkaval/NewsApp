//
//  NewsScreen.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/27/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol NewsControllable: AnyObject {
  func didUserInterfaceLoad()
  func didMenuClick()
  func didOfflineNewsButtonClick()
  func didDetailesNewsButtonClick(at index: IndexPath)
  func didFilteringStart(keyWord: String)
  func didScrollTableView()
  func didSwipeRefresh()
}

final class NewsView: UIViewController {
  // MARK: - Properties
  private let heightForCell: CGFloat = 280
  private let refreshControl = UIRefreshControl()
  private var dataSource: [NewsViewModel]?
  // swiftlint:disable weak_delegate
  var delegate: NewsControllable?

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
    delegate?.didUserInterfaceLoad()
  }

  // MARK: - Actions
  @IBAction private func editingChangedSearchTextFiled(_ sender: UITextField) {
    delegate?.didFilteringStart(keyWord: sender.text ?? "")
  }

  @IBAction private func menuClicked(_ sender: UIButton) {
    delegate?.didMenuClick()
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
    delegate?.didSwipeRefresh()
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

  private func clickedShowOfflineCollectionNews(action: UIAlertAction) {
    delegate?.didOfflineNewsButtonClick()
  }
}

// MARK: - UITableViewDataSource
extension NewsView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForCell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = R.nib.newsTableViewCell.identifier
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    cell.selectionStyle = .none
    let news = dataSource?[indexPath.row]
    cell.delegate = self
    cell.updateUI(title: news?.title, newsDescription: news?.descriptionNews, author: news?.author, imageUrl: news?.imageUrl, publishedAt: news?.publishedAt)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension NewsView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let newsArray = dataSource {
      if indexPath.row == newsArray.count - 1 {
        delegate?.didScrollTableView()
      }
    }
  }
}

// MARK: - NewsTableViewCellDelegate
extension NewsView: NewsTableViewCellDelegate {
  func showDetailsView(from cell: UITableViewCell) {
    guard let index = newsListTableView.indexPath(for: cell) else { return }
    delegate?.didDetailesNewsButtonClick(at: index)
  }
}

extension NewsView: NewsViewable {
  func updateUI(with data: [NewsViewModel]) {
    dataSource = data
    notFoundNewsView.isHidden = !data.isEmpty
    stopAnimation()
    newsListTableView.reloadData()
  }

  func showAlert(title: String, message: String) {
    showAlert(message: message)
  }

  func showAnimation() {
    startAnimation()
  }

  func showActionSheet() {
    let optionMenu = UIAlertController(title: nil, message: R.string.localizable.chooseOption(), preferredStyle: .actionSheet)
    optionMenu.addAction(UIAlertAction(title: R.string.localizable.actionSheetShowOfflineCollection(), style: .default, handler: clickedShowOfflineCollectionNews))
    optionMenu.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel))
    present(optionMenu, animated: true)
  }
}
