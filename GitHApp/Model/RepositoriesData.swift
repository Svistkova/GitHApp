//
//  RepositoriesData.swift
//  GitHApp
//
//  Created by Marina Svistkova on 05.04.2021.
//

import Foundation

struct RepositoriesData: Codable {
    let name: String
    let repoURL: String
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case repoURL = "html_url"
    }
}

struct Owner: Codable {
    let profilePicture: String

    enum CodingKeys: String, CodingKey {
        case profilePicture = "avatar_url"
    }
}
