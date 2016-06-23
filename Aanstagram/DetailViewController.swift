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

class DetailViewController: UIViewController
{

    @IBOutlet weak var posterView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var post: PFObject!
    var check: Bool!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        posterView.file = post["media"] as? PFFile
        posterView.loadInBackground()
        captionLabel.text = post["caption"] as! String
        let s = post["author"] as! PFUser
        
        let usern = s.username! as! String
        usernameLabel.text = usern
        if check == true
        {
            usernameLabel.hidden = false
             }
        else
        {
            usernameLabel.hidden = true
        }
        //timeLabel.text = post["time"] as! String
        let time = post.createdAt
        let x = NSDateFormatter()
        x.dateFormat = "dd MMMM yyyy HH:mm"
        timeLabel.text = x.stringFromDate(time!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
