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
}

protocol OfflineNewsViewInput: class {
  func provideObject(at index: IndexPath) -> ViewModel
  var count: Int { get }
}

final class OfflineNewsView: UIViewController {
  // MARK: - Property
  private let heightForCell: CGFloat = 280
  var output: OfflineNewsViewOutput?
  weak var input: OfflineNewsViewInput?

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
  @IBAction func backClicked(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  // MARK: - Functions
  private func tableViewSettings() {
    listNewsTableView.register(R.nib.newsTableViewCell)
    listNewsTableView.separatorStyle = .none
  }
}

extension OfflineNewsView: UITableViewDelegate, UITableViewDataSource {
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
    cell.updateUI(title: news?.title, newsDescription: news?.descriptionNews, author: news?.author, imageUrl: news?.imageUrl, publishedAt: news?.publishedAt)
    return cell
  }
}

extension OfflineNewsView: OfflineNewsControllerOutput {
  func updateUI() {
    listNewsTableView.reloadData()
  }
  func hideNewsNotFoundView(state: Bool) {
    newsNotFoundView.isHidden = state
  }
}
