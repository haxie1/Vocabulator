//
//  WordViewerViewController.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

struct WordViewerViewModel {
    let word: String
    let pronunciation: String
    let definition: String
}

class WordViewerViewController: UIViewController {
    var viewModel: WordViewerViewModel? {
        didSet {
            if let model = viewModel {
                self.applyViewModel(viewModel: model)
            }
        }
    }
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var alternateLabel: UILabel!
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyViewModel(viewModel: self.viewModel!) // if we don't have a viewmodel at this point, crash
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        WordViewerEvents.cancel()
    }
    
    private func applyViewModel(viewModel: WordViewerViewModel) {
        if self.isViewLoaded {
            self.wordLabel.text = viewModel.word
            self.alternateLabel.text = viewModel.pronunciation
            self.definitionTextView.text = viewModel.definition
        }
    }
}
