//
//  Constants.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/8/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit


struct MEConstants {
    
    static let kHomePageStoryboardName = "expense"
    static let kPaymentsVendorsStoryboardName = "pandv"
    static let kAdminPagesStoryboardName = "admins"
    static let kExpenseLookupStoryboardName = "expense"
    static let kVendorLookupStoryboardName = "pandv"
    
    static let kHomePageStoryboardId = "MyExpHomeViewController"
    static let kChangeDateStoryboardId = "ChangeDateViewController"
    static let kEditExpenseStoryboardId = "EditExpensesViewController"
    static let kPaymentsVendorsStoryboardId = "PaymentsVendorsViewController"
    static let kAdminHomePageStoryboardId = "AdminHomeViewController"
    static let kExpsLookUpSelectStorboardId = "ExpsLookupSelectViewController"
    static let kVendorLookupStorybardId = "VendorsLookupViewController"
}


enum MEStoryboard {
    case home(MEHomePage), pv, admin(MEAdminsPage), expsLookupSelect, vendorLookup
    
    var board: UIStoryboard {
        switch self {
        case .home: return UIStoryboard(name: MEConstants.kHomePageStoryboardName, bundle: nil)
        case .pv: return UIStoryboard(name: MEConstants.kPaymentsVendorsStoryboardName, bundle: nil)
        case .admin: return UIStoryboard(name: MEConstants.kAdminPagesStoryboardName, bundle: nil)
        case .expsLookupSelect: return UIStoryboard(name: MEConstants.kExpenseLookupStoryboardName, bundle: nil)
        case .vendorLookup: return UIStoryboard(name: MEConstants.kVendorLookupStoryboardName, bundle: nil)
        }
    }
    
    var vc: UIViewController {
        switch self {
        case .home(let page): return self.board.instantiateViewController(identifier: page.vcId)
        case .pv: return self.board.instantiateViewController(identifier: MEConstants.kPaymentsVendorsStoryboardId)
        case .admin(let page): return self.board.instantiateViewController(identifier: page.vcId)
        case .expsLookupSelect: return self.board.instantiateViewController(identifier: MEConstants.kExpsLookUpSelectStorboardId)
        case .vendorLookup: return self.board.instantiateViewController(identifier: MEConstants.kVendorLookupStorybardId)
        }
    }
}


enum MEHomePage {
    case home, changeDate, saveExp
    
    var vcId: String {
        switch self {
        case .home: return MEConstants.kHomePageStoryboardId
        case .changeDate: return MEConstants.kChangeDateStoryboardId
        case .saveExp: return MEConstants.kEditExpenseStoryboardId
        }
    }
}


enum MEAdminsPage {
    case home
    
    var vcId: String {
        switch self {
        case .home: return MEConstants.kAdminHomePageStoryboardId
        }
    }
}

