//
//  QueryService.swift
//  HalfTunes
//
//  Created by עלאא דאהר on 09/02/2020.
//  Copyright © 2020 עלאא דאהר. All rights reserved.
//

import Foundation

public class QueryService {
    
    //
    // MARK: - Constants
    //
     public static let shared = QueryService()
    
    //
    // MARK: - Variables and Properties
    //
     var dataTask : URLSessionDataTask?
     var tracks : [Track] = []
    //
    // MARK : - Type Alias
    ///
   public typealias  QueryResults = ([Track]?, NetworkError?) -> Void
    
    //
    // MARK: - Intilization
    //
     private init() {}
    
    //
    // MARK: - Internal Methods
    //
   
    
    public func getSearchResults(searchItem : String, mainQueue : DispatchQueue = DispatchQueue.main,  completionHandler : @escaping QueryResults) {
        dataTask?.cancel()
        var urlCompenents = URLComponents(string: Constants.API.MAIN_URL)
        urlCompenents?.query = "media=music&entity=song&term=\(searchItem)"
        
        guard let url = urlCompenents?.url else {
            mainQueue.async {
                completionHandler(nil, .invalidPath)
            }
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                mainQueue.async {
                    completionHandler(nil, .requestError(": \(error!.localizedDescription)"))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                mainQueue.async {
                    completionHandler(nil, .requestError(": response code \(response.statusCode)"))
                }
                return
            }
           
            if let data = data {
                
                do {
                    let jsonDecoder = JSONDecoder()
                   let results = try jsonDecoder.decode(TracksResults.self, from: data)
                   
                  
                    mainQueue.async  { [weak self] in
                        for (index, track) in results.results.enumerated() {
                                              let trackObject = Track(artistName: track.artistName, previewUrl: track.previewUrl, trackName: track.trackName)
                                              trackObject.index = index
                                              trackObject.downloaded = false
                            self?.tracks.append(trackObject)
                                          }
                        completionHandler(self?.tracks, nil)
                    }
                    
                } catch let error {
                    
                    print("\(error)")
                    mainQueue.async {
                        completionHandler(nil , .parseError)
                    }
                    
                }
                
            }
            
        })
        
        dataTask?.resume()
        
    }
    
    
}
