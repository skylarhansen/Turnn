//
//  ImageController.swift
//  Turnn
//
//  Created by Justin Smith on 8/17/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import FirebaseStorage

class ImageController {
    
    static var event: Event?
    
    static func saveImage(image: UIImage, completion: (imageURL: String?) -> Void){
        
        if let uploadData = UIImagePNGRepresentation(image) {
            let imageName = NSUUID().UUIDString
            FirebaseController.storage.child("Event Location Screenshots").child(imageName).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(imageURL: nil)
                } else {
                    completion(imageURL: metadata?.downloadURL()?.absoluteString)
                }
            })
        }
    }
    
    static func imageForUrl(urlString: String, completion: (image: UIImage?) -> Void) {
        guard let url = NSURL(string: urlString) else {
            fatalError("Image URL optional is nil")
        }
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            guard let data = data else {
                completion(image: nil)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion(image: UIImage(data: data))
            })
        }
    }
}

