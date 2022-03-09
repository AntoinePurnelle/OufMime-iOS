//
//  TeamScoreboardView.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 09/03/2022.
//

import UIKit

@IBDesignable
class TeamScoreboardView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initSubViews()
    }

    func initSubViews() {
        layer.cornerRadius = 16.0
        layer.borderWidth = 6.0
        layer.borderColor = tintColor.cgColor
    }

}
