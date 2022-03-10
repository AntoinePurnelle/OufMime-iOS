//
//  ViewController.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 03/03/2022.
//

import UIKit

class WelcomeVC: StoryboardedVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playPressed(_ sender: Any) {
        coordinator?.startGame()
    }
    
    
    @IBAction func settingsPressed(_ sender: Any) {
        coordinator!.startSettings()
    }
    
}

