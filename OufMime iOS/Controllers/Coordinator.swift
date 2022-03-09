//
//  Coordinator.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 04/03/2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var viewModel: WordsViewModel { get }

    func start()
    
    func startGame()
    
    func startRound()
    
    func startTurn()
    
    func endTurn()
}
