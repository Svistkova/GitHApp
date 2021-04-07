//
//  ErrorMessages.swift
//  GitHApp
//
//  Created by Marina Svistkova on 06.04.2021.
//

import Foundation


enum ErrorMessage: String, Error {
    case invalidData = "Sorry. Something went wrong, try again"
    case invalidResponse = "Incorrect request. Please modify your search and try again"
}
