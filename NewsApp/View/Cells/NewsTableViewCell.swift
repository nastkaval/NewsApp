//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

struct TimeDateFormatters {
static let hoursMinutesDateFormatter: DateFormatter = {
      var dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      return dateFormatter
    }()
}

class NewsTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var imageNews: UIImageView!
  @IBOutlet weak var titleNews: UILabel!
  @IBOutlet weak var descriptionNews: UILabel!
  @IBOutlet weak var postTimeNews: UILabel!
  @IBOutlet weak var authorPostNews: UILabel!
  @IBOutlet weak var showMoreButton: UIButton!

  // MARK: - LifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageNews.image = R.image.imageImagePlaceholder()
  }

  func updateUI(data: NewsEntity) {
    titleNews.text = data.title
    descriptionNews.text = data.descriptionNews
    authorPostNews.text = data.author
    showMoreButton.isHidden = !descriptionNews.isTruncated
    // swiftlint:disable force_unwrapping
    if let escapedString = data.urlToImageStr!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
      if let url = URL(string: escapedString) {
        imageNews.af.setImage(withURL: url)
      }
    }
    postTimeNews.text = TimeDateFormatters.hoursMinutesDateFormatter.string(from: data.publishedAt ?? Date())
  }
}
