//
//  SettingsVC.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 09/03/2022.
//

import UIKit

class SettingsVC: StoryboardedVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var wordsCountTf: UITextField!
    @IBOutlet weak var secondsTf: UITextField!
    @IBOutlet weak var categoriesTbl: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(wordsCountTf, withValue: String(coordinator!.viewModel.wordsCount))
        setupTextField(secondsTf, withValue: String(Int(coordinator!.viewModel.timerTotalTime)))

        categoriesTbl.dataSource = self
        categoriesTbl.delegate = self
    }

    func setupTextField(_ textField: UITextField, withValue value: String) {
        let keypadToolbar: UIToolbar = UIToolbar()

        keypadToolbar.items = [
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        ]

        keypadToolbar.sizeToFit()
        textField.inputAccessoryView = keypadToolbar

        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.lightGray.cgColor

        textField.text = value
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Category.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = categoriesTbl.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
            let category = Category.allCases[indexPath.row]

            cell.updateCell(with: category, isOn: (coordinator!.viewModel.categories[category.rawValue])!, atRow: indexPath.row, onSwitchToggled: updateCategory(atRow:))

            return cell
        } else {
            return CategoryCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCategory(atRow: indexPath.row)

        categoriesTbl.reloadData()
    }

    func updateCategory(atRow row: Int) {
        let category = Category.allCases[row]
        coordinator!.viewModel.categories[category.rawValue] = !coordinator!.viewModel.categories[category.rawValue]!

        categoriesTbl.reloadData()
    }

    @IBAction func playPressed(_ sender: Any) {
        if let wordsCount = Int(wordsCountTf.text ?? ""), let seconds = Double(secondsTf.text ?? "") {
            coordinator!.viewModel.editGamesSettings(withWordsCount: wordsCount, turnDuration: seconds)
            coordinator!.startGame()
        }
    }
}
