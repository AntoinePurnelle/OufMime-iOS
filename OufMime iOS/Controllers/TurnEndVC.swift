//
//  TurnEndVC.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 09/03/2022.
//

import UIKit

class TurnEndVC: StoryboardedVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var foundLbl: UILabel!
    @IBOutlet weak var missedLbl: UILabel!
    @IBOutlet weak var wordsTbl: UITableView!
    @IBOutlet weak var nextBtn: SizedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        wordsTbl.delegate = self
        wordsTbl.dataSource = self
        wordsTbl.backgroundColor = .white

        updateViews()
    }


    override func initColors() {
        if let vm = coordinator?.viewModel {
            view.backgroundColor = vm.primaryColor
            nextBtn.backgroundColor = vm.secondaryColor

            appIcon.image = UIImage(named: vm.appIconName)
        }
    }

    private func updateViews() {
        if let vm = coordinator?.viewModel {
            foundLbl.text = String(vm.wordsFoundInTurnCount)
            missedLbl.text = String(vm.wordsMissedInTurnCount)

            wordsTbl.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coordinator!.viewModel.wordsPlayedInTurn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = wordsTbl.dequeueReusableCell(withIdentifier: "WordCell") as? WordPlayedCell,
           let wordPlayed: PlayedWord = coordinator?.viewModel.wordsPlayedInTurn[indexPath.row] {
            cell.updateCell(with: wordPlayed.word, wasFound: wordPlayed.found)
            return cell
        } else {
            return WordPlayedCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator!.viewModel.changeValueInPlayedWords(atRow: indexPath.row)
        updateViews()
    }

    @IBAction func nextPressed(_ sender: Any) {
        coordinator!.finishAndSaveTurn()
    }
}
