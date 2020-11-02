//
//  DetailsView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

final class DetailsView: UIViewController {
  // MARK: - Properties
  var controller: DetailsControllable?

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
    controller?.didLoadView()
  }

  // MARK: - Functions
  @IBAction private func readMoreClicked(_ sender: UIButton) {
    controller?.didTapOpenUrl()
  }

  @IBAction private func closeViewClicked(_ sender: UIButton) {
    controller?.didTapClose()
  }
}

// MARK: - DetailsViewable
extension DetailsView: DetailsViewable {
  func showAlert(title: String, message: String) {
    showAlert(message: message)
  }

  func updateUI(with data: NewsViewModel) {
    let news = data
    if let url = news.imageUrl {
      imageNews.af.setImage(withURL: url)
    }
    titleLabel.text = news.title
    authorLabel.text = news.author
    if let date = news.publishedAt {
      dateLabel.text = DayDateFormattersConverter.dayTimeDateFormatter.string(from: date)
    }
    descriptionLabel.text = news.descriptionText
    savedNewsCheck.isSelected = news.isSaved
  }
}
