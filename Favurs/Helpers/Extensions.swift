//
//  Extensions.swift
//  Favurs
//
//  Created by Paul on 2018-01-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    //So that the downloaded images dont need to be downloaded again. Saves networking data.
    func loadImagesUsingCacheWithUrlString(urlString:String){
        
        //blank out white space to take out flashing.
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = cachedImage
            return
        }
        
        
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let error = error {
                print(error, #line)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                 imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            }
        })
        task.resume()
        
    }
    
    
}
