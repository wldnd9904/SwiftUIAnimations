//
//  ImageFetcher.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import Foundation
import SwiftUI

public struct PexelAPI:Codable {
    let total_results: Int
    let page: Int
    let per_page: Int
    let photos: [PhotoAPI]
    let prev_page: String?
    let next_page: String?
}

public struct PhotoAPI:Codable {
    let id: Int
    let width: CGFloat
    let height: CGFloat
    let url: String
    let photographer: String
    let photographer_url: String
    let photographer_id: Int
    let avg_color: String
    let src:ImageSet
    let liked: Bool
    let alt: String
    func toPhoto()->Photo {
        return Photo(id: id, width: width, height: height, photographer: photographer, avgColor: Color(hex:avg_color), imageSet: src, liked: liked, desc: alt)
    }
}

struct DataFetcher {
    enum PexelError: Error {
        case invalidURL
        case noData
        case decodingError
    }
    
    static func searchPhotos(query: String,
                      orientation: String? = nil,
                      size: String? = nil,
                      color: String? = nil,
                      locale: String? = nil,
                      page: Int? = nil,
                      perPage: Int? = nil,
                      completion: @escaping (Result<PexelAPI, Error>) -> Void) {
        
        var components = URLComponents(string: "https://api.pexels.com/v1/search")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "orientation", value: orientation),
            URLQueryItem(name: "size", value: size),
            URLQueryItem(name: "color", value: color),
            URLQueryItem(name: "locale", value: locale),
            URLQueryItem(name: "page", value: page.map { String($0) }),
            URLQueryItem(name: "per_page", value: perPage.map { String($0) })
        ]
        guard let url = components?.url else {
            completion(.failure(PexelError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("7JjUiVYAbS6H8tQtKKAGj0MHpmxGJ3ST1YrpfjfGGEyGJtMbqmhTyHek", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? PexelError.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let pexelAPI = try decoder.decode(PexelAPI.self, from: data)
                completion(.success(pexelAPI))
            } catch {
                completion(.failure(PexelError.decodingError))
            }
        }.resume()
    }
}
