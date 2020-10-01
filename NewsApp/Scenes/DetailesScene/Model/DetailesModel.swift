//
//  DetailesModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

final class DetailesModel {
  private var news: ViewModel

  init(news: ViewModel) {
    self.news = news
  }
}

extension DetailesModel {
  func object() -> ViewModel {
    return news
  }
}
