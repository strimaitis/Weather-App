//
//  HomeViewController.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/8/23.
//

import CoreLocation
import OSLog
import SwiftUI
import UIKit

class HomeViewController: UIViewController {
    private var homeModel = Home()
    private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        locationManager.delegate = self
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        setupContentView()
    }

    private func setUp() {
        let action = UIAction(title: "Search") { (action) in
            self.performSegue(withIdentifier: "searchSegue", sender: nil)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .search, primaryAction: action)
    }

    private func setupContentView() {
        let contentView = UIHostingController(rootView: HomeView(homeModel: homeModel))
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

    private func loadLocation(_ location: CLLocation) {
        DispatchQueue.global(qos: .userInitiated).async {
            JSONDecoder.shared.decode([Location].self, urlString: "https://api.openweathermap.org/geo/1.0/reverse?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=514c4229b0a9f483bc4a6f6558973717") { result in
                switch result {
                case .success(let location):
                    guard let apiSearchText = location.first?.name.getFormattedJSONParameter() else {
                        return
                    }
                    JSONDecoder.shared.decode(City.self, urlString: "https://api.openweathermap.org/data/2.5/weather?q=\(apiSearchText)&appid=514c4229b0a9f483bc4a6f6558973717") { result in
                        switch result {
                            case .success(let city):
                            city.getImageData { data in
                                DispatchQueue.main.async {
                                    if let data {
                                        city.imageData = data
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.homeModel.currentLocation = city
                            }
                            CitiesData.saveLocation(city: city) { _ in
                                    
                                }
                            case .failure(let error):
                                os_log("ERROR: %@", log: .default, type: .error, String(describing: error))
                        }
                    }
                case .failure(let error):
                    os_log("ERROR: %@", log: .default, type: .error, String(describing: error))
                }
            }
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // If location sharing is authorized load city based on location coordinates
        if ((locationManager.authorizationStatus == .authorizedWhenInUse) || (locationManager.authorizationStatus == .authorizedAlways)) {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location {
            loadLocation(location)
            locationManager.stopUpdatingLocation()
        }
    }
}
