//
//  ViewController.swift
//  COVIDTracker
//
//  Created by David Im on 23/3/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    private var covidData = [DataModel(active: 0, todayCases: 0, todayRecovered: 0, deaths: 0, todayDeaths: 0, flagURL: "")]
    private var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "COVIDTracker"
    
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        countryFlagImageView.layer.cornerRadius = countryFlagImageView.frame.height/2
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .none
        
        //tableView.translatesAutoresizingMaskIntoConstraints = false
//        let window = UIApplication.shared.windows[0]
//        let topPadding = window.safeAreaInsets.top
//        let bottomPadding = window.safeAreaInsets.bottom
//        let safeAreaSize = topPadding + bottomPadding
//        let screenSizeWithoutSafeArea = (UIScreen.main.bounds.height - safeAreaSize)
//        let tableViewSize = screenSizeWithoutSafeArea - 259 //231
//        tableView.heightAnchor.constraint(equalToConstant: 380).isActive = true
        
        tableView.rowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataManager.delegate = self
        dataManager.performRequest()
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        dataManager.performRequest()
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

extension ViewController:DataManagerDelegate {
    func didUpdateCovidData(data: DataModel) {
        covidData.removeAll()
        self.covidData.append(data)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}




