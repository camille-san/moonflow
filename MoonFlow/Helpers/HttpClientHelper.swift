//
//  HttpClientHelper.swift
//  MoonFlow
//
//  Created by Camille on 26/3/24.
//

import Foundation

func performGETRequest(urlString: String, headers: [String: String], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        DispatchQueue.main.async {
            completion(data, response, error)
        }
    }
    task.resume()
}
