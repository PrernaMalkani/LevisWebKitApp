//
//  HomeViewController.swift
//  Levis
//
//  Created by Prerna on 1/15/18.
//  Copyright © 2018 prerna. All rights reserved.
//

import UIKit
import WebKit

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setupWebView()
    }
    
    private func setupWebView() {
        
        if let url = Urls.productsUrl {
            webView.load(URLRequest(url: url))
        }
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: "homeHandler")
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func updated(title: String) {
        self.title = title
    }
    
    func received(error: UserError) {
        showError(title: error.title, detail: error.message)
    }
    
    func productDetailLoaded() {
        webView.evaluateJavaScript(Javascript.updatePayButton, completionHandler: nil)
    }
    
    func purchaseCompleted(product: Product) {
        guard let path = Bundle.main.path(forResource: "OrderConfirmation", ofType: "html") else {
            showError(title: "Can't find next page", detail: "Try again later")
            return
        }
        
        do {
            let contents = try String(contentsOfFile: path)
            let page = format(html: contents, product: product)
            webView.loadHTMLString(page, baseURL: nil)
        } catch let e as NSError {
            showError(title: "Can't load next page", detail: "Try again later")
            print(e.localizedDescription)
            return
        }
    }
    
    func paymentPrompted() {
        let ac = UIAlertController (
            title: "Pay",
            message: "Enter Credit Card Number",
            preferredStyle: .alert)
        
        ac.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default) { _ in
                self.viewModel.initiatePurchase(creditCard: ac.textFields?.first?.text)
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .default, handler: nil)
        
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    //replace HTML placeholders with product data
    func format(html: String, product: Product) -> String {
        return html.replacingOccurrences(of: "{name}", with: product.name)
            .replacingOccurrences(of: "{price}", with: product.price)
            .replacingOccurrences(of: "{image}", with: product.imageURL)
    }
}

extension HomeViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.navigationFinished(webView: webView)
    }
}

extension HomeViewController: WKScriptMessageHandler {
    
    //get product info from javascript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        viewModel.handle(scriptMessage: message)
    }
}
