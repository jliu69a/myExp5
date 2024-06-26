//
//  FilmsHomeViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 4/4/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol FilmsHomeViewModelDelegate: class {
    func didLoadFilmsData()
}


class FilmsHomeViewModel {
    
    weak var delegate: FilmsHomeViewModelDelegate?
    
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    var totalSections: Int = 1
    var totalRows: Int = 0
    
    var filmsList: [Film] = []
    
    //MARK: - table view data
    
    func numberOfSectionis() -> Int {
        return self.totalSections
    }
    
    func numberOfRows(index: Int) -> Int {
        return self.totalRows
    }
    
    //MARK: - api, query films
    
    func loadingFilmData() {
        loadingFilms() {}
    }
    
    func loadingFilms(completion: @escaping () -> Void) {
        
        DatasManager.sharedInstance.loadFilmsData { [weak self] (rawData: Data) in
            let filmsList: [FilmsData] = self?.filmsData(data: rawData) ?? []
            self?.parseFilmsListData(filmsList: filmsList)
            completion()
        }
    }
    
    func filmsData(data: Data) -> [FilmsData] {
        
        let json = try? JSON(data: data)
        if json == nil {
            return []
        }
        
        var dataList: [FilmsData] = []
        do {
            dataList = try JSONDecoder().decode([FilmsData].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }
    
    //MARK: - parse json
    
    func parseFilmsListData(filmsList: [FilmsData]) {
        clearAllData()

        for each in filmsList {
            if each.films != nil {
                self.filmsList = each.films ?? []
            }
            if each.languages != nil {
                self.appDele.filmLanguagesList = each.languages ?? []
            }
            if each.types != nil {
                self.appDele.filmTypesList = each.types ?? []
            }
            if each.genres != nil {
                self.appDele.filmGenresList = each.genres ?? []
            }
        }
        self.totalRows = self.filmsList.count
        
        self.delegate?.didLoadFilmsData()
    }
    
    //MARK: - helpers
    
    func clearAllData() {
        self.filmsList.removeAll()
        self.appDele.filmLanguagesList.removeAll()
        self.appDele.filmTypesList.removeAll()
        self.appDele.filmGenresList.removeAll()
    }
    
}
