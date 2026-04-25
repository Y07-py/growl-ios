//
//  LocalCountryRepository.swift
//  Growl
//
//  Created by Antigravity on 2026/04/25.
//

import Foundation

public final class LocalRepository {
    static let shared = LocalRepository()
    
    public init() {}
}

extension LocalRepository: CountryRepositoryProtocol {
    public func fetchCountries() throws -> [Country] {
        guard let url = Bundle.main.url(forResource: "CountryData", withExtension: "json") else {
            throw NSError(domain: "LocalCountryRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "CountryData.json not found in bundle"])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Country].self, from: data)
    }
}
