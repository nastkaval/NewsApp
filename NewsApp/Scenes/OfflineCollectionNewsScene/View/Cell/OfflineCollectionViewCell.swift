//
//  OfflineCollectionViewCell.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

final class OfflineCollectionViewCell: SwipeableCollectionViewCell {
  // MARK: - Properties
  private enum TimeDateFormatters {
    static let hoursMinutesDateFormatter: DateFormatter = {
      var dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      return dateFormatter
    }()
  }
  // MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    setupSubviews()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageNews.image = R.image.imageImagePlaceholder()
  }

  // MARK: - Outlets
  @IBOutlet weak var container: UIView!
  @IBOutlet private weak var imageNews: UIImageView!
  @IBOutlet private weak var titleNews: UILabel!
  @IBOutlet private weak var descriptionText: UILabel!
  @IBOutlet private weak var postTimeNews: UILabel!
  @IBOutlet private weak var authorPostNews: UILabel!
  @IBOutlet private weak var showMoreButton: UIButton!

  // MARK: - Functions
  func updateUI(title: String?, newsDescription: String?, author: String?, imageUrl: URL?, publishedAt: Date?) {
    titleNews.text = title
    descriptionText.text = newsDescription
    authorPostNews.text = author
    if let url = imageUrl {
      imageNews.af.setImage(withURL: url)
    }
    if let date = publishedAt {
      postTimeNews.text = TimeDateFormatters.hoursMinutesDateFormatter.string(from: date)
    }
  }

  private func setupSubviews() {
    visibleContainerView.addSubview(container)
    container.pinEdgesToSuperView()
  }
}
