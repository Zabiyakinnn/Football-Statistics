//
//  ViewController.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 11.10.2024.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NetworkService.shared.fetchData()
    }


}

