//
//  Decoder+Extension.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/25.
//

import Foundation

extension Encodable {
    func asParameters() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
