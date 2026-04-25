//
//  CountryDTO.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/25.
//

import Foundation

public struct CountryDTO: Identifiable, Equatable, Hashable {
    public let id: String
    public let dialCode: String
    public let emoji: String
    public let countryCode: String
}
