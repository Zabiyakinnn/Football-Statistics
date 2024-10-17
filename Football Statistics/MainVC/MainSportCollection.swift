//
//  MainSportCollection.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 11.10.2024.
//

import UIKit
import SnapKit

class MainSportCollection: UICollectionViewCell {
    
    private lazy var sportLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var sportImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        return imageView
    }()
    
    private lazy var sportLive: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private lazy var sportTotal: UILabel = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(sportLabel)
        contentView.addSubview(sportImageView)
        contentView.addSubview(seperatorIliveGemes)
        contentView.addSubview(sportTotal)
        seperatorIliveGemes.addSubview(sportLive)
        
        configureUI()
        setupeConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.white
        contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    func configure(_ sportItem: Sport) {
        sportLabel.text = sportItem.name
        sportLive.text = "\(sportItem.liveGames)" 
        sportTotal.text = "\(sportItem.totalGames)"
        
        if let systemName = sportItem.imageSystemName {
            if let image = UIImage(systemName: systemName) {
                sportImageView.image = image
            } else {
                sportImageView.image = UIImage(systemName: "questionmark.circle")
                print("Failed to load image for: \(systemName)") // Проверка неудачи загрузки изображения
            }
        } else {
            sportImageView.image = UIImage(systemName: "questionmark.circle")
            print("No image system name provided") // Проверка, если нет имени
        }
    }
}

extension MainSportCollection {
    private func setupeConstraint() {
        sportLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(70)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        sportImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(22)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(50)
            make.width.equalTo(28)
        }
        seperatorIliveGemes.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-55)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(28)
            make.height.equalTo(22)
        }
        sportLive.snp.makeConstraints { make in
            make.center.equalTo(seperatorIliveGemes)
        }
        sportTotal.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-25)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
}
