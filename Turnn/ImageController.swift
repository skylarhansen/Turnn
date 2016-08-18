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
}