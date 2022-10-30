//
//  UITextField+Extension.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 10/28/22.
//  Copyright © 2022 Home Office. All rights reserved.
//

import UIKit
import Combine

public extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        ).compactMap { ($0.object as? UITextField)?.text }.eraseToAnyPublisher()
    }
    
}
