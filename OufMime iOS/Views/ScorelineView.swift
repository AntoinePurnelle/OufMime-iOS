//
//  ScorlineView.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 07/03/2022.
//

import UIKit

@IBDesignable
class ScorelineView: UIStackView {
    @IBOutlet weak var scoreNameLbl: UILabel!
    @IBOutlet weak var scoreValueLbl: UILabel!
    @IBOutlet var contentView: ScorelineView!
    
    var view: UIView!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    func loadViewFromNib() {
        let nib = UINib(nibName: "ScorelineView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadViewFromNib()
    }

}
