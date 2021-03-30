//
//  ViewController.swift
//  COVIDTracker
//
//  Created by David Im on 23/3/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    private var covidData = [DataModel(active: 0, todayCases: 0, todayRecovered: 0, deaths: 0, todayDeaths: 0, flagURL: "")]
    private var dataManager = DataManager()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "COVIDTracker"
    
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = 120
        countryFlagImageView.layer.cornerRadius = countryFlagImageView.frame.height/2
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .none
        dataManager.delegate = self
        setupLocationManager()
        
        //tableView.translatesAutoresizingMaskIntoConstraints = false
//        let window = UIApplication.shared.windows[0]
//        let topPadding = window.safeAreaInsets.top
//        let bottomPadding = window.safeAreaInsets.bottom
//        let safeAreaSize = topPadding + bottomPadding
//        let screenSizeWithoutSafeArea = (UIScreen.main.bounds.height - safeAreaSize)
//        let tableViewSize = screenSizeWithoutSafeArea - 259 //231
//        tableView.heightAnchor.constraint(equalToConstant: 380).isActive = true
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
} // End of class

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.tableViewCell) as! TableViewCell
        if indexPath.row == 0 {
            cell.background.backgroundColor = UIColor.universalYellow
            cell.caseNumberLabel.text = String(covidData[0].active)
            cell.newCaseNumberLabel.text = "+\(String(covidData[0].todayCases))"
            cell.caseTitleLabel.text = "cases"
            cell.signImageView.image = UIImage(named: C.newCaseIcon)
        } else if indexPath.row == 1 {
            cell.background.backgroundColor = UIColor.universalGreen
            cell.caseNumberLabel.text = String(covidData[0].todayRecovered)
            cell.caseTitleLabel.text = "recovered"
            cell.signImageView.image = UIImage(named: C.recoverIcon)
            cell.newCaseNumberLabel.alpha = 0
        } else {
            cell.background.backgroundColor = UIColor.universalRed
            cell.caseNumberLabel.text = String(covidData[0].deaths)
            cell.newCaseNumberLabel.text = "+ \(String(covidData[0].todayDeaths))"
            cell.caseTitleLabel.text = "died"
            cell.signImageView.image = UIImage(named: C.deathIcon)
        }
        return cell
    }
}

extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            getLocationCountryName(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlertBox(description: "Cannot get the current location")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse: locationManager.requestLocation()
        case .denied: covidData = [DataModel(active: 0, todayCases: 0, todayRecovered: 0, deaths: 0, todayDeaths: 0, flagURL: "")]
        case .restricted: covidData = [DataModel(active: 0, todayCases: 0, todayRecovered: 0, deaths: 0, todayDeaths: 0, flagURL: "")]
        case .authorizedAlways: locationManager.requestLocation()
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        default: covidData = [DataModel(active: 0, todayCases: 0, todayRecovered: 0, deaths: 0, todayDeaths: 0, flagURL: "")]
        }
    }
    
    func setupLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        } else {
            showAlertBox(description: "Please enable location service")
        }

    }
    
    func getLocationCountryName(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                self.showAlertBox(description: error.localizedDescription)
            }
            
            guard let placemark = placemarks?.first else {return}
            if let country = placemark.country {
                self.dataManager.performRequest(country: country)
            } else {
                self.showAlertBox(description: "Cannot get country name")
            }
        }
    }
    
    func showAlertBox(description:String) {
        let controllerBox = UIAlertController(title: "Oops", message: description, preferredStyle: .alert)
        controllerBox.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(controllerBox, animated: true, completion: nil)
    }
}

extension ViewController:DataManagerDelegate {
    func didUpdateCovidData(data: DataModel) {
        covidData.removeFirst()
        self.covidData.append(data)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}




