//
//  UserViewModel.swift
//  AdminWords.UIKit
//
//  Created by 111 on 17.09.2022.
//

import UIKit
import Combine

class UsersViewModel: PageViewModelBase {
   private(set) var innerItems: [UserData] = [] {
        didSet {
            items = configureModels()
        }
    }
  
    override var selectedScopeButtonIndex: Int {
        set {
            if 0 > newValue  || newValue > scopeButtonTitles.count - 1 {
                 buttonIndex = 0
            }
            buttonIndex = newValue
        }
        get {
            return buttonIndex
        }
    }

    let buttonTitles: [UserData.CodingKeys] = [.userID, .dataPayed, .login, .mail, .isPayed,.theLastVisit]
   
    override  var scopeButtonTitles: [String] {
        get {
            buttonTitles.map { title in
                title.rawValue
            }
        }
    }
  
    func find(_ query: String) {
        let param: UserParam = {
            switch buttonIndex {
            case 1: return .dataPayed(query)
            case 2: return .login(query)
            case 3: return .mail(query)
            case 4:
                if query == "true" || query == "1" {
                return .isPayed(true)
                } else {
                    return .isPayed(false)

                }
            default: return .userID(query)
            }
        }()
        
        NetwortProvider.Users<UserData>.fetch(userBy: param) { result in
            self.innerItems = result
            }
        }
    
    private func configureModels() -> [SettingOption] {
         
        var subscribedSection = SettingOption(title: "with image", options: [TableContainer]())
        var unSubscribedSection = SettingOption(title: "with image", options: [TableContainer]())

         innerItems.forEach {
             user in
             switch user.isPayed {
             case true:
                 subscribedSection.options.append(.user(.subscribed(SubscribedUser(user: user, title: "sunscribed") {}
                                                                   )
                 )
             )
             
             default: unSubscribedSection.options.append(.user(.unsubscribed(UnsubsccribedUser(user: user, title: "unsubscribed") {}
                                                                            )
             )
         )
             }
         }
        return [subscribedSection, unSubscribedSection]
     }
      
}

