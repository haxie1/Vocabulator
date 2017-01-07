//
//  WordSessionCompleteController.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/6/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

class WordSessionCompleteController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleDone(_ sender: AnyObject?) {
        WordViewerEvents.complete()
    }

}
