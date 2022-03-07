//
//  ViewController.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 03/03/2022.
//

import UIKit

class WelcomeVC: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var viewModel: WordsViewModel = WordsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playPressed(_ sender: Any) {
        coordinator?.startRound()
    }
    
    
    @IBAction func settingsPressed(_ sender: Any) {
    }
}

