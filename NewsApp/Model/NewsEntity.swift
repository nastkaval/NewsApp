//
//  NewsModel.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import RealmSwift

class NewsEntity: Object, Decodable {
  @objc dynamic var author: String = ""
  @objc dynamic var title: String = ""
  @objc dynamic var descriptionNews: String = ""
  @objc dynamic var urlNewsStr: String = ""
  @objc dynamic var urlToImageStr: String = ""
  @objc dynamic var publishedAtStr: String = ""
  @objc dynamic var content: String = ""

  enum CodingKeys: String, CodingKey {
    case author
    case title
    case description
    case url
    case urlToImage
    case publishedAt
    case content
  }

  convenience required init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.author = try container.decode(String.self, forKey: .author)
    self.title = try container.decode(String.self, forKey: .title)
    self.descriptionNews = try container.decode(String.self, forKey: .description)
    self.urlNewsStr = try container.decode(String.self, forKey: .url)
    self.urlToImageStr = try container.decode(String.self, forKey: .urlToImage)
    self.publishedAtStr = try container.decode(String.self, forKey: .publishedAt)
    self.content = try container.decode(String.self, forKey: .content)
  }
}
