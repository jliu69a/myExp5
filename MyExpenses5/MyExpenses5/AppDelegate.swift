//
//  AppDelegate.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/16/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var paymentsList: [Payment] = []
    var vendorsList: [Vendor] = []
    var top10sList: [Top10] = []
    
    var vendorDisplayTitles: [String] = []
    var vendorDisplayData: [String: AnyObject] = [:]
    
    var folder: String = "prods" //production use

    var filmLanguagesList: [FilmSelection] = []
    var filmTypesList: [FilmSelection] = []
    var filmGenresList: [FilmSelection] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

