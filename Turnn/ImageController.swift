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
    
    static func saveImage(_ image: UIImage, completion: @escaping (_ imageURL: String?) -> Void){
        
        if let uploadData = UIImagePNGRepresentation(image) {
            let imageName = UUID().uuidString
            FirebaseController.storage.child("Event Location Screenshots").child(imageName).put(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                } else {
                    completion(metadata?.downloadURL()?.absoluteString)
                }
            })
        }
    }
    
    static func imageForUrl(_ urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            fatalError("Image URL optional is nil")
        }
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            DispatchQueue.main.async(execute: {
                completion(UIImage(data: data))
            })
        }
    }
}

