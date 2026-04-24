//
//  View+Extension.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/24.
//

import Foundation
import SwiftUI

struct BaseShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func baseShadow() -> some View {
        modifier(BaseShadowModifier())
    }
}
