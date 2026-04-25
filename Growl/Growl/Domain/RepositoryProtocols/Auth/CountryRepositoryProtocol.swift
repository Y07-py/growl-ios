//
//  CountryRepositoryProtocol.swift
//  Growl
//
//  Created by Antigravity on 2026/04/25.
//

import Foundation

public protocol CountryRepositoryProtocol {
    func fetchCountries() throws -> [Country]
}
