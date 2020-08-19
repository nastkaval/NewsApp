//
//  ApiManager.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager {
    
    static var shared = ApiManager()
    let host = "http://newsapi.org/v2/everything?"
    
    private func get(url: URL, parameters: [String: Any]?, headers: HTTPHeaders?, successHandler: @escaping(AFDataResponse<Any>) -> (), fail: @escaping(Error) -> ()) -> Void {
        
        let getApiQueue = DispatchQueue(label: "apiGetRequest", qos: .userInitiated, attributes: .concurrent)
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON(queue: getApiQueue, options: .allowFragments, completionHandler: { (response:AFDataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                DispatchQueue.main.async {
                    successHandler(response)
                }
            case .failure(_):
                print(response.error.debugDescription)
                if let error = response.error {
                    fail(error)
                }
                break
            }
        })
    }
    
    func getNews(from: String, to: String?, success: @escaping(_ news: [NewsEntity]) -> (), failed: @escaping(Error) -> ()) {
        var request = "\(host)" + "q=apple&sortBy=publishedAt&" + "from=\(from)&"
        
        if to != nil {
            request.append("to=\(to!)&")
        }
        request.append("apiKey=8d22efe4f9f04f1ebb9b841c51e54904")
        let url = URL (string: request)!
        
        print("url == \(url)")
        self.get(url: url, parameters: nil, headers: nil, successHandler: { (response) in
            if let JSON = response.value as? [String: Any] {
                var newsEntities : [NewsEntity] = []
                if let newsJSON = JSON["articles"] as? [[String: Any]] {
                    for dict in newsJSON {
                        let author = dict["author"] as? String ?? ""
                        let title = dict["title"] as? String ?? ""
                        let descriptionNews = dict["description"] as? String ?? ""
                        let url = dict["url"] as? String ?? ""
                        let urlToImage = dict["urlToImage"] as? String ?? ""
                        let publishedAt = dict["publishedAt"] as? String ?? ""
                        let content = dict["content"] as? String ?? ""
                        
                        let newsEntity = NewsEntity(author: author, title: title, descriptionNews: descriptionNews, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
                        newsEntities.append(newsEntity)
                    }
                    success(newsEntities)
                }
            }
        }) { (error) in
            failed(error)
        }
    }
}
