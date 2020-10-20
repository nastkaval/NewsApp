//
//  ParseHelper.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/25/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class ParseHelper {
  func parseJson(json: [[String: Any]], callBack: @escaping (Result<[NewsViewModel], ServerDataError>) -> Void) {
    var newsEntities: [NewsViewModel] = []
    for dict in json {
      var dictString: String?
      do {
        let jsonDataSerialize = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        dictString = String(bytes: jsonDataSerialize, encoding: String.Encoding.utf8)
        guard let json: String = dictString, let jsonData: Data = json.data(using: .utf8) else {
          return callBack(.failure(.parseError))
        }
        let news = try JSONDecoder().decode(NewsViewModel.self, from: jsonData)
        newsEntities.append(news)
      } catch {
        print("decode error: invalid data from server")
      }
    }
    return callBack(.success(newsEntities))
  }
}
