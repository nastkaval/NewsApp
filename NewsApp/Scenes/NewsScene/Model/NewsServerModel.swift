//
//  NewsServerModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/22/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

struct NewsServerModel: Decodable {
  let status: String
  let totalResults: Int
  let articles: [Article]
}

struct Article: Decodable {
  let author, title, articlesDescription: String?
  let url: String
  let urlToImage: String?
  let publishedAt: String
  let content: String?

  enum CodingKeys: String, CodingKey {
    case author, title
    case articlesDescription = "description"
    case url, urlToImage, publishedAt, content
  }
}
