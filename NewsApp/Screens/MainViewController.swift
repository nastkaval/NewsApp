//
//  MainViewController.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK:- Properties
    let refreshControl = UIRefreshControl()
    var listNews = [NewsEntity]()
    var newsArray = [NewsEntity]()
    
    //MARK:- Outlets
    @IBOutlet weak var newsListTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var notFoundNewsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        refreshControlSettings()
        tableViewSettings()
        getTodayNews()
    }
    
    //MARK: - Actions
    @IBAction func editingChangedSearchTextFiled(_ sender: UITextField) {
        var filteredArray = [NewsEntity]()
        if sender.text?.isEmpty == false {
            for news in newsArray {
                if news.title.lowercased().contains("\(sender.text!.lowercased())") {
                    filteredArray.append(news)
                    listNews = filteredArray
                    checkOperatorTableViewForEmpty()
                } else {
                    if filteredArray.isEmpty == true {
                        listNews = filteredArray
                        checkOperatorTableViewForEmpty()
                    }
                }
            }
        } else {
            listNews = newsArray
            checkOperatorTableViewForEmpty()
            self.view.endEditing(true)
        }
        updateTableView()
    }
    //MARK: - Functions
    ///API
    private func getTodayNews(){
        activityIndicator.startAnimating()
        let today = checkTodayDate()
        ApiManager.shared.getNews(from: today, to: nil, success: { (newsEntityArray) in
            self.newsArray = newsEntityArray
            self.listNews = self.newsArray
            self.activityIndicator.stopAnimating()
            self.updateTableView()
            self.newsListTableView.isHidden = false
            self.refreshControl.endRefreshing()
        }) { (error) in
            print(error.localizedDescription)
            self.refreshControl.endRefreshing()
        }
    }
    private func getLastWeekNews(){
        activityIndicator.startAnimating()
        let today = checkTodayDate()
        let lastWeekDate = checkLastWeekDate()
        ApiManager.shared.getNews(from: today, to: lastWeekDate, success: { (newsEntityArray) in
            self.newsArray = newsEntityArray
            self.listNews = self.newsArray
            self.activityIndicator.stopAnimating()
            self.updateTableView()
            self.newsListTableView.isHidden = false
            self.refreshControl.endRefreshing()
        }) { (error) in
            print(error.localizedDescription)
            self.refreshControl.endRefreshing()
        }
    }
    
    ///Logic
    private func checkTodayDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        return formatter.string(from: date)
    }
    private func checkLastWeekDate() -> String {
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: lastWeekDate) //if today 19.08, its return 12.08
    }
    private func refreshControlSettings(){
        refreshControl.addTarget(self,
                                 action: #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        newsListTableView.addSubview(refreshControl)
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getTodayNews()
    }
    
    ///UI
    private func tableViewSettings(){
        let nib = UINib.init(nibName: "NewsTableViewCell", bundle: nil)
        newsListTableView.register(nib, forCellReuseIdentifier: "NewsTableViewCell")
    }
    private func updateTableView() {
        self.newsListTableView.reloadData()
    }
    
    private func checkOperatorTableViewForEmpty(){
        notFoundNewsView.isHidden = newsListTableView.visibleCells.isEmpty ? false : true
    }
}

//MARK: - Extension TableView
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return newsObjects.count
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //count of slots in table
        return listNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell ?? NewsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.selectionStyle = .none
        let postNews = listNews[indexPath.row]
        cell.setUI(postNews: postNews)
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listNews.count - 1 { //here need to check next and current page, and if have next page of that day - should to load. if not, load next day of week
            //            getLastWeekNews()
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
