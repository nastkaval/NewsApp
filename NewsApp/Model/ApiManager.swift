//
//  ApiManager.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

enum DataError: LocalizedError {
  case limitNewsError
  case serverError

  var description: String {
    switch self {
    case .limitNewsError:
      return "You have requested too many results. Developer accounts are limited to a max of 100 results. You are trying to request results 100 to 125. Please upgrade to a paid plan if you need more results."
    case .serverError:
      return "The call failed."
    }
  }
}

struct ServerDateFormatterConverter {
  static let serverDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
  }()
}

class ApiManager {
  static let shared = ApiManager()

  private func get(url: URL, parameters: [String: Any]?, headers: HTTPHeaders?, successHandler: @escaping(AFDataResponse<Any>) -> Void, fail: @escaping(Error) -> Void) {
    let getApiQueue = DispatchQueue(label: "apiGetRequest", qos: .userInitiated, attributes: .concurrent)
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
      .responseJSON(queue: getApiQueue, options: .allowFragments) { response in
        switch response.result {
        case .success:
          DispatchQueue.main.async {
            successHandler(response)
          }
        case .failure:
          print(response.error.debugDescription)
          if let error = response.error {
            fail(error)
          }
        }
      }
  }

  func getNews(from: String, currentPage: Int, pageSize: Int, success: @escaping ([NewsEntity]) -> Void, failed: @escaping(DataError) -> Void) {
    var request = "\(Constants.host)" + "q=apple&sortBy=publishedAt&" + "from=\(from)&"
    request.append("page=\(currentPage)&")
    request.append("pageSize=\(pageSize)&")
    request.append("apiKey=\(Constants.apiKey)")
    // swiftlint:disable force_unwrapping
    let url = URL(string: request)!
    print("url == \(url)")
    self.get(
      url: url,
      parameters: nil,
      headers: nil,
      successHandler: { response in
        if response.response?.statusCode == 426 {
          failed(DataError.limitNewsError)
        }
        if let JSON = response.value as? [String: Any] {
          if let newsJSON = JSON["articles"] as? [[String: Any]] {
            var newsEntities: [NewsEntity] = []
            for dict in newsJSON {
              var dictString: String?

              do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                dictString = String(bytes: jsonData, encoding: String.Encoding.utf8)
              } catch let error {
                print(error)
              }

              guard let json: String = dictString,
              let jsonData: Data = json.data(using: .utf8)
              else {
                print("[JSONSerialization DEBUG] Could not convert JSON string to data")
                return
              }

              do {
                let news = try JSONDecoder().decode(NewsEntity.self, from: jsonData)
                newsEntities.append(news)
              } catch let error {
                print(error)
              }
            }
            success(newsEntities)
          }
        }
      }, fail: { _ in
        failed(DataError.serverError)
      })
  }
}
