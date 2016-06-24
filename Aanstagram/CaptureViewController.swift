//
//  CaptureViewController.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/20/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import MBProgressHUD

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var lc: Int = 0
    var c: [String] = []
    var u: [String] = []
    @IBOutlet weak var makeProfilePicLabel: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var uploadNew: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var errorView: UITextView!
    @IBOutlet weak var captionText: UITextField!
    @IBOutlet weak var tap: UIButton!
    @IBOutlet weak var posterView: UIImageView!
    let vc = UIImagePickerController()
    var booolean:Bool = false
    
    @IBAction func cameraFunction(sender: AnyObject)
    {
        errorView.hidden = true
        booolean = true
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            //vc.allowsEditing = false
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            vc.cameraCaptureMode = .Photo
            presentViewController(vc, animated: true, completion: nil)
        }
        else
        {
            if posterView.image != nil {
                uploadNew.hidden = false }
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .Alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.Default,
                handler: nil)
            alertVC.addAction(okAction)
            presentViewController(alertVC, animated: true, completion: nil)
        }
        
    }
    
    func resize(image: UIImage, newWidth: CGFloat) -> UIImage
    {
//        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
//        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
//        resizeImageView.image = image
//        
//        UIGraphicsBeginImageContext(resizeImageView.frame.size)
//        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
        
        
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        errorView.hidden = true
        self.uploadNew.hidden = true
        vc.delegate = self
        vc.allowsEditing = true
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        // Get the image captured by the UIImagePickerController
        var originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if(booolean)
        {
            originalImage = self.resize(originalImage, newWidth: 200)
        }
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let caption = String(captionText.text!) ?? ""
        self.posterView.image = editedImage as UIImage
        self.uploadNew.hidden = false
        self.tap.hidden = true
        // Do something with the images (based on your use case)
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapToContinue(sender: AnyObject)
    {
        self.uploadNew.hidden = true
        errorView.hidden = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func uploadNewFunc(sender: AnyObject)
    {
        
        self.tapToContinue(self)
        errorView.hidden = true
        self.uploadNew.hidden = false
    }
    @IBAction func post(sender: AnyObject)
    {
        //bb = {(true, NSError?) -> Void }
        /*To upload the user image to Parse, get the user input from the view controller and then call the postUserImage method from the view controller by passing all the required arguments into it (Please see method's comments for more details on arguments).*/
        // start activity indicator
        

        //activityIndicator.startAnimating()
        if posterView.image != nil
        {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            Post.postUserImage(posterView.image, withCaption: captionText.text, lc: lc, comm: c as [String], u: u as [String], withCompletion: { (success: Bool, error: NSError?) in
                
                // stop activity indicator
                //self.activityIndicator.stopAnimating()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if success {
                    self.tabBarController?.selectedIndex = 0
                } else {
                    print("There was an error: \(error?.localizedDescription)")
                }
            })
            
        }
        else
        {
            errorView.hidden = false
        }
        
        
    }
    @IBAction func makeProfilePicture(sender: AnyObject)
    {
        if posterView.image != nil
        {

            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
           User.postUserImage(posterView.image, withCompletion: { (success: Bool, error: NSError?) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if success
            {
                self.performSegueWithIdentifier("ppSegue", sender: nil)
                
            } else
            {
                print("There was an error: \(error?.localizedDescription)")
            }
 
           
           
           })
        
        }
        
    
        else
        {
            errorView.hidden = false
        }
}
    
        
        
    @IBAction func didTap(sender: AnyObject)
    {
        posterView.image = nil
        captionText.text = ""
        uploadNew.hidden = true
        tap.hidden = false
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "ppSegue"){
            let barViewControllers = segue.destinationViewController as! UITabBarController
            let nav = barViewControllers.viewControllers![2] as! UINavigationController
            let destinationViewController = nav.topViewController as! ProfileViewController
            destinationViewController.yayProfile = true
            barViewControllers.selectedIndex = 2
            
        }
    }
    
    
}
