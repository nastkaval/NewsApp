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

class ApiManager {
  static var shared = ApiManager()
  let host = "http://newsapi.org/v2/everything?"

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

  func getNews(success: @escaping () -> Void, failed: @escaping(NSError) -> Void) {
    var request = "\(host)" + "q=apple&sortBy=publishedAt&" + "from=\(Session.from)&"
    request.append("page=\(Session.currentPage)&")
    request.append("pageSize=15&")
    request.append("apiKey=8d22efe4f9f04f1ebb9b841c51e54904")
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
        Session.nextPage = 0
        failed(error)
      }

      if let JSON = response.value as? [String: Any] {
        if let newsJSON = JSON["articles"] as? [[String: Any]] {
          print("news count in response == \(newsJSON.count)")
          for dict in newsJSON {
            let newsEntity = NewsEntity()
            newsEntity.author = dict["author"] as? String ?? ""
            newsEntity.title = dict["title"] as? String ?? ""
            newsEntity.descriptionNews = dict["description"] as? String ?? ""
            newsEntity.url = dict["url"] as? String ?? ""
            newsEntity.urlToImage = dict["urlToImage"] as? String ?? ""
            newsEntity.publishedAt = dict["publishedAt"] as? String ?? ""
            newsEntity.content = dict["content"] as? String ?? ""
            // swiftlint:disable force_try
            let realm = try! Realm()
            // swiftlint:disable force_try
            try! realm.write {
              realm.add(newsEntity)
            }
          }
          Session.nextPage += 1
          print("nextPage is \(Session.nextPage)")
          success() 
        }
      }
      }, fail: { error in
      Session.nextPage = 0
      failed(error as NSError)
      })
  }
}
