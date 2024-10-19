//
//  DateCollectionCell.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 19.10.2024.
//

import UIKit
import SnapKit

final class DateCollectionCell: UICollectionViewCell {
    
    private lazy var dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [dayOfWeekLabel, dayLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(with dateModel: DateModel) {
        dayOfWeekLabel.text = dateModel.dayOfWeek
        dayLabel.text = dateModel.day
        
//        выделяем сегодняшний день
        if dateModel.isToday {
            dayLabel.textColor = UIColor.systemRed.withAlphaComponent(0.9)
        } else {
            dayLabel.textColor = .gray
        }
    }
}
