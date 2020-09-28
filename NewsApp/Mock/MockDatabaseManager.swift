//
//  MockDatabaseManager.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class MockDatabaseManager: DatabaseProtocol {
  func saveData(newsEntities: [NewsEntity], callBack: (Result<Any?, DatabaseDataError>) -> Void) {
    //
  }

  func loadData(callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void) {
    //
  }

  func filterData(keyWord: String, callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void) {
    //
  }

  func removeData(callBack: (Result<Any?, DatabaseDataError>) -> Void) {
    //
  }
}
