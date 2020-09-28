//
//  ParseHelper.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/25/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class ParseHelper {
  func parseJson(json: [[String: Any]], callBack: @escaping (Result<[NewsEntity], ServerDataError>) -> Void) {
    var newsEntities: [NewsEntity] = []
    for dict in json {
      var dictString: String?

      do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        dictString = String(bytes: jsonData, encoding: String.Encoding.utf8)
      } catch {
        print("error")
      }

      guard let json: String = dictString,
      let jsonData: Data = json.data(using: .utf8)
      else {
        return callBack(.failure(.parseError))
      }

      do {
        let news = try JSONDecoder().decode(NewsEntity.self, from: jsonData)
        newsEntities.append(news)
      } catch {
        print("error")
      }
  }
    return callBack(.success(newsEntities))
  }
}
