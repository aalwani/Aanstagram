//
//  LoginViewController.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/20/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController
{

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UITextView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.errorView.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject)
    {
        self.errorView.hidden = true
        self.errorLabel.hidden = true
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!)
        {(user:PFUser?, error: NSError?) -> Void in
            if user != nil{
                print("yay")
                self.performSegueWithIdentifier("loginSegue", sender: nil)

            }
            else
            {
                self.errorView.hidden = false
                self.errorLabel.hidden = false
                self.errorLabel.text =  (error?.localizedDescription)! as String
                
            }
            }
    }

    @IBAction func onSignUp(sender: AnyObject) {
        self.errorView.hidden = true
        self.errorLabel.hidden = true
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackgroundWithBlock { (sucess: Bool, error: NSError?) -> Void in
            if sucess
            {
                print("yay")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
            else
            {
                self.errorView.hidden = false
                self.errorLabel.hidden = false
                self.errorLabel.text =  (error?.localizedDescription)! as String
            }
            
        }
        
        
    }
    
   
    @IBAction func didTap(sender: AnyObject) {
        view.endEditing(true)
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
