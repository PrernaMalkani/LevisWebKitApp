//
//  Product.swift
//  Levis
//
//  Created by Prerna on 1/16/18.
//  Copyright © 2018 prerna. All rights reserved.
//

import Foundation

//represents all product info needed
struct Product {
    
    let name: String
    let price: String
    let imageURL: String
    
    init?(data: Any) {
        guard let info = data as? [String: Any],
            let name = info["name"] as? String,
            let price = info["price"] as? String,
            let imageURL = info["image"] as? String else {
                return nil
        }
        self.name = name
        self.price = price
        self.imageURL = imageURL
    }
}
