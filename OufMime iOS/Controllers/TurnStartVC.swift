//
//  RoundStartVC.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 04/03/2022.
//

import UIKit

class TurnStartVC: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var blueTotalScoreLbl: UILabel!
    @IBOutlet weak var blueRoundScoreLbl: UILabel!
    @IBOutlet weak var orangeTotalScoreLbl: UILabel!
    @IBOutlet weak var orangeRoundScoreLbl: UILabel!
    @IBOutlet weak var roundNumberLbl: UILabel!
    @IBOutlet weak var roundNameLbl: UILabel!
    @IBOutlet weak var playBtn: SizedButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
    }
    
}
