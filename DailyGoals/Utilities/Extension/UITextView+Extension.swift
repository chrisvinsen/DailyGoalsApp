//
//  UITextView+Extension.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import Foundation
import UIKit

@IBDesignable extension UITextView {

    @IBInspectable var topPadding: CGFloat {
        get {
            return contentInset.top
        }
        set {
            self.contentInset = UIEdgeInsets(top: newValue,
                                             left: self.contentInset.left,
                                             bottom: self.contentInset.bottom,
                                             right: self.contentInset.right)
        }
    }

    @IBInspectable var bottomPadding: CGFloat {
        get {
            return contentInset.bottom
        }
        set {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top,
                                             left: self.contentInset.left,
                                             bottom: newValue,
                                             right: self.contentInset.right)
        }
    }

    @IBInspectable var leftPadding: CGFloat {
        get {
            return contentInset.left
        }
        set {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top,
                                             left: newValue,
                                             bottom: self.contentInset.bottom,
                                             right: self.contentInset.right)
        }
    }

    @IBInspectable var rightPadding: CGFloat {
        get {
            return contentInset.right
        }
        set {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top,
                                             left: self.contentInset.left,
                                             bottom: self.contentInset.bottom,
                                             right: newValue)
        }
    }
}
