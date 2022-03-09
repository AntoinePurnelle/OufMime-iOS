//
//  PlayVC.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 08/03/2022.
//

import UIKit
import KCCircularTimer
import AVFoundation

class PlayVC: UIViewController, Storyboarded {

    var coordinator: MainCoordinator?
    var player: AVAudioPlayer?
    var timerPlayer: AVAudioPlayer?
    var timer: Timer?

    @IBOutlet weak var timerProgressBar: KCCircularTimer!
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var foundLbl: UILabel!
    @IBOutlet weak var missedLbl: UILabel!
    @IBOutlet weak var foundBtn: UIButton!
    @IBOutlet weak var missedBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true;

        initColors()
        updateViews()
        initTimer()
    }


    private func initColors() {
        if let vm = coordinator?.viewModel {
            view.backgroundColor = vm.primaryColor
            timerProgressBar.tintColor = vm.secondaryColor
            timerProgressBar.circleColor = vm.secondaryTransparentColor
        }
    }

    func updateViews() {
        let vm = coordinator!.viewModel

        wordLbl.text = vm.currentWord?.word
        categoryLbl.text = vm.currentWord?.category.rawValue

        foundLbl.text = String(vm.wordsFoundInTurnCount)
        missedLbl.text = String(vm.wordsMissedInTurnCount)
    }

    func initTimer() {
        var vm = coordinator!.viewModel

        timerProgressBar.currentValue = vm.timerCurrentTime
        timerProgressBar.maximumValue = vm.timerTotalTime

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            vm.timerCurrentTime -= 1

            self.timerProgressBar.currentValue = vm.timerCurrentTime

            if vm.timerCurrentTime == 4 {
                self.play(sound: "timer.wav")
            }

            if vm.timerCurrentTime == 0 {
                self.play(sound: "times_up.wav")
                vm.playWord(wasFound: false, timerEnded: true)
                self.endTurn()
            }
        }
    }

    @IBAction func wordFoundPressed(_ sender: Any) {
        play(sound: "word_ok.wav")
        playWord(found: true)
    }

    @IBAction func wordMissedPressed(_ sender: Any) {
        play(sound: "word_wrong.wav")
        playWord(found: false)
    }

    private func playWord(found: Bool) {
        if let coordinator = coordinator {
            coordinator.viewModel.playWord(wasFound: found, timerEnded: false)

            if (coordinator.viewModel.hasMoreWords) {
                updateViews()
            } else {
                endTurn()
            }
        }
    }

    func play(sound soundName: String, isTimerSound: Bool = false) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil) else {
            return
        }

        let url = URL(fileURLWithPath: path)

        do {

            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)

            try AVAudioSession.sharedInstance().setActive(true)
            
            if (isTimerSound) {
                timerPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                timerPlayer!.play()
            } else {
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                player!.play()
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func endTurn() {
        updateViews()
        foundBtn.isEnabled = false
        missedBtn.isEnabled = false
        timer?.invalidate()
        timerPlayer?.stop()
        coordinator!.endTurn()
    }
}
