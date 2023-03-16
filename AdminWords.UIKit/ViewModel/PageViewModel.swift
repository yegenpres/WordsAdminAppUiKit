//
//  PageViewModel.swift
//  AdminWords.UIKit
//
//  Created by 111 on 19.09.2022.
//

import Foundation
import Combine

protocol ViewModel: ObservableObject {
    var itemPublished: Published<TableContainer?> { get }
    var itemPublisher: Published<TableContainer?>.Publisher { get }
    
    var itemsPublished: Published<[SettingOption]> { get }
    var itemsPublisher: Published<[SettingOption]>.Publisher { get }
    
    var selectedScopeButtonIndex: Int { get set }
    var scopeButtonTitles: [String] { get }
    
    func find(_ query: String) -> Void
    
    func update(element: TableContainer)
}

typealias PageViewModelBase = PageViewModel & ViewModel

class PageViewModel {
    
    @Published var items = [SettingOption]()
    var itemsPublished: Published<[SettingOption]> { _items }
    var itemsPublisher: Published<[SettingOption]>.Publisher { $items }
            
    @Published var item: TableContainer?
    var itemPublished: Published<TableContainer?> { _item }
    var itemPublisher: Published<TableContainer?>.Publisher { $item }
    
    var buttonIndex = 0
    var selectedScopeButtonIndex = 0
    var scopeButtonTitles: [String] {
        get {
            return []
        }
    }
    
    func update(element: TableContainer) {
        self.item = element
    }

}
