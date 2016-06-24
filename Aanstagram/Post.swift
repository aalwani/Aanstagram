//
//  Post.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/20/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject
{
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, lc:Int, comm: [String], u: [String],withCompletion completion: PFBooleanResultBlock?)
    {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = lc
     //   post["commentsCount"] = comm.count
        post["comments"] = comm as [String]
        post["usersWhoComment"] = u as [String]
        //post["createdAt"] = post.createdAt
        //post["time"] = post.createdAt
        //print(post["time"])
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
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


