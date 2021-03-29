//
//  Data.swift
//  COVIDTracker
//
//  Created by David Im on 25/3/21.
//

import Foundation

struct CovidData: Decodable {
    let countryInfo: Country
    let active: Int
    let todayCases: Int
    let todayRecovered: Int
    let deaths: Int
    let todayDeaths: Int
}

struct Country: Decodable {
    let flag: String
}
