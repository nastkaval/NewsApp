//
//  OfflineCollectionNewsView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/06/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol OfflineCollectionNewsControllerDelegate: AnyObject {
  func userInterfaceDidLoad()
  func deleteRowAt(index: IndexPath)
  func closeView()
}

protocol OfflineCollectionNewsViewDataSource: AnyObject {
  func provideObject(at index: IndexPath) -> NewsViewModel
  var count: Int { get }
}

final class OfflineCollectionNewsView: UIViewController {
  // MARK: - Property
  private let heightForCell: CGFloat = 280
  // swiftlint:disable weak_delegate
  var delegate: (OfflineCollectionNewsViewDataSource & OfflineCollectionNewsControllerDelegate)?

  // MARK: - Outlets
  @IBOutlet private weak var listNewsCollectionView: UICollectionView!
  @IBOutlet weak var newsNotFoundView: UIView!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionViewSettings()
    delegate?.userInterfaceDidLoad()
  }

  // MARK: - Actions
  @IBAction private func backClicked(_ sender: UIButton) {
    delegate?.closeView()
  }

  // MARK: - Functions
  private func collectionViewSettings() {
    listNewsCollectionView.register(UINib(nibName: R.nib.offlineCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.nib.offlineCollectionViewCell.identifier)
  }

  private func showNewsNotFoundView(state: Bool) {
    newsNotFoundView.isHidden = !state
  }
}

// MARK: - UICollectionViewDataSource
extension OfflineCollectionNewsView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return delegate?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellIdentifier = R.nib.offlineCollectionViewCell.identifier
    guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? OfflineCollectionViewCell else {
    return UICollectionViewCell()
    }
    let news = delegate?.provideObject(at: indexPath)
    item.updateUI(title: news?.title, newsDescription: news?.descriptionText, author: news?.author, imageUrl: news?.imageUrl, publishedAt: news?.publishedAtTime)
    item.delegate = self
    return item
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OfflineCollectionNewsView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: heightForCell)
  }
}

// MARK: - OfflineCollectionViewCellDelegate
extension OfflineCollectionNewsView: SwipeableCollectionViewCellDelegate {
  func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
    guard let index = listNewsCollectionView.indexPath(for: cell) else { return }
    delegate?.deleteRowAt(index: index)
  }
}

// MARK: - OfflineCollectionNewsControllerOutput
extension OfflineCollectionNewsView: OfflineCollectionNewsViewDelegate {
  func updateUI(withNotFoundNewsView: Bool) {
    listNewsCollectionView.reloadData()
    showNewsNotFoundView(state: withNotFoundNewsView)
  }

  func updateUIWithRemoveCellAt(index: IndexPath, withNotFoundNewsView: Bool) {
    listNewsCollectionView.deleteItems(at: [index])
    showNewsNotFoundView(state: withNotFoundNewsView)
  }

  func displayAlert(message: String) {
    showAlert(message: message)
    showNewsNotFoundView(state: true)
  }
}
