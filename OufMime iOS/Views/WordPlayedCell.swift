//
//  WordPlayedCell.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 09/03/2022.
//

import UIKit

class WordPlayedCell: UITableViewCell {

    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var foundImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(with word: Word, wasFound: Bool) {
        wordLbl.text = word.word
        foundImg.image = UIImage(named: wasFound ? "ic_yes" : "ic_no")
        backgroundColor = .white
    }

}
