//
//  Javascript.swift
//  Levis
//
//  Created by Prerna on 1/16/18.
//  Copyright © 2018 prerna. All rights reserved.
//

import Foundation

struct Javascript {
    
    static let updatePayButton: String = {
        return ( """
                var mainContent = document.getElementById('mainContent');
                var payButton = mainContent.getElementsByClassName('add-to-cart-btn')[0];
                payButton.textContent = 'Pay';

                payButton.onclick = function(){
                    //get info
                    var productName = document.getElementsByClassName('product-header')[0].innerText;
                    var productPrice = document.getElementsByClassName('product-price')[0].innerText;
                    var productImage = document.getElementsByClassName('product-image')[0].src;
                    
                    var data = {'name': productName, 'price': productPrice, 'image': productImage };
                    try {
                        webkit.messageHandlers.homeHandler.postMessage(data);
                    } catch(err) {
                        console.log('error');
                    }
                };
            """)
    }()
}
