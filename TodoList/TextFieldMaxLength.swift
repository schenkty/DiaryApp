//
//  TextFieldMaxLength.swift
//  IdeaMate
//
//  Created by Ty Schenk on 9/4/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

// 1
private var maxLengths = [UITextField: Int]()

// 2
extension UITextField {
    
    // 3
    @IBInspectable var maxLength: Int {
        get {
            // 4
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            // 5
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControlEvents.editingChanged
            )
        }
    }
    
    func limitLength(_ textField: UITextField) {
        // 6
        guard let prospectiveText = textField.text, prospectiveText.characters.count > maxLength else { return }

        let selection = selectedTextRange

        // 7
        text = prospectiveText.substring(
            with: Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.characters.index(prospectiveText.startIndex, offsetBy: maxLength))
        )
        selectedTextRange = selection
    }
}
