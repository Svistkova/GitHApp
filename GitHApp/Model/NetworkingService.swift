//
//  NetworkingService.swift
//  GitHApp
//
//  Created by Marina Svistkova on 05.04.2021.
//

import Foundation
import Alamofire

protocol NetworkingServiceProtocol {
    func getResults(description: String, completed: @escaping (Result<[RepositoriesModel], ErrorMessage>) -> Void)
}

struct NetworkingService: NetworkingServiceProtocol {

    func getResults(description: String, completed: @escaping (Result<[RepositoriesModel], ErrorMessage>) -> Void) {
        let urlString = "https://api.github.com/orgs/\(description.replacingOccurrences(of: " ", with: ""))" + "/repos"

        // Networking with Alamofire
        AF.request(urlString).responseDecodable(of: [RepositoriesData].self) { response in
            switch response.result {
            case .success(let results):
                let resultsModel: [RepositoriesModel] = results.map { result in
                    let resultModel = RepositoriesModel(
                        repoName: result.name,
                        repoURL: result.repoURL,
                        avatarURL: result.owner.profilePicture
                    )
                    return resultModel
                }
                completed(.success(resultsModel))
            case .failure(_):
                completed(.failure(.invalidResponse))
            }
        }

        // networking with URLSession

//        guard let url = URL(string: urlString) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let _ = error {
//                completed(.failure(.invalidData))
//                return
//            }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//            do {
//                let deconder = JSONDecoder()
//                let results = try deconder.decode([RepositoriesData].self, from: data)
//                let resultsModel: [RepositoriesModel] = results.map { result in
//                    let resultModel = RepositoriesModel(
//                        repoName: result.name,
//                        repoURL: result.repoURL,
//                        avatarURL: result.owner.profilePicture
//                    )
//                    return resultModel
//                }
//                completed(.success(resultsModel))
//
//            } catch {
//                completed(.failure(.invalidData))
//            }
//        }
//        task.resume()
    }
}

