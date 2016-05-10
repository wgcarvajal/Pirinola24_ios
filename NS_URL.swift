//
//  NS_URL.swift
//  Pirinola24
//
//  Created by Aplimovil on 1/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

extension NSURL
{
    typealias ImageCacheCompletion = NSData -> Void
    
    /// Retrieves a pre-cached image, or nil if it isn't cached.
    /// You should call this before calling fetchImage.
    var cachedImage: NSData? {
        return AppUtil.cache.objectForKey(
            absoluteString) as? NSData
    }
    
    /// Fetches the image from the network.
    /// Stores it in the cache if successful.
    /// Only calls completion on successful image download.
    /// Completion is called on the main thread.
    func fetchImage(completion: ImageCacheCompletion) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(self) {
            data, response, error in
            if error == nil {
                if let  data = data
                {
                    AppUtil.cache.setObject(
                        data,
                        forKey: self.absoluteString,
                        cost: data.length)
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(data)
                    }
                }
            }
        }
        task.resume()
    }

}
