//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsTableViewCell: UITableViewCell {
  // MARK: - Struct TimeDateFormatters
  private enum TimeDateFormatters { //https://realm.github.io/SwiftLint/convenience_type.html
    static let hoursMinutesDateFormatter: DateFormatter = {
      var dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      return dateFormatter
    }()
  }
  // MARK: - Properties
  typealias IsClicked = (Bool) -> Void
  var showDetailesView: IsClicked?

  // MARK: - Outlets
  @IBOutlet private weak var imageNews: UIImageView!
  @IBOutlet private weak var titleNews: UILabel!
  @IBOutlet private weak var descriptionNews: UILabel!
  @IBOutlet private weak var postTimeNews: UILabel!
  @IBOutlet private weak var authorPostNews: UILabel!
  @IBOutlet private weak var showMoreButton: UIButton!

  // MARK: - LifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageNews.image = R.image.imageImagePlaceholder()
  }

  @IBAction private func showMoreButtonClicked(_ sender: UIButton) {
    showDetailesView?(true)
  }

  func updateUI(title: String, newsDescription: String, author: String, imageUrl: URL?, publishedAt: Date) {
    titleNews.text = title
    descriptionNews.text = newsDescription
    authorPostNews.text = author
//    showMoreButton.isHidden = !descriptionNews.isTruncated
    if let url = imageUrl {
    imageNews.af.setImage(withURL: url)
    }
    postTimeNews.text = TimeDateFormatters.hoursMinutesDateFormatter.string(from: publishedAt)
  }
}
