//
//  ProfileViewController.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/20/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    let HeaderViewIdentifier = "TableViewHeaderView"
    var yayProfile: Bool = false
    var usersss: [PFObject] = []
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    var infinite: Bool = false
    var news = []
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    @IBOutlet weak var userna: UILabel!
    @IBOutlet weak var logOutLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var userr: PFUser = PFUser.currentUser()!
   

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        check()
        userna.text = PFUser.currentUser()!.username as! String!
        self.welcomeLabel.text = userr.username! + "'s Profile!"
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
         tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        loadData()
       
       
    }
    
    func check()
    {
        
            var currentUser = userr.username
            let query = PFQuery(className: "User")
            query.orderByDescending("createdAt")
            query.whereKey("username", equalTo: currentUser!)
            query.findObjectsInBackgroundWithBlock
                { (us: [PFObject]?, error: NSError?) -> Void in
                if let us = us
                {
                    self.usersss = us
                    let u = self.usersss[0] as! PFObject
                    self.profilePicture.file = u["media"] as! PFFile
                    self.profilePicture.loadInBackground()

                    
                }
                else
                {
                    print(error?.localizedDescription)
                    print("sozz no pic 4 u")
                }
               //            print("???")

                    
            
              }
    }
    
    
        
            
            

    
    
    
    
    @IBAction func profilePicChange(sender: AnyObject)
    {
        tabBarController?.selectedIndex = 1
        
        
    }

    
    func loadData()
    {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: userr)
        
        if(!infinite)
        {
            query.limit = 20
        }
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts
            {
                self.news = posts
                self.tableView.reloadData()
            }
            else
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(sender: AnyObject)
    {
        
        PFUser.logOutInBackgroundWithBlock
        { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfilePostCell", forIndexPath: indexPath) as! ProfilePostCell
        let post = news[indexPath.section] as! PFObject
            cell.posterView.file = post["media"] as? PFFile
            cell.posterView.loadInBackground()
        
            return cell

    }
    
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        self.loadData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        return news.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        if news.count != 0
        {
            let post = news[section] as! PFObject
            let times = post.createdAt
            let x = NSDateFormatter()
            x.dateFormat = "dd MMMM yyyy HH:mm"
            let t = x.stringFromDate(times!)
            let cap = post["caption"] as! String
            header.textLabel!.text = cap + "                 " + t
        }
        return header
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "yay"
        {
        let check2 = false
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let post = news[(indexPath?.section)!]
        let detailVC = segue.destinationViewController as! DetailViewController
        detailVC.post = post as! PFObject
        detailVC.check = check2 as Bool
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
