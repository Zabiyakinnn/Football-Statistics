//
//  MatchViewController.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 15.10.2024.
//

import UIKit

final class MatchViewController: UIViewController {
    
    var matchResponse: MatchesResponce?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    func updateWithData(_ data: MatchesResponce) {
        self.matchResponse = data
    }
}
