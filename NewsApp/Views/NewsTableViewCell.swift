//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var descriptionNews: UILabel!
    @IBOutlet weak var postTimeNews: UILabel!
    @IBOutlet weak var authorPostNews: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageNews.image = UIImage(named: "image.imagePlaceholder")
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Functions
    func setUI(postNews: NewsEntity) {
        titleNews.text = postNews.title
        descriptionNews.text = postNews.descriptionNews
        authorPostNews.text = postNews.author
        showMoreButton.isHidden = descriptionNews.numberOfLines == 3 ? false : true
        
        if let escapedString = postNews.urlToImage.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) {
            if let url = URL(string: escapedString) {
                self.imageNews.af.setImage(withURL: url)
            }
        }
        
        if let date = postNews.fullDate {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "")
            formatter.dateFormat = "MM-dd-yyyy HH:mm"
            postTimeNews.text = formatter.string(from: date)
        }
    }
}
