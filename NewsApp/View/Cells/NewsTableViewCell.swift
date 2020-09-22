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
  private struct TimeDateFormatters {
    static let hoursMinutesDateFormatter: DateFormatter = {
      var dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      return dateFormatter
    }()
  }

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

  func updateUI(title: String, newsDescription: String, author: String, imageUrlStr: String, publishedAt: Date) {
    titleNews.text = title
    descriptionNews.text = newsDescription
    authorPostNews.text = author
    showMoreButton.isHidden = !descriptionNews.isTruncated
    if let escapedString = imageUrlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
      if let url = URL(string: escapedString) {
        imageNews.af.setImage(withURL: url)
      }
    }
    postTimeNews.text = TimeDateFormatters.hoursMinutesDateFormatter.string(from: publishedAt)
  }
}
