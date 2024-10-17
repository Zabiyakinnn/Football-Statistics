//
//  MatchCell.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 16.10.2024.
//

import UIKit
import SnapKit

final class MatchCell: UITableViewCell {
    
    private lazy var nameMatch: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var imageChampionship: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var matchLive: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private lazy var matchTotal: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private lazy var seperatorIliveGemes: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        view.layer.cornerRadius = 6
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameMatch)
        contentView.addSubview(matchTotal)
        contentView.addSubview(seperatorIliveGemes)
        contentView.addSubview(imageChampionship)
        
        seperatorIliveGemes.addSubview(matchLive)
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCompetition(_ competition: Competition) {
        nameMatch.text = competition.name
        matchLive.text = "\(competition.liveGames ?? 0)"
        matchTotal.text = "\(competition.totalGames ?? 0)"
        
        if let imageURl = competition.imageURL {
            NetworkService.shared.loadImage(from: imageURl) { image in
                DispatchQueue.main.async {
                    self.imageChampionship.image = image
                }
            }
        }
    }
}

extension MatchCell {
    private func setupConstaints() {
        nameMatch.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(60)
            make.right.equalTo(contentView.snp.right).offset(-88)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        imageChampionship.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(18)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(26)
        }
        matchTotal.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-25)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        seperatorIliveGemes.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-55)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(28)
            make.height.equalTo(22)
        }
        matchLive.snp.makeConstraints { make in
            make.center.equalTo(seperatorIliveGemes)
        }
    }
}
