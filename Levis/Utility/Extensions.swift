//
//  ViewControllerExtensions.swift
//  Levis
//
//  Created by Prerna on 1/16/18.
//  Copyright © 2018 prerna. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(title: String, detail: String) {
        let ac = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(dismissAction)
        present(ac, animated: true)
    }
}
