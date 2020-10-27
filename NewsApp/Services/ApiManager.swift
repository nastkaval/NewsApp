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
  case clientError
  case unknownError

  var localizableDescription: String {
    switch self {
    case .limitNewsError:
      return R.string.localizable.errorMessagesLimitNews()
    case .serverError:
      return R.string.localizable.errorMessagesServerError()
    case .parseError:
      return R.string.localizable.errorMessagesParseError()
    case .clientError:
      return R.string.localizable.errorMessagesServerError()
    case .unknownError:
      return R.string.localizable.errorMessagesServerError()
    }
  }
}

enum ServerDateFormatterConverter {
  static let serverDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
  }()
}

protocol ApiManagerProtocol {
  func callApi(session: SessionData, callBack: @escaping (Result<[News], ServerDataError>) -> Void)
}

final class ApiManager {
  private let parser = ParseHelper()

  private func get(url: URL, completionHandler: @escaping (Result<AFDataResponse<Data>, AFError>) -> Void) {
    let getApiQueue = DispatchQueue(label: "apiGetRequest", qos: .userInteractive)
    AF.request(url, method: .get)
      .responseData(queue: getApiQueue) { response in
        switch response.result {
        case .success:
          DispatchQueue.main.async {
            completionHandler(.success(response))
          }
        case .failure:
          print(response.error.debugDescription)
          if let error = response.error {
            completionHandler(.failure(error))
          }
        }
      }
  }

  private func getNews(session: SessionData, completionHandler: @escaping (Result<[News], ServerDataError>) -> Void) {
    let urlRequest = getUrl(session: session)
    guard let url = urlRequest else { return }
    get(url: url) { [weak self] result in
      switch result {
      case .success(let response):
        if response.response?.statusCode == 426 {
          completionHandler(.failure(.limitNewsError))
          return
        }
        guard let data = response.value else { return }
        self?.parser.parseJson(json: data) { result in
          switch result {
          case .success(let newsEntities):
            completionHandler(.success(newsEntities))
          case .failure(let error):
            completionHandler(.failure(error))
          }
        }
      case .failure(let afError):
        guard let error = self?.handleError(error: afError) else { return }
        completionHandler(.failure(error))
      }
    }
  }

  private func getUrl(session: SessionData) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = Constants.scheme
    urlComponents.host = Constants.host
    urlComponents.path = Constants.path
    urlComponents.queryItems = [
      URLQueryItem(name: "q", value: "apple"),
      URLQueryItem(name: "sortBy", value: "publishedAt"),
      URLQueryItem(name: "from", value: session.from),
      URLQueryItem(name: "page", value: "\(session.page)"),
      URLQueryItem(name: "pageSize", value: "15"),
      URLQueryItem(name: "apiKey", value: Constants.apiKey)
    ]

    return urlComponents.url
  }

  private func handleError(error: AFError) -> ServerDataError {
    guard let errorCode = error.responseCode else { return .unknownError }
    switch errorCode {
    case 500...526:
      return .serverError
    case 400...499:
      return .clientError
    default:
      return .unknownError
    }
  }
}

// MARK: - ApiManagerProtocol
extension ApiManager: ApiManagerProtocol {
  func callApi(session: SessionData, callBack: @escaping (Result<[News], ServerDataError>) -> Void) {
    getNews(session: session) { result in
      callBack(result)
    }
  }
}
