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

//MARK: - testing

public struct HomeTest: Encodable {
    var name: String
    var value: String
    var notes: String
}

