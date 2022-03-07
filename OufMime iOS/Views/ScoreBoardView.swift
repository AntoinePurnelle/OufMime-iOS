//
//  ScoreBoardView.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 04/03/2022.
//

import UIKit

@IBDesignable
class ScoreBoardView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initSubViews()
    }

    func initSubViews() {
        self.axis = .vertical
        
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        setColor(color: UIColor.orange)
    }
    
    func setColor(color: UIColor) {
        layer.borderColor = tintColor.cgColor
    }

}
