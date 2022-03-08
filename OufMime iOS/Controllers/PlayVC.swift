//
//  PlayVC.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 08/03/2022.
//

import UIKit

class PlayVC: UIViewController, Storyboarded {
    var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true;
    }

}
