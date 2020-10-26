//
//  SwipeableCollectionViewCell.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol SwipeableCollectionViewCellDelegate: AnyObject {
  func hiddenContainerViewTapped(inCell cell: UICollectionViewCell)
}

class SwipeableCollectionViewCell: UICollectionViewCell {
  let scrollView: UIScrollView = {
    let scrollView = UIScrollView(frame: .zero)
    scrollView.isPagingEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()

  let deleteLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .boldSystemFont(ofSize: 17)
    label.textColor = .white
    label.textAlignment = .left
    label.text = R.string.localizable.clickToDelete()
    return label
  }()

  let visibleContainerView = UIView()
  let hiddenContainerView = UIView()
  weak var delegate: SwipeableCollectionViewCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    setupSubviews()
    setupGestureRecognizer()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
  }

  private func setupSubviews() {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.addArrangedSubview(visibleContainerView)
    stackView.addArrangedSubview(hiddenContainerView)

    addSubview(scrollView)
    scrollView.pinEdgesToSuperView()
    scrollView.addSubview(stackView)
    stackView.pinEdgesToSuperView()
    stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2).isActive = true

    visibleContainerView.backgroundColor = .white
    hiddenContainerView.backgroundColor = .red
    hiddenContainerView.addSubview(deleteLabel)
    deleteLabel.translatesAutoresizingMaskIntoConstraints = false
    deleteLabel.leftAnchor.constraint(equalTo: hiddenContainerView.leftAnchor, constant: 10).isActive = true
    deleteLabel.centerXAnchor.constraint(equalTo: hiddenContainerView.centerXAnchor, constant: 0).isActive = true
    deleteLabel.centerYAnchor.constraint(equalTo: hiddenContainerView.centerYAnchor, constant: 0).isActive = true
  }

  private func setupGestureRecognizer() {
    let hiddenContainerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hiddenContainerViewTapped))
    hiddenContainerView.addGestureRecognizer(hiddenContainerTapGestureRecognizer)
  }

  @objc private func hiddenContainerViewTapped() {
    delegate?.hiddenContainerViewTapped(inCell: self)
  }
}
