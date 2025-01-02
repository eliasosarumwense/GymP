//
//  Test.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//

import SwiftUI

import UIKit

class ViewController: UIViewController {
    let myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, World!"
        // Setting the font style
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

#Preview {
    ViewController()
}
