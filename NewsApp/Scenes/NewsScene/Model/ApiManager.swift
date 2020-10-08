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
      return R.string.localizable.errorMessagesLimitNews()
    case .serverError:
      return R.string.localizable.errorMessagesServerError()
    case .parseError:
      return R.string.localizable.errorMessagesParseError()
    }
  }
}

enum ServerDateFormatterConverter { //https://realm.github.io/SwiftLint/convenience_type.html
  static let serverDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
  }()
}

protocol ApiManagerProtocol {
  func callApi(session: SessionData, callBack: @escaping (Result<[NewsScene.NewsViewModel], ServerDataError>) -> Void)
}

final class ApiManager {
  private let parser = ParseHelper()

  static let shared = ApiManager()

  private init() { }

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

  private func getNews(session: SessionData, completionHandler: @escaping (Result<[NewsScene.NewsViewModel], ServerDataError>) -> Void) {
    var request = "\(Constants.host)" + "q=apple&sortBy=publishedAt&" + "from=\(session.from)&"
    request.append("page=\(session.page)&")
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
          completionHandler(.failure(.limitNewsError))
          return
        }
        if let JSON = response.value as? [String: Any] {
          if let json = JSON["articles"] as? [[String: Any]] {
            self?.parser.parseJson(json: json) { result in
              switch result {
              case .success(let newsEntities):
                completionHandler(.success(newsEntities))
              case .failure(let error):
                completionHandler(.failure(error))
              }
            }
            }
          }
      }, fail: { _ in
        completionHandler(.failure(.serverError))
      })
  }
}

extension ApiManager: ApiManagerProtocol {
  func callApi(session: SessionData, callBack: @escaping (Result<[NewsScene.NewsViewModel], ServerDataError>) -> Void) {
    getNews(session: session) { result in
      callBack(result)
    }
  }
}
