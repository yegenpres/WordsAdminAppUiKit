//
//  Api.swift
//  AdminWords.UIKit
//
//  Created by 111 on 29.09.2022.
//

import Foundation

enum HTTPApi: String {
    case wordsQuery = "https://wordsapp.club:8443/Admin/GetWordsBy?UserID=2&"
    case usersQuery = "https://wordsapp.club:8443/Admin/GetUsersBy?UserID=2&"
}
