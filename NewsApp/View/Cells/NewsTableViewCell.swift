//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

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
}
