//
//  signinViewController.swift
//  brichios
//
//  Created by Apple Esprit on 12/11/2024.
//

import UIKit
import SwiftUI

class signinViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBSegueAction func signinviewSegue(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: ContentView())
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
