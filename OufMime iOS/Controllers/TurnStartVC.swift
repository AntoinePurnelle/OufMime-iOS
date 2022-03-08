//
//  RoundStartVC.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 04/03/2022.
//

import UIKit

class TurnStartVC: UIViewController, Storyboarded {
    var coordinator: MainCoordinator?

    @IBOutlet weak var blueTotalScoreLbl: UILabel!
    @IBOutlet weak var blueRoundScoreLbl: UILabel!
    @IBOutlet weak var orangeTotalScoreLbl: UILabel!
    @IBOutlet weak var orangeRoundScoreLbl: UILabel!
    @IBOutlet weak var roundNumberLbl: UILabel!
    @IBOutlet weak var roundNameLbl: UILabel!
    @IBOutlet weak var playBtn: SizedButton!
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var scoreboardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true;

        initColors()
        updateViews()
    }

    private func initColors() {
        if let vm = coordinator?.viewModel {
            view.backgroundColor = vm.primaryColor
            playBtn.backgroundColor = vm.secondaryColor

            appIcon.image = UIImage(named: vm.appIconName)
        }
    }

    private func updateViews() {
        if let vm = coordinator?.viewModel {
            blueTotalScoreLbl.text = String(vm.getTotalScore(forTeam: 0))
            blueRoundScoreLbl.text = String(vm.getCurrentRoundScore(forTeam: 0))
            orangeTotalScoreLbl.text = String(vm.getTotalScore(forTeam: 1))
            orangeRoundScoreLbl.text = String(vm.getCurrentRoundScore(forTeam: 1))

            let round = vm.currentRound
            roundNumberLbl.text = "Manche \(round + 1) :"

            switch (round) {
            case 0:
                roundNameLbl.text = "Décrire !"
            case 1:
                roundNameLbl.text = "Un mot !"
            default:
                roundNameLbl.text = "Mimer !"
            }

            playBtn.titleLabel?.text = "\(vm.currentTeamName), JOUEZ !"
        }
    }

    @IBAction func playButtonPressed(_ sender: Any) {
        coordinator?.startTurn()
    }

}
