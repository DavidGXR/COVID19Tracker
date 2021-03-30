//
//  DataManager.swift
//  COVIDTracker
//
//  Created by David Im on 25/3/21.
//

import Foundation

protocol DataManagerDelegate {
    func didUpdateCovidData (data: DataModel)
}

struct DataManager {
    
    var delegate:DataManagerDelegate?
    
    func performRequest(country: String) {
        // Create URL
        if let url = URL(string: "https://disease.sh/v3/covid-19/countries/\(country)?strict=true") {
            // Create browser
            let session = URLSession(configuration: .default)
            
            // Give browser a task to do
            let task = session.dataTask(with: url) { (data, response, error) in
                // Check if there are any error while trying to access the api
                if (error != nil) {
                    print(error!)
                    return
                } else {
                    if let safeData = data {
                        if let actualData = paraseJSON(data: safeData) {
                            self.delegate?.didUpdateCovidData(data: actualData)
                            //print("This is: \(actualData.active)")
                        }
                    }
                }
            }
            // Start task
            task.resume()
        }
        
    }
    
    private func paraseJSON(data: Data) -> DataModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidData.self, from: data)
            // Get all the necessary data
            let active          = decodedData.active
            let todayCases      = decodedData.todayCases
            let todayRecovered  = decodedData.todayRecovered
            let deaths          = decodedData.deaths
            let todayDeaths     = decodedData.todayDeaths
            let flagURL         = decodedData.countryInfo.flag
         
            let covidData       = DataModel(active: active, todayCases: todayCases, todayRecovered: todayRecovered, deaths: deaths, todayDeaths: todayDeaths, flagURL: flagURL)
            return covidData
            
        } catch {
            print(error)
            return nil
        }
    }
}
