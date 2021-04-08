//
//  NetworkingService.swift
//  GitHApp
//
//  Created by Marina Svistkova on 05.04.2021.
//

import Foundation
import Alamofire
import Moya

protocol NetworkingServiceProtocol {
    func getResults(description: String, completed: @escaping (Result<[RepositoriesModel], ErrorMessage>) -> Void)
}

enum CompaniesServiceMoya {
    case readProjects(name: String)
}

extension CompaniesServiceMoya: TargetType {
    var baseURL: URL {
        let url = URL(string: "https://api.github.com/orgs/")!
        return url
    }

    var path: String {
        switch self {
        case .readProjects(let name):
            return "\(name.replacingOccurrences(of: " ", with: ""))" + "/repos"
        }
    }

    var method: Moya.Method {
        switch self {
        case .readProjects(_):
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .readProjects(_):
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return nil
    }
}


struct NetworkingService: NetworkingServiceProtocol {

    let userProvider = MoyaProvider<CompaniesServiceMoya>()

    func getResults(description: String, completed: @escaping (Result<[RepositoriesModel], ErrorMessage>) -> Void) {

        //MARK: -  Networking with Moya

        userProvider.request(.readProjects(name: description)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let decodedResults = try JSONDecoder().decode([RepositoriesData].self, from: response.data)
                    let resultsModel: [RepositoriesModel] = decodedResults.map { result in
                        let resultModel = RepositoriesModel(
                            repoName: result.name,
                            repoURL: result.repoURL,
                            avatarURL: result.owner.profilePicture
                        )
                        return resultModel
                    }
                    completed(.success(resultsModel))
                } catch {
                    completed(.failure(.invalidData))
                }
            case .failure(_):
                completed(.failure(.invalidResponse))
            }
        }
        //MARK: - Networking with Alamofire
//        let urlString = "https://api.github.com/orgs/\(description.replacingOccurrences(of: " ", with: ""))" + "/repos"
//
//        AF.request(urlString).responseDecodable(of: [RepositoriesData].self) { response in
//            switch response.result {
//            case .success(let results):
//                let resultsModel: [RepositoriesModel] = results.map { result in
//                    let resultModel = RepositoriesModel(
//                        repoName: result.name,
//                        repoURL: result.repoURL,
//                        avatarURL: result.owner.profilePicture
//                    )
//                    return resultModel
//                }
//                completed(.success(resultsModel))
//            case .failure(_):
//                completed(.failure(.invalidResponse))
//            }
//        }

        //MARK: - networking with URLSession

//        let urlString = "https://api.github.com/orgs/\(description.replacingOccurrences(of: " ", with: ""))" + "/repos"
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

