//
//  SearchViewController.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/7/23.
//

import OSLog
import UIKit

class SearchViewController: UITableViewController {
    var sections = ["Search", "Previous Searches"]

    var cities: Cities = Cities()
    var keywordMatchingCities: [String] = []

    var searchText: String?
    var searchController = UISearchController(searchResultsController: nil)

    var cellIdentifier: String = "SearchResultTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        CitiesData.loadCities { result in
            switch result {
                case .success(let cities):
                    self.cities = cities
                case .failure(let error):
                    os_log("ERROR: %@", log: .default, type: .error, String(describing: error))
            }
        }
    }

    deinit {
        CitiesData.save(cities: cities) { result in
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    os_log("ERROR: %@", log: .default, type: .error, String(describing: error))
            }
        }
    }

    private func setUp() {
        // Register custom cell type, connect tableView delegate, conect searchController with searchBar to navigationItem
        navigationItem.title = nil
        tableView.delegate = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorColor = .label
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let searchText, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return 0
        }
        return keywordMatchingCities.count > 0 ? sections.count : 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            default:
                return keywordMatchingCities.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultTableViewCell else {
                return UITableViewCell()
            }
            cell.headerLabel.text = "Search for '\( searchController.searchBar.text ?? "")'"
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.headerLabel.text = keywordMatchingCities[indexPath.row]
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var apiSearchText = indexPath.section == 0 ? searchText! : keywordMatchingCities[indexPath.row]
        
        // If data is already loaded...
        if let city = cities.cityDict[apiSearchText] {
            self.presentViewController(city)
            return
        }

        apiSearchText = apiSearchText.getFormattedJSONParameter()

        DispatchQueue.global(qos: .userInteractive).async {
            // If data needs to be loaded...
            JSONDecoder.shared.decode(City.self, urlString: "https://api.openweathermap.org/data/2.5/weather?q=\(apiSearchText),US&appid=514c4229b0a9f483bc4a6f6558973717") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        // Generic alert for user.  City is not found.
                        let alert = UIAlertController(title: "Error", message: "Could not find city with name \(apiSearchText) in US", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: false)

                        // Console log for debugging
                        os_log("ERROR: %@", log: .default, type: .error, String(describing: error))
                    case .success(let city):
                        self.saveAndLoad(city: city)
                        self.presentViewController(city)
                    }
                }
            }
        }
    }

    private func saveAndLoad(city: City) {
        // Save city and load it into cities dictionary
        CitiesData.save(city: city) {_ in
            CitiesData.loadCity { result in
                switch result {
                    case .success(let city):
                        self.cities.cityDict[city.name] = city
                    case .failure(let error):
                        os_log("ERROR: %@", log: .default, type: .error, String(describing: error))
                }
            }
        }
    }

    private func presentViewController(_ city: City) {
        // Update with image if preloaded
        city.getImageData { data in
            DispatchQueue.main.async {
                if let data {
                    city.imageData = data
                }
            }
        }

        // Present view controller
        let weatherViewController = WeatherViewController(city)
        self.present(weatherViewController, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Filter existing items in cities dictionary by search terms
        guard let text = searchController.searchBar.text else {
            return
        }
        keywordMatchingCities = cities.cityDict.keys.filter { $0.contains(text) }
        searchText = text
        tableView.reloadData()
    }
}
