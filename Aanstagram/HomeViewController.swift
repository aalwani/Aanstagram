//
//  HomeViewController.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/20/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    let HeaderViewIdentifier = "TableViewHeaderView"
    var postss = []
    var infinite: Bool = false
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    @IBOutlet weak var tableView: UITableView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        loadData()
    }
    func loadData()
    {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        
        if(!infinite)
        {
            query.limit = 20
        }
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.postss = posts
                self.tableView.reloadData()
            } else
            {
                print(error?.localizedDescription)
            }
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.yellowColor()
        cell.selectedBackgroundView = backgroundView
        let post = postss[indexPath.section] as! PFObject
        cell.posterImageView.file = post["media"] as? PFFile
        cell.posterImageView.loadInBackground()
        cell.captionLabel.text = post["caption"] as! String
        

        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        self.loadData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if (!isMoreDataLoading)
        {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            infinite = true
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging)
            {
                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                self.loadData()
            }
            
        }
        infinite = false
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return postss.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        if postss.count != 0
        {
        let post = postss[section] as! PFObject
            let times = post.createdAt
            let x = NSDateFormatter()
            x.dateFormat = "dd MMMM yyyy HH:mm"
            let t = x.stringFromDate(times!)
        let author = post["author"] as! PFUser
        header.textLabel!.text = author.username! + "                 " + t
        }
        return header
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    
    
  
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let check = true
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let post = postss[(indexPath?.section)!]
        let detailVC = segue.destinationViewController as! DetailViewController
        detailVC.post = post as! PFObject
        detailVC.check = check as Bool
    }
    
    
    
    
    
    
    
    
    
    
    // The getObjectInBackgroundWithId methods are asynchronous, so any code after this will run
    // immediately.  Any code that depends on the query result should be moved
    // inside the completion block above.
    
    
    
    
}


