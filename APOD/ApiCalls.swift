//
//  ApiCalls.swift
//  APOD
//
//  Created by rodrigo Orozco  on 2/27/24.
//

import Foundation

enum CallError: Error {
    case invalidURL
    case invalidResponse
    case fileNotFound
    case contentError
}

struct APOD: Decodable {
    let date: String
    let explanation: String
    let url: String
    let title: String
    let media_type: String
    
    /* dummy constructor, allows the object to be used in content view
       as a private variable, get initlized after network call. Dummy values
       are displayed until call is carried out succesfully. Choose better values?
    */
    init()  {
        date = "---"
        explanation = "-"
        url = "___"
        title = "-"
        media_type = "x"
    }
}

func fetchAPIKEY() throws -> String {
    guard let file = Bundle.main.url(forResource: "apiKey", withExtension: ".txt") else {
        throw CallError.fileNotFound
    }
    
    do {
        var key = try String(contentsOf: file, encoding: String.Encoding.utf8)
        key.remove(at: key.index(before: key.endIndex)) // removes new line char from string txt file
        return key
    } catch {
        throw CallError.contentError
    }

}

func fetchAPOD() async throws -> APOD  {
    let apiKey = try fetchAPIKEY()
    let endpoint = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
    
    guard let url = URL(string: endpoint) else {
        throw CallError.invalidURL
    }
    
    let (data, code) = try await URLSession.shared.data(from: url)
    
    let response = code as? HTTPURLResponse
    guard response?.statusCode == 200 else {
        print(apiKey)
        throw CallError.invalidResponse
    }

    let decoded = try JSONDecoder().decode(APOD.self, from: data)
    
    return decoded
}

