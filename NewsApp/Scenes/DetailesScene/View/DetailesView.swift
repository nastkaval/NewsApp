//
//  DetailesView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol DetailesViewOutput {
  func userInterfaceDidLoad()
  func openNewsInResource()
  func closeView()
}

protocol DetailesViewInput: class {
  var object: ViewModel { get }
}

final class DetailesView: UIViewController {
  // MARK: - Properties
  // swiftlint:disable implicitly_unwrapped_optional
  var output: DetailesViewOutput!
  weak var input: DetailesViewInput?

  // MARK: - Outlets
  @IBOutlet private weak var imageNews: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var authorLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    output?.userInterfaceDidLoad()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("viewWillAppear")
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("viewWillDisappear")
  }
  // MARK: - Functions
  @IBAction func readMoreClicked(_ sender: UIButton) {
    output?.openNewsInResource()
  }
  @IBAction func closeViewClicked(_ sender: UIButton) {
    output?.closeView()
  }
}

extension DetailesView: DetailesControllerOutput {
  func dismiss() {
    self.dismiss(animated: true, completion: nil)
  }

  func updateUI() {
    let news = input?.object
    if let url = news?.imageUrl {
      imageNews.af.setImage(withURL: url)
    }
    titleLabel.text = news?.title
    authorLabel.text = news?.author
    if let date = news?.publishedAt {
    dateLabel.text = DayDateFormattersConverter.dayTimeDateFormatter.string(from: date)
    }
    descriptionLabel.text = news?.descriptionNews
  }
}
