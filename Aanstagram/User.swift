//
//  User.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/22/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import Parse

class User: NSObject
{
    class func postUserImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?)
{
    // Create Parse object PFObject
    let user = PFObject(className: "User")
    user["media"] = getPFFileFromImage(image) // PFFile column type
    user["username"] = PFUser.currentUser()?.username
    //print("how")
    // Save object (following function will save the object in Parse asynchronously)
    user.saveInBackgroundWithBlock(completion)
}

/**
 Method to convert UIImage to PFFile
 
 - parameter image: Image that the user wants to upload to parse
 
 - returns: PFFile for the the data in the image
 */
class func getPFFileFromImage(image: UIImage?) -> PFFile?
{
    // check if image is not nil
    if let image = image {
        // get image data and check if that is not nil
        if let imageData = UIImagePNGRepresentation(image) {
            return PFFile(name: "image.png", data: imageData)
        }
    }
    return nil
}

}
