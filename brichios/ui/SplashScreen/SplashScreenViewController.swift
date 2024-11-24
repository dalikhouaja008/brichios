//
//  SplashScreenViewController.swift
//  brichios
//
//  Created by Mac Mini 2 on 24/11/2024.
//

import UIKit
import SwiftUI

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func SplashScreenSegue(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: SplashScreenView())
    }
    

}
