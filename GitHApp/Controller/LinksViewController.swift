//
//  ViewController.swift
//  GitHApp
//
//  Created by Marina Svistkova on 05.04.2021.
//

import UIKit
import SnapKit

class LinksViewController: UIViewController {

    private let networkingManager: NetworkingServiceProtocol
    private var cells = [RepositoriesModel]()
    private var timer: Timer?
    private let searchController = UISearchController(searchResultsController: nil)

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchData()
    }

    init (networkingService: NetworkingServiceProtocol) {
        self.networkingManager = networkingService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fetchData() {

        networkingManager.getResults(description: "octokit") { [weak self] result in
            switch result {
            case .success(let results):
                self?.cells = results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }

    private func configure() {
        setupSubviews()
        setupUI()
        setupConstraints()
        setupSearchBar()
    }

    private func setupUI() {
        view.backgroundColor = .white
    }

    private func setupSubviews() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {

        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


extension LinksViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.identifier, for: indexPath) as! InfoCell
        cell.accessoryType = .disclosureIndicator

        let item = cells[indexPath.row]
        cell.cellData = item
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let url = URL(string: cells[indexPath.row].repoURL) {
            UIApplication.shared.open(url)
        }
    }

    private func setupSearchBar() {

        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.delegate = self
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .black
        textFieldInsideSearchBar?.placeholder = "type company, e.g. octokit"
    }



    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {

        if let companyName = searchController.searchBar.text {
            timer?.invalidate()

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in

                self.networkingManager.getResults(description: companyName) { [weak self] result in
                    switch result {
                    case .success(let results):
                        print(results)
                        self?.cells = results

                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: error.rawValue, message: nil, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(ac, animated: true)
                        }
                        print(error)
                    }
                }
            })
        }
    }
}

