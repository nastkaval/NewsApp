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
  @objc dynamic var descriptionNews: String = ""
  @objc dynamic var urlNewsStr: String = ""
  @objc dynamic var urlToImageStr: String = ""
  @objc dynamic var publishedAtStr: String = ""
  @objc dynamic var content: String = ""

  convenience init(author: String, title: String, descriptionNews: String, urlNewsStr: String, urlToImageStr: String, publishedAtStr: String, content: String) {
    self.init()
    self.author = author
    self.title = title
    self.descriptionNews = descriptionNews
    self.urlNewsStr = urlNewsStr
    self.urlToImageStr = urlToImageStr
    self.publishedAtStr = publishedAtStr
    self.content = content
  }
}

//class NewsScene {
  class NewsViewModel: Decodable {
    var author: String
    var title: String
    var descriptionNews: String
    var content: String
    var urlNewsStr: String
    var urlToImageStr: String
    var publishedAtStr: String
    var publishedAtDate: Date?
    var urlNews: URL?
    var urlToImage: URL?
    var isNewsSaved: Bool = false

    enum CodingKeys: String, CodingKey {
      case author
      case title
      case description
      case url
      case urlToImage
      case publishedAt
      case content
    }

    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      author = try container.decode(String.self, forKey: .author)
      title = try container.decode(String.self, forKey: .title)
      descriptionNews = try container.decode(String.self, forKey: .description)
      content = try container.decode(String.self, forKey: .content)
      urlNewsStr = try container.decode(String.self, forKey: .url)
      urlNews = URL(string: urlNewsStr)
      urlToImageStr = try container.decode(String.self, forKey: .urlToImage)
      urlToImage = URL(string: urlToImageStr)
      publishedAtStr = try container.decode(String.self, forKey: .publishedAt)
      publishedAtDate = ServerDateFormatterConverter.serverDateFormatter.date(from: publishedAtStr)
    }

    init(author: String, title: String, descriptionNews: String, content: String, urlNewsStr: String, urlToImageStr: String, publishedAtStr: String) {
      self.author = author
      self.title = title
      self.descriptionNews = descriptionNews
      self.content = content
      self.urlNewsStr = urlNewsStr
      self.urlToImageStr = urlToImageStr
      self.publishedAtStr = publishedAtStr
      self.urlNews = URL(string: urlNewsStr)
      self.urlToImage = URL(string: urlToImageStr)
      self.publishedAtDate = ServerDateFormatterConverter.serverDateFormatter.date(from: publishedAtStr)
    }
  }
//}
