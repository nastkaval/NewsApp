//
//  NewsModel.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import RealmSwift

class NewsEntity: Object {
  @objc dynamic var author: String?
  @objc dynamic var title: String?
  @objc dynamic var descriptionNews: String?
  @objc dynamic var url: String?
  @objc dynamic var urlToImage: String?
  @objc dynamic var publishedAt: String = ""
  @objc dynamic var content: String?
}
