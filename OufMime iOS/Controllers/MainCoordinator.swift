//
//  MainCoordinator.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 04/03/2022.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var viewModel: WordsViewModel = WordsViewModel()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isUserInteractionEnabled = false
    }

    func start() {
        navigate(to: WelcomeVC.instantiate())
    }
    
    func startSettings() {
        navigate(to: SettingsVC.instantiate())
    }

    func startGame() {
        popToWelcome()
        viewModel.initGame {
            self.startRound()
        }
    }

    func startRound() {
        viewModel.initRound()
        navigate(to: TurnStartVC.instantiate())
    }

    func startTurn() {
        viewModel.initTurn()
        navigate(to: PlayVC.instantiate())
    }

    func endTurn() {
        navigate(to: TurnEndVC.instantiate())
    }

    func finishAndSaveTurn() {
        viewModel.finishTurn()

        if viewModel.hasMoreWords {
            popToRoundStart()
        } else {
            navigate(to: ScoreboardVC.instantiate())
        }
    }

    func finishRound() {
        if viewModel.hasMoreRounds {
          viewModel.finishRound()
          popToRoundStart()
        } else {
          popToWelcome()
        }
    }
    
    func popToWelcome() {
        let welcomeVC = navigationController.viewControllers[0]
        navigationController.popToViewController(welcomeVC, animated: true)
    }

    func popToRoundStart() {
        let turnStartVC = navigationController.viewControllers[1] as! TurnStartVC
        navigationController.popToViewController(turnStartVC, animated: true)
        turnStartVC.initColors()
        turnStartVC.updateViews()
    }

    private func navigate(to vc: StoryboardedVC) {
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
