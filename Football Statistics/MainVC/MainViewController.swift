//
//  ViewController.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 11.10.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private var sportName: [Sport] = []
    var mainSportCollection = "mainSportCollection"
    let todayDate = Date()
    let dateFormatter = DateFormatter()

    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10 // расстояние между элементами
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 70) // размер элемента
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(MainSportCollection.self, forCellWithReuseIdentifier: "mainSportCollection")
        collectionView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        title = "Sport Result"
        collectionView.delegate = self
        collectionView.dataSource = self
        setupLayout()
        configureItem()
        request()
    }

    private func request() {
        activityIndicator.startAnimating()
        NetworkService.shared.fetchData { [weak self] data in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard let self else { return }
                self.sportName = data.sports.map { sport in
                    var mutableSport = sport
                    let sportNameForURL = sport.nameForURL.lowercased()
                    switch sportNameForURL {
                    case "football":
                        mutableSport.imageSystemName = "soccerball"
                    case "basketball":
                        mutableSport.imageSystemName = "basketball"
                    case "tennis":
                        mutableSport.imageSystemName = "tennisball"
                    case "hockey":
                        mutableSport.imageSystemName = "hockey.puck"
                    case "a.-football":
                        mutableSport.imageSystemName = "football"
                    case "rugby":
                        mutableSport.imageSystemName = "figure.rugby"
                    case "handball":
                        mutableSport.imageSystemName = "figure.handball"
                    case "cricket":
                        mutableSport.imageSystemName = "cricket.ball"
                    case "baseball":
                        mutableSport.imageSystemName = "baseball"
                    case "volleyball":
                        mutableSport.imageSystemName = "volleyball"
                    default:
                        mutableSport.imageSystemName = "questionmark.circle"
                    }
                    return mutableSport
                }
                self.collectionView.reloadData()
            }
        }
    }

    private func configureItem() {
        let favorites = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped))
        
        let search = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoritesButtonTapped))
        
        navigationItem.rightBarButtonItems = [favorites, search]
    }
    
    @objc private func searchButtonTapped() {
        print("поиск")
    }
    
    @objc private func favoritesButtonTapped() {
        print("избранное")
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainSportCollection, for: indexPath) as! MainSportCollection
        let item = sportName[indexPath.row]
        cell.configure(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSport = sportName[indexPath.row]
        let sportId = selectedSport.id
        print("Кол-во sportName ---- \(sportName.count)")
        
        dateFormatter.dateFormat = "EEEE d MMMM"
        dateFormatter.locale = Locale(identifier: "eu_US")
        let formatterDate = dateFormatter.string(from: todayDate)
        
        let endDate = formatterDate
        
        let matchVC = MatchViewController()
        matchVC.activityIndicator.startAnimating()
        self.navigationController?.pushViewController(matchVC, animated: true)
        
        NetworkService.shared.fetchMatches(for: sportId, endDate: endDate) { [weak self] matchResponce in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let matchResponce = matchResponce {
                    matchVC.title = selectedSport.name
                    matchVC.updateWithData(matchResponce)
                    matchVC.activityIndicator.stopAnimating()
                    print(matchResponce.competitions)
                } else {
                    print("Ошибка. Не удалось получить данные")
                }
            }
        }
    }
}

private extension MainViewController {
    private func setupLayout() {
        prepareView()
        setupeConstraint()
    }
    func prepareView() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
    func setupeConstraint() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.bottom.equalToSuperview()
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

