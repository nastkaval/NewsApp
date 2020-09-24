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

enum ServerDataError: LocalizedError {
  case limitNewsError
  case serverError
  case parseError

  var description: String {
    switch self {
    case .limitNewsError:
      return "You have requested too many results. Developer accounts are limited to a max of 100 results. You are trying to request results 100 to 125. Please upgrade to a paid plan if you need more results."
    case .serverError:
      return "The call failed."
    case .parseError:
      return "Parsing failed."
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

protocol ApiProvider {
  func callApi(session: SessionData, callBack: @escaping (([NewsEntity]?, ServerDataError?) -> Void))
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

  func getNews(session: SessionData, success: @escaping ([NewsEntity]) -> Void, failed: @escaping(ServerDataError) -> Void) {
    var request = "\(Constants.host)" + "q=apple&sortBy=publishedAt&" + "from=\(session.from)&"
    request.append("page=\(session.currentPage)&")
    request.append("pageSize=\(session.pageSize)&")
    request.append("apiKey=\(Constants.apiKey)")
    // swiftlint:disable force_unwrapping
    let url = URL(string: request)!
    print("url == \(url)")
    self.get(
      url: url,
      parameters: nil,
      headers: nil,
      successHandler: { [weak self] response in
        if response.response?.statusCode == 426 {
          failed(ServerDataError.limitNewsError)
          return
        }
        if let JSON = response.value as? [String: Any] {
          if let json = JSON["articles"] as? [[String: Any]] {
            if let newsEntities = self?.parseJson(json: json) {
              success(newsEntities)
            } else {
              failed(ServerDataError.parseError)
            }
          }
        }
      }, fail: { _ in
        failed(ServerDataError.serverError)
      })
  }

  private func parseJson(json: [[String: Any]]) -> [NewsEntity]? {
      var newsEntities: [NewsEntity] = []
      for dict in json {
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
          return nil
        }

        do {
          let news = try JSONDecoder().decode(NewsEntity.self, from: jsonData)
          newsEntities.append(news)
        } catch let error {
          print(error)
        }
      }
      return newsEntities
  }
}

extension ApiProvider {
  func callApi(session: SessionData, callBack: @escaping (([NewsEntity]?, ServerDataError?) -> Void)) {
    ApiManager.shared.getNews(session: session) { (result) in
      callBack(result, nil)
    } failed: { (error) in
      callBack(nil, error)
    }
  }
}
