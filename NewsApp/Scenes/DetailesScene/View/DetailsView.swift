//
//  DetailsView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol DetailsControllerDelegate: AnyObject {
  func userInterfaceDidLoad()
  func openNewsInExternalResource()
  func closeView()
}

protocol DetailsViewInput: AnyObject {
  var object: NewsViewModel { get }
}

final class DetailsView: UIViewController {
  // MARK: - Properties
  // swiftlint:disable weak_delegate
  var delegate: (DetailsControllerDelegate & DetailsViewInput)?

  // MARK: - Outlets
  @IBOutlet private weak var imageNews: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var authorLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var savedNewsCheck: UIButton!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate?.userInterfaceDidLoad()
  }

  // MARK: - Functions
  @IBAction private func readMoreClicked(_ sender: UIButton) {
    delegate?.openNewsInExternalResource()
  }

  @IBAction private func closeViewClicked(_ sender: UIButton) {
    delegate?.closeView()
  }
}

// MARK: - DetailsControllerOutput
extension DetailsView: DetailsViewDelegate {
  func displayAlert(title: String, message: String) {
    showAlert(message: message)
  }

  func dismissView() {
    dismiss(animated: true)
  }

  func updateUI() {
    let news = delegate?.object
    if let url = news?.imageUrl {
      imageNews.af.setImage(withURL: url)
    }
    titleLabel.text = news?.title
    authorLabel.text = news?.author
    if let date = news?.publishedAt {
    dateLabel.text = DayDateFormattersConverter.dayTimeDateFormatter.string(from: date)
    }
    descriptionLabel.text = news?.descriptionNews
    if let saved = news?.isNewsSaved {
    savedNewsCheck.isSelected = saved
    }
  }
}
