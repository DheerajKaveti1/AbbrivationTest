//
//  NetworkClass.swift
//  Acronime
//
//  Created by Dheeraj Kaveti on 3/3/17.
//  Copyright © 2017 Dheeraj Kaveti. All rights reserved.
//

import UIKit
enum AcronymType: String {
    case SF = "sf"
    case LF = "lf"
}
class NetworkClass: NSObject {
    private let url = "http://www.nactem.ac.uk/software/acromine/dictionary.py?"
    private var acrType:AcronymType = .LF
    private var parameter = ""
    func downloadData(arcType:AcronymType, parameter:String,success: @escaping (Any?, URLResponse?) -> Void, failure: @escaping (Error?) -> Void) {
        self.acrType = arcType
        self.parameter  = parameter
        let request1:URLRequest = createRequest(getUrlforRequest())
        let task = URLSession.shared.dataTask(with: request1) {
            data, response, error in
            // Handler
            DispatchQueue.main.async {
                if error != nil {
                    failure((error as Error?)!)
                } else {
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        success(jsonDict, response)
                    } catch {
                        failure(error as NSError)
                        
                    }
                    
                }
            }
        }
        
        task.resume()
    }
    
    func createRequest(_ url: String) -> URLRequest {
        let escapedString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let serviceURL: URL! = URL(string: escapedString!)
        var serviceRequest: URLRequest = URLRequest(url: serviceURL)
        
        serviceRequest.timeoutInterval = TimeInterval(2 * 60) // seconds
        return serviceRequest
    }
    
    func getUrlforRequest()->String{
       return  url+acrType.rawValue+"="+parameter
    }
    
}
