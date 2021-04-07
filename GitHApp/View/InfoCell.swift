//
//  InfoCell.swift
//  GitHApp
//
//  Created by Marina Svistkova on 05.04.2021.
//

import UIKit
import Kingfisher

final class InfoCell: UITableViewCell {

    static let identifier = "InfoCell"

    var cellData: RepositoriesModel? {
        didSet {
            repositoryTitle.text = cellData?.repoName
            repositoryURL.text = cellData?.repoURL
            guard let url = URL(string: cellData?.avatarURL ?? "") else { return }
            logoImage.kf.setImage(with: url)
        }
    }

    private lazy var repositoryTitle: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.numberOfLines = 0
        return label
    }()

    private lazy var repositoryURL: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.numberOfLines = 0
        return label
    }()

    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photoM")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubviews(repositoryTitle, repositoryURL, logoImage)
    }

    private func setupConstraints() {

        logoImage.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(100)
        }

        repositoryTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(logoImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-30)
        }

        repositoryURL.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-30)
            make.leading.equalTo(logoImage.snp.trailing).offset(10)
            make.top.equalTo(repositoryTitle.snp.bottom).offset(10)
        }
    }
}



