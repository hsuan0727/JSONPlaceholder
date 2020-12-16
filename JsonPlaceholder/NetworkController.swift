//
//  NetworkController.swift
//  JsonPlaceholder
//
//  Created by Hsuan on 2020/12/10.
//

import Foundation
import UIKit


class NetworkController {
    static let shared = NetworkController()
    
    let imageCache = NSCache<NSURL,UIImage>()
    
    
    //當 cache 有圖時，直接讀取 cache 裡的圖片
    func fetchImage(url: URL, completionHandler: @escaping (UIImage?) -> ()) {
        if let image = imageCache.object(forKey: url as NSURL) {
            print("cache here")
            completionHandler(image)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                //從網路抓圖後，將圖片存入 cache
                self.imageCache.setObject(image, forKey: url as NSURL)
                print("存入快取")
                completionHandler(image)
            } else {
                completionHandler(nil)
               
            }
        }.resume()
    }
    
  
    
    func fetchplaceholder(completionHandler:@escaping([PlaceholderData]?)->()){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            completionHandler(nil)
            return
        }
         
            URLSession.shared.dataTask(with: url) { (data, response , error) in
                let decoder = JSONDecoder()
                if let data = data,
                   let placeholders = try? decoder.decode([PlaceholderData].self, from: data) {
           
                    print(placeholders)
                    completionHandler(placeholders)
                } else {
                    completionHandler(nil)
                }
                     
            }.resume()
            
         
    }
}
