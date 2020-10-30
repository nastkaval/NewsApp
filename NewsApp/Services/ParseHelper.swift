//
//  ParseHelper.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/25/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class ParseHelper {
  func parseJson(json: Data, callBack: @escaping (Result<[News], ServerDataError>) -> Void) {
    var newsEntities: [News] = []
    do {
      let news = try JSONDecoder().decode(NewsServerModel.self, from: json)
      newsEntities = news.articles.map { item -> News in
        News(author: item.author ?? "", title: item.title ?? "", descriptionText: item.articlesDescription ?? "", content: item.content ?? "", urlNewsStr: item.url, urlToImageStr: item.urlToImage ?? "", publishedAtStr: item.publishedAt)
      }
    } catch {
      print("decode error: invalid data from server")
      return callBack(.failure(.parseError))
    }
    return callBack(.success(newsEntities))
  }
}
