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

struct ServerDateFormatterConverter {
  static let serverDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
  }()
}

class ApiManager {
  static var shared = ApiManager()

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

  func getNews(from: String, currentPage: Int, success: @escaping () -> Void, failed: @escaping(NSError) -> Void) {
    var request = "\(Constants.host)" + "q=apple&sortBy=publishedAt&" + "from=\(from)&"
    request.append("page=\(currentPage)&")
    request.append("pageSize=\(Constants.pageSize)&")
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
        let error = NSError(domain: "", code: 426, userInfo: nil)
        failed(error)
      }
      if let JSON = response.value as? [String: Any] {
        if let newsJSON = JSON["articles"] as? [[String: Any]] {
          DatabaseService.saveData(newsJSON: newsJSON) {
            success()
          }
        }
      }
      }, fail: { error in
      failed(error as NSError)
      })
  }
}
