//
//  WeatherApiCall.swift
//  WeatherInformation
//
//  Created by Indiawyn Gaming on 06/09/20.
//  Copyright © 2020 myorg. All rights reserved.
//

import Foundation
import Alamofire

class WeatherApiCall : NSObject {
    
    static func getData(long : Double,lat : Double, suceess : @escaping(wmodel?) -> Void , error : @escaping(Error?) -> Void){
          let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=hourly,daily&appid=897f94b9e0a3b7f7673c35779056f9cf")
          
          //make Url request with Alamofire
          Alamofire.request(url!).responseJSON { (responseObject) -> Void in
          
          
              if responseObject.result.isSuccess {
               
                  let respJson = responseObject.data
                  
                  let decoder = JSONDecoder()
                do {
                    let jsndata = try decoder.decode(wmodel.self, from: respJson!)
                  // return response as Any
                  suceess(jsndata)
                }catch let error{
                    print(error)
                }
                  
              }
              if responseObject.result.isFailure {
                  
                  //return error msg
                  error(responseObject.result.error)
                  
              }
          }
      }
}



struct wmodel : Codable {
    var timezone : String
    var current : current
}
struct current : Codable {
    var weather : [weather]
}
struct weather : Codable {
    var id : Int
    var main : String
    var description : String
    var icon : String
    
}
