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

    func startGame() {
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
            let turnStartVC = navigationController.viewControllers[1] as! TurnStartVC
            navigationController.popToViewController(turnStartVC, animated: true)
            turnStartVC.initColors()
            turnStartVC.updateViews()
        } else {
            navigate(to: ScoreboardVC.instantiate())
        }
    }

    private func navigate(to vc: StoryboardedVC) {
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
