//
//  Constants.swift
//  Levis
//
//  Created by Prerna on 1/15/18.
//  Copyright © 2018 prerna. All rights reserved.
//

import Foundation

struct Urls {
    
    static let baseUrl = "https://m.levi.com/US/en_US/"
    
    static var productsUrl: URL? {
        return URL(string: baseUrl + "categories/category~men~jeans~all/products")
    }
    
    static func isProductDetail(url: URL) ->Bool{
        return url.absoluteString.contains(baseUrl+"products/")
    }
}
