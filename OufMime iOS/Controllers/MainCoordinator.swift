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
        let vc = WelcomeVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func startGame() {
        viewModel.initGame {
            self.startRound()
        }
    }

    func startRound() {
        viewModel.initRound()
        
        let vc = TurnStartVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func startTurn() {
        viewModel.initTurn()
        
        let vc = PlayVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
