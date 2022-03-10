//
//  CategoryCell.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 10/03/2022.
//

import UIKit

typealias OnSwitchToggled = (_ row: Int) -> Void

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    
    var row: Int?
    var onSwitchToggled: (OnSwitchToggled)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(with category: Category, isOn: Bool, atRow row: Int, onSwitchToggled: @escaping OnSwitchToggled) {
        categoryLbl.text = category.rawValue
        categorySwitch.isOn = isOn
        
        self.row = row
        self.onSwitchToggled = onSwitchToggled
        
        categorySwitch.addTarget(self, action: #selector(didToggleSwitch(_:)), for: .valueChanged)
    }
    
    @objc func didToggleSwitch(_ sender: UISwitch) {
        onSwitchToggled!(row!)
    }

}
