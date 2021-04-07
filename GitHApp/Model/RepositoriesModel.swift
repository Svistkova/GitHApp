//
//  RepositoriesModel.swift
//  GitHApp
//
//  Created by Marina Svistkova on 05.04.2021.
//

import Foundation

struct RepositoriesModel: Decodable {
    let repoName: String
    let repoURL: String
    let avatarURL: String
}
