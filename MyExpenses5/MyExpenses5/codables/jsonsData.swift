//
//  jsonsData.swift
//  MyTest6
//
//  Created by Johnson Liu on 7/14/20.
//  Copyright © 2020 Johnson Liu. All rights reserved.
//

import UIKit


//MARK: - mappings

public struct MyExpsData: Codable {
    var expense : [Expense]?
    var payments : [Payment]?
    var top10 : [Top10]?
    var vendors : [Vendor]?
}

public struct EditMyExpsData: Codable {
    var expense: [Expense]?
    var top10: [Top10]?
}

public struct ChangePVData: Codable {
    var payments: [Payment]?
    var vendors: [Vendor]?
}

public struct StatesData: Codable {
    var code : String?
    var name : String?
}


//MARK: - types define

public struct Vendor: Codable {
    var id : String?
    var vendor : String?
}

public struct Top10: Codable {
    var id : String?
    var total : String?
    var vendor : String?
}

public struct Payment: Codable {
    var id : String?
    var payment : String?
}

public struct Expense: Codable {
    var amount : String?
    var date : String?
    var id : String?
    var note : String?
    var payment : String?
    var payment_id : String?
    var time : String?
    var vendor : String?
    var vendor_id : String?
}

//MARK: - films

public struct FilmsData: Codable {
    var languages : [FilmSelection]?
    var types : [FilmSelection]?
    var genres : [FilmSelection]?
    var films : [Film]?
}

public struct FilmSelection: Codable {
    var id: String?
    var name: String?
}

public struct Film: Codable {
    var id: String?
    var title: String?
    var year: String?
    var watch_date: String?
    var language_code: String?
    var language: String?
    var type_code: String?
    var type: String?
    var genre_code: String?
    var genre: String?
    var notes: String?
}

//MARK: - testing

public struct HomeTest: Encodable {
    var name: String
    var value: String
    var notes: String
}

