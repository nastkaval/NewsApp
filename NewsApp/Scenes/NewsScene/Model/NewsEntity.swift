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
  @objc dynamic var author: String = ""
  @objc dynamic var title: String = ""
  @objc dynamic var descriptionText: String = ""
  @objc dynamic var urlNewsStr: String = ""
  @objc dynamic var urlToImageStr: String = ""
  @objc dynamic var publishedAtStr: String = ""
  @objc dynamic var content: String = ""

  convenience init(author: String, title: String, descriptionText: String, urlNewsStr: String, urlToImageStr: String, publishedAtStr: String, content: String) {
    self.init()
    self.author = author
    self.title = title
    self.descriptionText = descriptionText
    self.urlNewsStr = urlNewsStr
    self.urlToImageStr = urlToImageStr
    self.publishedAtStr = publishedAtStr
    self.content = content
  }
}
