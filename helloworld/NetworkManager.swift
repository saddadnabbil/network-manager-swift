//
//  NetworkManager.swift
//  helloworld
//
//  Created by Saddad Nabbil on 15/11/24.
//

import Foundation

// DataModel that matches the JSON structure from the API
struct DataModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class NetworkManager {
    func fetchData(completion: @escaping (Result<DataModel, Error>) -> Void) {
        // URL of the API endpoint (using JSONPlaceholder as an example)
        let urlString = "https://jsonplaceholder.typicode.com/posts/1"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        // Make a network request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }
            
            do {
                // Decode the JSON response into the DataModel structure
                let decodedData = try JSONDecoder().decode(DataModel.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the network request
        task.resume()
    }
}
