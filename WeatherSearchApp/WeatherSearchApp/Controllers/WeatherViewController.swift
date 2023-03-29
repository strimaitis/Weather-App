//
//  WeatherViewController.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/8/23.
//

import SwiftUI
import UIKit

class WeatherViewController: UIViewController {
    @ObservedObject var city: City
    
    public init(_ city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUpPresentation()
        setupContentView()
    }

    private func setUpPresentation() {
        sheetPresentationController?.detents = [
            UISheetPresentationController.Detent.medium()
        ]
        sheetPresentationController?.prefersGrabberVisible = true
    }

    private func setupContentView() {
        let contentView =  UIHostingController(rootView: WeatherView(city: city))
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

