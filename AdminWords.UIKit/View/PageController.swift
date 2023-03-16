//
//  WordsViewController.swift
//  AdminWords.UIKit
//
//  Created by 111 on 05.09.2022.
//
import Combine
import Foundation
import UIKit

class PageController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter value for search"
        sc.searchBar.autocapitalizationType = .allCharacters
       definesPresentationContext = true
        sc.searchBar.scopeButtonTitles = scopeButtonTitles
        return sc
    }()
    
    var scopeButtonTitles = [String]()
    
    var selectedItemsList: SelectedItemsTable!
    
    var subscriptions = [AnyCancellable]()
    
    var viewModel: any ViewModel
    
    init(viewModel: some ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedItemsList = SelectedItemsTable()
        selectedItemsList.update = viewModel.update
        scopeButtonTitles = viewModel.scopeButtonTitles
        setupWordsList()
        setupListWordsLayout()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
//        setupGetWordView()
//        setupLayout()
        setupNavigationBar()
        bindings()

    }
    
    func setupWordsList() {
        selectedItemsList.view.translatesAutoresizingMaskIntoConstraints = false
        selectedItemsList.view.isUserInteractionEnabled = true
        addChild(selectedItemsList)
        view.addSubview(selectedItemsList.view)
        selectedItemsList.didMove(toParent: self)
    }
    
    private func setupNavigationBar() {
         navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        self.navigationController?.navigationBar.topItem?.hidesSearchBarWhenScrolling = true
     }
    
    private func setupListWordsLayout() {
        selectedItemsList.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        selectedItemsList.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        selectedItemsList.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        selectedItemsList.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        selectedItemsList.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        selectedItemsList.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
        
    func bindings() {
        subscriptions = [
            viewModel.itemsPublisher
                .sink { value in
                    switch value {
                    case .failure:
                        print("---------fail_______")
                        self.selectedItemsList.models = [SettingOption(title: "no connection", options: [TableContainer.word(.imaged(ImagedWord(word: WordData(testID: 1000), title: "no connection", handler: {})))])]
                    case .finished: print(                        print("---------fail_finished______")
)
                    }
                } receiveValue: { [weak self] value in
                        self?.selectedItemsList.models = value
                }
        ]
    }

}

extension PageController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
  }

extension PageController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.searchTextField.text {
            self.viewModel.find(query)
        }
    }// called when keyboard search button pressed
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.viewModel.selectedScopeButtonIndex = selectedScope
    }

}
