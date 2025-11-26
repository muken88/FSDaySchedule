//
//  UIEdgeInsets+FSExtension.swift
//  FSDaySchedule

//
//  Created by liaoyu on 2025/11/25.
//

import UIKit

internal extension UIEdgeInsets {
    var horizontal: CGFloat {
        return self.left + self.right
    }
    var vertical: CGFloat {
        return self.top + self.bottom
    }
}
