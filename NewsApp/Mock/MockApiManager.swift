//
//  MockApiManager.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class MockApiManager: ApiManagerProtocol {
  func callApi(session: SessionData, callBack: @escaping (Result<[NewsEntity], ServerDataError>) -> Void) {
    //
  }
}
