//
//  MatchViewController.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 15.10.2024.
//

import UIKit
import SnapKit

final class MatchViewController: UIViewController {
    
    var matchResponse: MatchesResponce?
    let matchCell = "matchCell"
    var dates: [DateModel] = []
    var sport: [Sport] = []
    let dateCollectionCell = "dateCollectionCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(MatchCell.self, forCellReuseIdentifier: "matchCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        dates = generateDates()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.dataSource = self
        collectionVIew.delegate = self
        collectionVIew.register(DateCollectionCell.self, forCellWithReuseIdentifier: "dateCollectionCell")
        return collectionVIew
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
    }
    
    func updateWithData(_ data: MatchesResponce) {
        DispatchQueue.main.async {
            self.matchResponse = data
            self.tableView.reloadData()
        }
    }
    
    func generateDates() -> [DateModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM."
        
        let calendar = Calendar.current
        var dates: [DateModel] = []
        let today = Date()
        let days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i, to: today)!
            let day = dateFormatter.string(from: date) // преобразуем дату в строку
            let dayOfWeekIndex = calendar.component(.weekday, from: date) - 1 // опеределить день недели и скорректировать на -1 для соответствия индксу массива
            let dayOfweek = days[dayOfWeekIndex] // извлекаем название дня недели по индексу
            let isToday = (i == 0) // является ли текущая дата сегодняшней
            
            dates.append(DateModel(dayOfWeek: dayOfweek, day: day, isToday: isToday))
        }
        return dates
    }
}

//MARK: - SetupContraint
extension MatchViewController {
    private func setupConstraint() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.top).offset(70)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.top.equalToSuperview().offset(74)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension MatchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchResponse?.competitions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: matchCell, for: indexPath) as? MatchCell else {
            return UITableViewCell()
        }
        
        guard let items = matchResponse?.competitions, items.count > indexPath.row else {
            return UITableViewCell()
        }
        
        let competitionMatch = items[indexPath.row]
        cell.configureCompetition(competitionMatch)
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MatchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCollectionCell", for: indexPath) as? DateCollectionCell else {
            return UICollectionViewCell()
        }
        let dateModel = dates[indexPath.row]
        cell.configure(with: dateModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDate = dates[indexPath.row]
        print("Кол-во элементов sport: \(sport.count). Индекс: \(indexPath.row)")
        guard indexPath.row < sport.count else {
            print("Индекс выходит за пределы массива")
            return
        }
        
        let selectedSport = sport[indexPath.row]
        let sportId = selectedSport.id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM"
        
        if let formattedData = dateFormatter.date(from: selectedDate.day) {
            let endDate = dateFormatter.string(from: formattedData)
            
            NetworkService.shared.fetchMatches(for: sportId, endDate: endDate) { [weak self] matchResponse in
                DispatchQueue.main.async {
                    if let matchResponce = matchResponse {
                        self?.tableView.reloadData()
                    } else {
                        print("Ошибка")
                    }
                }
            }
        } else {
            print("Ошибка форматирования даты")
        }
    }
}
