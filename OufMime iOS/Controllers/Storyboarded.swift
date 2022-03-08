//
//  Storyboarded.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 04/03/2022.
//

import UIKit

protocol Storyboarded {
    var coordinator: MainCoordinator? { get set }
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
