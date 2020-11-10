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

  // MARK: - Outlets
  @IBOutlet private weak var imageNews: UIImageView!
  @IBOutlet private weak var titleNews: UILabel!
  @IBOutlet private weak var descriptionText: UILabel!
  @IBOutlet private weak var postTimeNews: UILabel!
  @IBOutlet private weak var authorPostNews: UILabel!
  @IBOutlet private weak var showMoreButton: UIButton!

  // MARK: - Properties
  weak var delegate: NewsTableViewCellDelegate?

  // MARK: - LifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()
    imageNews.image = R.image.imageImagePlaceholder()
  }

  @IBAction private func showMoreButtonClicked(_ sender: UIButton) {
    delegate?.showDetailsView(from: self)
  }

  // MARK: - Functions
  func updateUI(title: String?, newsDescription: String?, author: String?, imageUrl: URL?, publishedAt: String?) {
    titleNews.text = title
    descriptionText.text = newsDescription
    authorPostNews.text = author
    if let url = imageUrl {
    imageNews.af.setImage(withURL: url)
    }
    if let date = publishedAt {
      postTimeNews.text = date
    }
  }
}
