//
//  RottenTomatoDataSource.swift
//  RottenTomatoes
//
//  Created by Robert Xue on 10/25/15.
//  Copyright © 2015 roboxue. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let RTBoxOfficeEndpoint = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
let RTTopDVDEndpoint = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"

let RTTitle = "title"
let RTPosters = "posters"
let RTDetailed = "detailed"
let RTThumbnail = "thumbnail"
let RTMPAARating = "mpaa_rating"
let RTSynopsis = "synopsis"

class RottenTomatoDataSource {
    func getBoxOffice(successHandler: ([JSON]) -> Void, errorHandler: (NSError?) -> Void) {
        Alamofire.request(.GET, RTBoxOfficeEndpoint)
            .responseJSON { response in
                if let movies = response.result.value {
                    successHandler(JSON(movies)["movies"].arrayValue)
                } else {
                    errorHandler(response.result.error)
                }
        }
    }
    
    class func getPicUrl(url: String, highResolution: Bool) -> String {
        let range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)!
        let uri = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        let resolutionRange = uri.rangeOfString("(ori)|(tmb).jpg", options: .RegularExpressionSearch)!
        if highResolution {
            return uri.stringByReplacingCharactersInRange(resolutionRange, withString: "ori")
        } else {
            return uri.stringByReplacingCharactersInRange(resolutionRange, withString: "tmb")
        }
    }
}

let RTDataSource = RottenTomatoDataSource()
