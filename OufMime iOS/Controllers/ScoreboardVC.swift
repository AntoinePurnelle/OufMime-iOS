//
//  ScoreboardVC.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 09/03/2022.
//

import UIKit

class ScoreboardVC: StoryboardedVC {

    @IBOutlet var blueLbls: [UILabel]!
    @IBOutlet var orangeLbls: [UILabel]!
    @IBOutlet weak var nextBtn: SizedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        if let vm = coordinator?.viewModel {
            for i in 0...2 {
                blueLbls[i].text = getScoreString(inRound: i, forTeam: 0)
                orangeLbls[i].text = getScoreString(inRound: i, forTeam: 1)
            }

            blueLbls[3].text = String(vm.getTotalScore(forTeam: 0))
            orangeLbls[3].text = String(vm.getTotalScore(forTeam: 1))
            
            if !vm.hasMoreRounds {
                nextBtn.setTitle("NOUVELLE PARTIE", for: .normal)
            }
        }
    }

    func getScoreString(inRound round: Int, forTeam team: Int) -> String {
        let score = coordinator!.viewModel.getScore(inRound: round, forTeam: team)
        return score == -1 ? "--" : String(score)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        coordinator!.finishRound()
    }
}
