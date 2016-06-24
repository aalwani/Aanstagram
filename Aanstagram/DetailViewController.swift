//
//  DetailViewController.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/21/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var profPic: PFImageView!
    @IBOutlet weak var commentFieldf: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var c: [String] = []
    var uu: [String] = []
    @IBOutlet weak var comments: UITableView!

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var TIMElABEL: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var posterView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    var post: PFObject!
    var check: Bool!
    @IBOutlet weak var tapToLike: UIButton!
    var s: PFUser = PFUser.currentUser()!
    //var user: PFUser = PFUser.currentUser()!
    var usersss: [PFObject] = []
    
    @IBAction func prof(sender: AnyObject)
    {
        //performSegueWithIdentifier("bye2fvrnbjbcnburlctdhjbjfrjucdltlbik", sender: nil)
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        comments.delegate = self
        comments.dataSource = self
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: comments.frame.origin.y + comments.frame.size.height )
        posterView.file = post["media"] as? PFFile
        posterView.loadInBackground()
        captionLabel.text = post["caption"] as! String
        s = post["author"] as! PFUser
        
        let usern = s.username! as! String
        usernameLabel.text = usern
        var l = post["likesCount"] as! Int
      likesLabel.text = "Likes: " + String(l)
        
        
        
    
        let query = PFQuery(className: "User")
        query.orderByDescending("createdAt")
        query.whereKey("username", equalTo: usern)
        query.findObjectsInBackgroundWithBlock
            { (us: [PFObject]?, error: NSError?) -> Void in
                if let us = us
                {
                    self.usersss = us
                    let u = self.usersss[0] as! PFObject
                    self.profPic.file = u["media"] as! PFFile
                    self.profPic.loadInBackground()
                    
                    
                }
                else
                {
                    print(error?.localizedDescription)
                    print("sozz no pic 4 u")
                }
             
                
        }

        if check == true
        {
            usernameLabel.hidden = false
            profPic.hidden = false
             }
        else
        {
            usernameLabel.hidden = true
            profPic.hidden = true
        }
        //timeLabel.text = post["time"] as! String
        let time = post.createdAt
        let x = NSDateFormatter()
        x.dateFormat = "dd MMMM yyyy HH:mm"
        TIMElABEL.text = x.stringFromDate(time!)

        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    @IBAction func submitComment(sender: AnyObject)
{
    s = PFUser.currentUser()!
    var u = s.username as String!
    let commen = String(commentFieldf.text!) ?? ""
    if commen == ""
    {
            print("not cool bro")
            return
    }
        else
    {
       // var x : [String] = []
      //  x = post["comments"] as! [String]
        c = post["comments"] as! [String]
        c.append(commen)
        uu = post["usersWhoComment"] as! [String]
        uu.append(u)
        post["comments"] = c as [String]
        post["usersWhoComment"] = uu as [String]
        var completion: PFBooleanResultBlock =
                { (success: Bool, error: NSError?) in
            
            if success
            {
                print("yay")
            }
            else
            {
                print("There was an error: \(error?.localizedDescription)")
            }
        }
        print(post)
        self.post.saveInBackgroundWithBlock(completion)
        commentFieldf.text = ""
        self.viewDidLoad()
        comments.reloadData()
        
    
    }

    
}
    
    @IBAction func tapLike(sender: AnyObject)
    {
        
        let wtv = post["likesCount"] as! Int
        post["likesCount"] = wtv + 1
        var completion: PFBooleanResultBlock = { (success: Bool, error: NSError?) in
            
            // stop activity indicator
            //self.activityIndicator.stopAnimating()
           // MBProgressHUD.hideHUDForView(self.view, animated: true)
            if success
            {
                print("yay")
            }
            else {
                print("There was an error: \(error?.localizedDescription)")
            }
        }

//         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
       
            self.post.saveInBackgroundWithBlock(completion)
        self.viewDidLoad()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func goToUserProfile(sender: AnyObject)
    {
       //performSegueWithIdentifier("bye", sender: nil)
    }
    
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "bye" || segue.identifier == "bye2")
        {
        
        let barViewControllers = segue.destinationViewController as! UITabBarController
        let nav = barViewControllers.viewControllers![2] as! UINavigationController
        let destinationViewController = nav.topViewController as! ProfileViewController
        destinationViewController.userr = s as PFUser
        barViewControllers.selectedIndex = 2
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return post["comments"].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = comments.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! commentCell
        var x: [String] = post["comments"] as! [String]
        var y: [String] = post["usersWhoComment"] as! [String]
        cell.namei.text = y[indexPath.row] as String
        cell.comment.text = x[indexPath.row] as String
        return cell
    }
    
    
    
    

}
