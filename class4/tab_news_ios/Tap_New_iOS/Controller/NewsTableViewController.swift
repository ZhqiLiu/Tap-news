//
//  NewsTableViewController.swift
//  Tap_New_iOS
//
//  Created by Yichi Zhang on 1/7/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit
import CoreGraphics
import Firebase

class NewsTableViewController: UITableViewController {
    
    private let NewsDB = Database.database().reference().child("News").queryOrdered(byChild: "priority").queryLimited(toFirst: 5)
    private var currentKey: String!
    private var currentPriority: String!
//    private let initializeDB = NewsList() // Was used to initialize database
    
    var loadMoreView: UIView?
    var enableToLoad = true
    
    private var newsList = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableCell")
        
        self.setUpLoadMore()
        self.tableView.tableFooterView = self.loadMoreView
        
        loadNews()  //async
    }
    
    func setUpLoadMore() {
        //load more view
        self.loadMoreView = UIView(frame: CGRect(x: 0, y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: 60))
        self.loadMoreView!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.loadMoreView!.backgroundColor = UIColor.white
        
        //spinner
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .white
        spinner.color = UIColor.gray
        let spinner_x = self.loadMoreView!.frame.size.width / 2 - spinner.frame.width / 2
        let spinner_y = self.loadMoreView!.frame.size.height / 2 - spinner.frame.height / 2
        spinner.frame = CGRect(x: spinner_x, y: spinner_y, width: spinner.frame.width, height: spinner.frame.height)
        spinner.startAnimating()
        self.loadMoreView!.addSubview(spinner)
    }
    
    func loadNews() {
        enableToLoad = false
        if(newsList.count == 0) {
            NewsDB.observeSingleEvent(of: .value, with: updateTable)
        }
        else {
            NewsDB.queryStarting(atValue: self.currentPriority, childKey: self.currentKey).observeSingleEvent(of: .value, with: updateTable)
        }
    }
    
    func updateTable(snaps: DataSnapshot) {
        print(snaps.childrenCount)
        if(snaps.childrenCount > 0) {
            for s in snaps.children.allObjects as! [DataSnapshot] {
                if(s.key != self.currentKey) {
                    let sObj = s.value as! Dictionary<String, String?>
                    self.currentKey = s.key
                    self.currentPriority = sObj["priority"]!!
                    self.newsList.append(News(title: sObj["title"]!!, description: sObj["description"]!!, source: sObj["source"]!, imageUrl: sObj["imageUrl"]!))
                    self.configreTableView()
                    self.tableView.reloadData()
                }
            }
        }
        self.enableToLoad = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as! NewsTableViewCell

        cell.titlePreview.text = newsList[indexPath.row].title
        
        /* Last argument if closure, you can move it outside of ()
        DispatchQueue.global().async(execute: <#T##() -> Void#>)
        */
        DispatchQueue.global().async {  //全局队列 (并发),让耗时程序在后台运行
            let urlImage = try? Data(contentsOf: URL(string: self.newsList[indexPath.row].imageUrl!)!)
            if let imageData = urlImage {
                DispatchQueue.main.async {      //主队列（串行）,UI相关在这里执行
                    cell.preview.image = UIImage(data: imageData)
                }
            }
        }
        
        /* 或者用 scrollViewDidEndDragging 来触发
        if(enableToLoad && self.newsList.count - 1 == indexPath.row) {
            loadNews()
        }
        */
        return cell
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let currentOffset = scrollView.contentOffset.y
        print("scrollView.contentSize.height: \(scrollView.contentSize.height) scrollView.frame.size.height:  \(scrollView.frame.size.height) scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
        if(maxOffset - currentOffset < 30) {
            loadNews()
        }
    }
    
    // Configure cell size
    func configreTableView() {
        self.tableView.rowHeight = 128
    }
    
    //segue to detail news
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowNewsDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewsDetail" {
            if let destinationVC = segue.destination as? NewsDetailViewController {
                
                let row = self.tableView.indexPathForSelectedRow!.row
                destinationVC.imageUrl = newsList[row].imageUrl
                destinationVC.strTitle = newsList[row].title
                destinationVC.strSource = newsList[row].source
                destinationVC.strDescription = newsList[row].description
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = .lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = .blue
        
        return [share, favorite, more]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
