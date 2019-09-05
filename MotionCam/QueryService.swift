//
//  QueryService.swift
//  MotionCam
//
//  Created by HARI RAJA on 9/4/19.
//  Copyright © 2019 Hari Raja. All rights reserved.
//

import Foundation

class QueryService {
    let apiServerURL = "https://sooilc7ur7.execute-api.us-east-1.amazonaws.com/Stage"
    
    func getMotionTimes(cellX: Int, cellY: Int) -> [String] {
        
        let cell = [ "x": String(cellX), "y": String(cellY)]
        
        let times = postJSONAPI(apiURL: apiServerURL+"/motiontimes", json: cell)
        return times
    }
    
    func postJSONAPIAsync(apiURL: String, json: [String: Any]) {
        let session = URLSession.shared
        let url = URL(string: apiURL)!
        print("apiURL: ", apiURL)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func postJSONAPI(apiURL: String, json: [String: Any]) -> [String] {
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let url = URL(string: apiURL)!
        print("apiURL: ", apiURL)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var resultJson = [String]()
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                semaphore.signal()
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                semaphore.signal()
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                semaphore.signal()
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                resultJson = jsonResponse as! [String]
//                print(resultJson)
                semaphore.signal()
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        semaphore.wait()
        
        return resultJson
    }

    func getJSONAPIAsync(apiURL: String) {
        let session = URLSession.shared
        let url = URL(string: apiURL)!
        print("apiURL: ", apiURL)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
