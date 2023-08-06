//
//  NASADataProvider.swift
//  MarsWeather
//
//  Created by Will Paceley on 2023-08-04.
//

import Foundation

struct NASADataProvider: MarsWeatherDataProvider {
    private var NASA_API_URL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "mars.nasa.gov"
        components.path = "/rss/api/"
        components.queryItems = [
            URLQueryItem(name: "feed", value: "weather"),
            URLQueryItem(name: "category", value: "msl"),
            URLQueryItem(name: "feedtype", value: "json")
        ]
        
        return components.url
    }
    
    func getMarsWeatherData() async throws -> MarsWeatherData {
        guard let url = NASA_API_URL else {
            throw MWError.invalidURL
        }
        
        print("Fetching weather data from NASA API.")
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let weatherData = try JSONDecoder().decode(MarsWeatherData.self, from: data)
            return weatherData
        } catch {
            throw MWError.invalidData
        }
    }
}
