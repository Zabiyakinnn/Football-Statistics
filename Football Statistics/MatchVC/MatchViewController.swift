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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(MatchCell.self, forCellReuseIdentifier: "matchCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    func updateWithData(_ data: MatchesResponce) {
        DispatchQueue.main.async {
            self.matchResponse = data
            self.tableView.reloadData()
        }
    }
}

//MARK: - SetupContraint
extension MatchViewController {
    private func setupConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
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
