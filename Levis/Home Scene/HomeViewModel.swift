//
//  HomeViewModel.swift
//  Levis
//
//  Created by Prerna on 1/17/18.
//  Copyright © 2018 prerna. All rights reserved.
//

import Foundation
import WebKit

protocol HomeViewModelDelegate: class {
    func updated(title: String)
    func received(error: UserError)
    func purchaseCompleted(product: Product)
    func paymentPrompted()
    func productDetailLoaded()
}

final class HomeViewModel {
    
    private(set) var error: UserError? {
        didSet {
            if let e = error {
                delegate?.received(error: e)
            }
        }
    }
    
    private(set) var title = "" {
        didSet {
            delegate?.updated(title: title)
        }
    }
    
    private(set) var product: Product?
    
    weak var delegate: HomeViewModelDelegate?
    
    func handle(scriptMessage: WKScriptMessage) {
        
        guard let product = Product(data: scriptMessage.body) else {
            error = UserError(title: "Can't get product info", message: "Try again later")
            return
        }
        self.product = product
        delegate?.paymentPrompted()
    }
    
    func navigationFinished(webView: WKWebView) {
        if let url = webView.url, Urls.isProductDetail(url: url) {
            delegate?.productDetailLoaded()
        }
        title = webView.title ?? ""
    }
    
    func initiatePurchase(creditCard: String?) {

        guard let ccNum = creditCard, !ccNum.isEmpty, let _ = Int(ccNum) else {
            error = UserError(title: "Invalid Credit Card Number", message: "Try Again")
            return
        }
        
        if let p = product {
            delegate?.purchaseCompleted(product: p)
        } else {
            error = UserError(title: "Error", message: "No product selected")
        }
    }
}
