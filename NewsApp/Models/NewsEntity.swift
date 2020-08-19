//
//  NewsModel.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class NewsEntity {
    var author : String
    var title : String
    var descriptionNews: String
    var url : String
    var urlToImage: String
    var publishedAt : String //example: "2020-08-19T11:07:00Z"
    var content : String
    var fullDate: Date?
    var day: String?
    
    init(author: String, title: String, descriptionNews: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        self.author = author
        self.title = title
        self.descriptionNews = descriptionNews
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        fullDate = formatter.date(from: publishedAt)
    }
}
