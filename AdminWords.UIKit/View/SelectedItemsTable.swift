//
//  SelectedWordsTable.swift
//  AdminWords.UIKit
//
//  Created by 111 on 06.09.2022.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class SelectedItemsTable: UIViewController {
    var table: UITableView!
    var update: ((TableContainer) -> Void)!
    
    var models = [SettingOption]() {
        didSet {
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "title"
        
        let frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.bounds.width, height: view.bounds.height))
        
        table = UITableView(frame: frame, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SelectedWordsTable")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 30
        view.addSubview(table)
        
    }
    
}



extension SelectedItemsTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataEditor: UIViewController
        
        let word: WordContainer
        let wordEnum = models[indexPath.section].options[indexPath.item]
        
        guard case let .word(wordsContainer) = wordEnum else { fatalError("enum doesnt excist") }
        
            switch wordsContainer {
            case .imaged(let container): word = container
            case .nonImage(let container): word = container
            }
        
        
        dataEditor = WordEditor(data: word.word) { word in
            print("update in table")
            print(word)
        }
        

       present(dataEditor, animated: true)
        
       print("User tapped on item \(indexPath.row)")
    
    tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
}


extension SelectedItemsTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "SelectedWordsTable", for: indexPath)
        var content = myCell.defaultContentConfiguration()
        let model = models[indexPath.section].options[indexPath.row]
        
        if case let .word(wordsTableContainer) = model {
            switch wordsTableContainer.self {
            case .nonImage(let model):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SingleTableViewCell.identifier,
                    for: indexPath
                ) as? SingleTableViewCell else {
                    content.image = UIImage(systemName: "i.circle")
                    content.text = "\(model.word.english) \(model.word.ruTranslate)"
                    // Customize appearance.
                    content.imageProperties.tintColor = .purple
                    myCell.contentConfiguration = content
                    return myCell
                }
                cell.configure(with: model)
                return cell
            case .imaged(let model):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SingleTableViewCell.identifier,
                    for: indexPath
                ) as? SingleTableViewCell else {
                    content.image = UIImage(systemName: "i.circle.fill")
                    content.text = "\(model.word.english) \(model.word.ruTranslate)"
                    // Customize appearance.
                    content.imageProperties.tintColor = .purple
                    myCell.contentConfiguration = content
                    return myCell
                }
                cell.configure(with: model)
                return cell
            }
            
        } else if case let .user(usersTableContainer) = model {
            switch usersTableContainer.self {
            case .subscribed(let model):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SingleTableViewCell.identifier,
                    for: indexPath
                ) as? SingleTableViewCell else {
                    content.image = UIImage(systemName: "dollarsign.circle.fill")
                    content.text = "\(model.user.login)"
                    // Customize appearance.
                    content.imageProperties.tintColor = .purple
                    myCell.contentConfiguration = content
                    return myCell
                }
                cell.configure(with: model)
                return cell
            case .unsubscribed(let model):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SingleTableViewCell.identifier,
                    for: indexPath
                ) as? SingleTableViewCell else {
                    content.image = UIImage(systemName: "dollarsign.circle")
                    content.text = "\(model.user.login)"
                    // Customize appearance.
                    content.imageProperties.tintColor = .purple
                    myCell.contentConfiguration = content
                    return myCell
                }
                cell.configure(with: model)
                return cell
            }
        }
        return myCell

    }
}


