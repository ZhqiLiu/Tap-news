//
//  NewsTableTableViewController.swift
//  TapNews
//
//  Created by Sam Zhang on 5/14/18.
//  Copyright © 2018 Sam Zhang. All rights reserved.
//

import UIKit
import Firebase

class NewsTableTableViewController: UITableViewController {
    
    //array of news
    var newsModel = [News]()
    
    // Setup Database
    private let NewsDB = Database.database().reference().child("News").queryOrdered(byChild: "priority").queryLimited(toFirst: 6)

    // private properties
    private var currentKey: String!
    private var currentPriority: String!
    
    var loadMoreView: UIView?
    var enableToLoad = true

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
        self.tableView.rowHeight = 128
        
        /* Initialized DB
        NewsList().sendToFirebase()
        */
        
        //Call setup load more view
        self.setUpLoadMore()
        self.tableView.tableFooterView = self.loadMoreView
        
        self.loadMoreNews()
    }
    
    // MARK: - Pagination
    func setUpLoadMore() {
        //load-more view
        loadMoreView = UIView(frame: CGRect(x: 0, y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: 60))
        loadMoreView?.autoresizingMask = UIViewAutoresizing.flexibleWidth
        loadMoreView?.backgroundColor = UIColor.white
        
        //spinner
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .white
        spinner.color = UIColor.gray
        let spinner_x = (loadMoreView?.frame.size.width)! / 2 - spinner.frame.width / 2
        let spinner_y = (loadMoreView?.frame.size.height)! / 2 - spinner.frame.height / 2
        spinner.frame = CGRect(x: spinner_x, y: spinner_y, width: spinner.frame.width, height: spinner.frame.height)
        spinner.startAnimating()
        
        //add spinner to load-more view
        loadMoreView?.addSubview(spinner)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let currentOffset = scrollView.contentOffset.y
        print("scrollView.contentSize.height: \(scrollView.contentSize.height), scrollView.frame.size.height\(scrollView.frame.size.height), scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
        if maxOffset - currentOffset < 30 {
            print("load more news")
            loadMoreNews()
        }
    }

    func loadMoreNews() {
        enableToLoad = false
        if newsModel.count == 0 {
            //read
            NewsDB.observeSingleEvent(of: .value, with: updateTable)
        }
        else {
            //query
            NewsDB.queryStarting(atValue: currentPriority, childKey: currentKey).observeSingleEvent(of: .value, with: updateTable)
        }
    }
    
    func updateTable(snaps: DataSnapshot) {
        print("Loading \(snaps.childrenCount) more news")
        if snaps.childrenCount > 0 {
            for s in snaps.children.allObjects as! [DataSnapshot] {
                if s.key != self.currentKey {
                    let sObj = s.value as! Dictionary<String, String>
                    currentKey = s.key
                    currentPriority = sObj["priority"]
                    newsModel.append(News(priority: Int(sObj["priority"]!)!, title: sObj["title"]!, description: sObj["description"]!, source: sObj["source"]!, imageUrl: sObj["imageUrl"]))
                    
                    tableView.reloadData()
                }
            }
        }
        enableToLoad = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        cell.title.text = newsModel[indexPath.row].title
        
        /*
         * If last argument is a closure, you can move it ourside of ()
         * DispatchQueue.global().async{(execute: ()->Void)}
         */
        
        DispatchQueue.global().async {
            let urlImage = try? Data(contentsOf: URL(string: self.newsModel[indexPath.row].imageUrl!)!)
            if let imageData = urlImage {
                DispatchQueue.main.async {
                    cell.preview.image = UIImage(data: imageData)
                }
            }
        }
        
        /*错误：
        let urlImage = try? Data(contentsOf: URL(string: self.newsModel[indexPath.row].imageUrl!)!) //take time
        if let imageData = urlImage {
            cell.preview.image = UIImage(data: imageData)
        }
         */
        
        return cell
    }
    
    // MARK: - Segue to NewsDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NewsDetailViewController {
            let row = self.tableView.indexPathForSelectedRow!.row
            destinationVC.imageUrl = newsModel[row].imageUrl
            destinationVC.strTitle = newsModel[row].title
            destinationVC.strSource = newsModel[row].source
            destinationVC.strDescription = newsModel[row].description
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNewsDetailSegue", sender: self)
    }

}
