//
//  Track.swift
//  HalfTunes
//
//  Created by עלאא דאהר on 09/02/2020.
//  Copyright © 2020 עלאא דאהר. All rights reserved.
//

import Foundation

public class Track : Decodable {
    
   public let artistName : String
    public let previewUrl : URL
   public let trackName : String
   
    public var downloaded : Bool?
   public var index : Int?
    public var noTrack : Bool?
   
    public init(artistName : String, previewUrl : URL, trackName : String) {
  
        self.artistName = artistName
        self.previewUrl = previewUrl
        self.trackName = trackName

    }
    
    
}

struct TracksResults : Decodable {
    let results : [Track]
    let resultCount : Int
}


