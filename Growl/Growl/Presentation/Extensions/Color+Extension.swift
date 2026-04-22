//
//  Color+Extension.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/23.
//

import Foundation
import SwiftUI

extension Color {
    static var mainColor: Color {
        guard let uiColor = UIColor(hex: "FF3737", alpha: 1.0) else { return .clear }
        return self.init(uiColor: uiColor)
    }
    
    static var backgroundColor: Color {
        guard let uiColor = UIColor(hex: "F6F1E9", alpha: 1.0) else { return .clear }
        return self.init(uiColor: uiColor)
    }
}
