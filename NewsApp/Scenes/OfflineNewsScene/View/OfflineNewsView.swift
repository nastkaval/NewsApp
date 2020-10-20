//
//  DetailesModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/06/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol OfflineNewsViewOutput {
  func userInterfaceDidLoad()
  func deleteRowAt(index: IndexPath)
}

protocol OfflineNewsViewInput: AnyObject {
  func provideObject(at index: IndexPath) -> ViewModel
  var count: Int { get }
}

final class OfflineNewsView: UIViewController {
  // MARK: - Property
  private let heightForCell: CGFloat = 280
  weak var input: OfflineNewsViewInput?
  var output: OfflineNewsViewOutput?

  // MARK: - Outlets
  @IBOutlet private weak var listNewsTableView: UITableView!
  @IBOutlet private weak var newsNotFoundView: UIView!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableViewSettings()
    output?.userInterfaceDidLoad()
  }

  // MARK: - Actions
  @IBAction private func backClicked(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  // MARK: - Functions
  private func tableViewSettings() {
    listNewsTableView.register(R.nib.newsTableViewCell)
    listNewsTableView.separatorStyle = .none
  }
  private func showNewsNotFoundView(state: Bool) {
    newsNotFoundView.isHidden = !state
  }
}

// MARK: - UITableViewDataSource
extension OfflineNewsView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return input?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = R.nib.newsTableViewCell.identifier
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    cell.selectionStyle = .none
    let news = input?.provideObject(at: indexPath)
    cell.updateUI(title: news?.title, newsDescription: news?.descriptionNews, author: news?.author, imageUrl: news?.imageUrl, publishedAt: news?.publishedAt)
    return cell
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      output?.deleteRowAt(index: indexPath)
    }
  }
}
// MARK: - UITableViewDelegate
extension OfflineNewsView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForCell
  }
}

// MARK: - OfflineNewsControllerOutput
extension OfflineNewsView: OfflineNewsControllerOutput {
  func updateUI(withNotFoundNewsView: Bool) {
    listNewsTableView.reloadData()
    showNewsNotFoundView(state: withNotFoundNewsView)
  }

  func updateUIWithRemoveCellAt(index: IndexPath, withNotFoundNewsView: Bool) {
    listNewsTableView.deleteRows(at: [index], with: .none)
    showNewsNotFoundView(state: withNotFoundNewsView)
  }

  func displayAlert(message: String) {
    showAlert(message: message)
    showNewsNotFoundView(state: true)
  }
}
