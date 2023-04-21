//
//  API Service.swift
//  CartoonImage
//
//  Created by ATULA on 03/04/2023.
//

//
//  APIService.swift
//  MangaJar
//
//  Created by ATULA on 17/03/2023.
//

import UIKit
import Alamofire
extension NSMutableData {
    func appendString(string: String) {
    let data = string.data(
        using: String.Encoding.utf8,
        allowLossyConversion: true)
    append(data!)
  }
}

struct MultipartFormDataRequest {
    
    private let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()
    let url: URL

    init(url: URL) {
        self.url = url
    }

    func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value))
    }
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        httpBody.appendString(string: "--\(boundary)--")
        request.httpBody = httpBody as Data
        return request
    }
    
    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    func addDataField(named name: String, data: Data, mimeType: String) {
        httpBody.append(dataFormField(named: name, data: data, mimeType: mimeType))
    }

    private func dataFormField(named name: String,
                               data: Data,
                               mimeType: String) -> Data {
        let fieldData = NSMutableData()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }
}

extension NSMutableData {
  func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}



typealias ApiCompletion = (_ data: Any?, _ error: Error?) -> ()

typealias ApiParam = [String: Any]

enum ApiMethod: String {
    case GET = "GET"
    case POST = "POST"
}
extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            if value is String {
                let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
                return "\(percentEscapedKey)=\(percentEscapedValue)"
            }
            else {
                return "\(percentEscapedKey)=\(value)"
            }
        }
        return parameterArray.joined(separator: "&")
    }
}
extension URLSession {
    
    func dataTask(with request: MultipartFormDataRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask {
        return dataTask(with: request.asURLRequest(), completionHandler: completionHandler)
    }
}
class APIService:NSObject {
    static let shared: APIService = APIService()
    
    func getPostString(params:[String:Any]) -> String{
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    func uploadImage(imageData: Data) {
        let request = MultipartFormDataRequest(url: URL(string: "https://server.com/uploadPicture")!)
        request.addDataField(named: "image", data: imageData, mimeType: "img/jpeg")
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                result.message = "Success"
                result.data = data
            }
        }
    }
    
    func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
        {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let postString = self.getPostString(params: params)
            request.httpBody = postString.data(using: .utf8)

            var result:(message:String, data:Data?) = (message: "Fail", data: nil)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if(error != nil){
                    result.message = "Fail Error not null : \(error.debugDescription)"
                }
                else{
                    result.message = "Success"
                    result.data = data
                }

                finish(result)
            }
            task.resume()
        }
    
    func requestSON(_ url: String,
                    param: Data,
                    method: ApiMethod,
                    loading: Bool,
                    completion: @escaping ApiCompletion)
    {
        var request:URLRequest!
        
        // set method & param
        if method == .GET {
        }
        else if method == .POST {
            request = URLRequest(url: URL(string:url)!)
            request.timeoutInterval = 30
            request.httpMethod = method.rawValue
            let request = MultipartFormDataRequest(url: URL(string: url)!)
            let dataImage = param.base64EncodedString(options: .lineLength64Characters)
            request.addTextField(named: "image", value: dataImage)
            var result:(message:String, data:Data?) = (message: "Fail", data: nil)
            URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
                result.data = data
                DispatchQueue.main.async {
                    
                    // check for fundamental networking error
                    guard let data = data, error == nil else {
                        completion(nil, error)
                        return
                    }
                    
                    // check for http errors
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                    }
                    
                    if let resJson = self.convertToJson(data) {
                        completion(resJson, nil)
                    }
                    else if let resString = String(data: data, encoding: .utf8) {
                        completion(resString, error)
                    }
                    else {
                        completion(nil, error)
                    }
                }
                }).resume()
        }
        
        
        
        //
       
    }
    func request_Upload2Image(_ url: String,
                    param1: Data,
                    method: ApiMethod,
                    loading: Bool,
                    completion: @escaping ApiCompletion)
    {
        var request:URLRequest!
        
        // set method & param
        if method == .GET {
        }
        else if method == .POST {
            request = URLRequest(url: URL(string:url)!)
            request.timeoutInterval = 30
            request.httpMethod = method.rawValue
            let request = MultipartFormDataRequest(url: URL(string: url)!)
            let dataImage1 = param1.base64EncodedString(options: .lineLength64Characters)
            request.addTextField(named: "image", value: dataImage1)

            var result:(message:String, data:Data?) = (message: "Fail", data: nil)
            URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
                result.data = data
                DispatchQueue.main.async {
                    
                    // check for fundamental networking error
                    guard let data = data, error == nil else {
                        completion(nil, error)
                        return
                    }
                    
                    // check for http errors
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                    }
                    
                    if let resJson = self.convertToJson(data) {
                        completion(resJson, nil)
                    }
                    else if let resString = String(data: data, encoding: .utf8) {
                        completion(resString, error)
                    }
                    else {
                        completion(nil, error)
                    }
                }
                }).resume()
        }
        
        
        
        //
       
    }
    
    func PostAPISwapeImage(_ url: String,
                           param: [String:String],
                    method: ApiMethod,
                    completion: @escaping ApiCompletion)
    {
        var request:URLRequest!
        // set method & param
        if method == .GET {

        }
        else if method == .POST {
            request = URLRequest(url: URL(string:url)!)
            request.timeoutInterval = 30
            request.httpMethod = method.rawValue
            let headers: Dictionary = param
            request.allHTTPHeaderFields = headers
            request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
            var result:(message:String, data:Data?) = (message: "Fail", data: nil)
            URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
                result.data = data
                DispatchQueue.main.async {
                    
                    // check for fundamental networking error
                    guard let data = data, error == nil else {
                        completion(nil, error)
                        return
                    }
                    
                    // check for http errors
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                    }
                    
                    if let resJson = self.convertToJson(data) {
                        completion(resJson, nil)
                    }
                    else if let resString = String(data: data, encoding: .utf8) {
                        completion(resString, error)
                    }
                    else {
                        completion(nil, error)
                    }
                }
                }).resume()
        }
        
        
        
        //
       
    }
    
    private func convertToJson(_ byData: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: byData, options: [])
        } catch {
            //            self.debug("convert to json error: \(error)")
        }
        return nil
    }
    
    func PostSwapAPIPro( param:[String:String], closure: @escaping (_ response: String?, _ error: Error?) -> Void) {
        PostAPISwapeImage("http://14.225.7.221:9989/home", param: param, method: .POST) { (data, error) in
            if let data = data as? [String:Any]{
                if let link = data["link"] as? String{
                    closure(link,nil)
                }else{
                    if let data2 = data["error"] as? [String:Any]{
                        //message
                        var  returnData:ImgModel = ImgModel()
                        if let data = data2["message"] as? String{
                            returnData.link = data
                        }
                        closure("",nil)
                    }
                }
            }else{
                closure(nil,nil)
            }
        }
        closure(nil, nil)
    }
    //2d2e8117df677dffe0644a0ca32dd45d
    func PostImageServer( key:String, param:Data, closure: @escaping (_ response: ImgModel?, _ error: Error?) -> Void) {
        requestSON("https://api.imgbb.com/1/upload?expiration=600&key=" + key, param: param, method: .POST, loading: true) { (data, error) in
            if let data = data as? [String:Any]{
                if let data2 = data["data"] as? [String:Any]{
                    var  returnData:ImgModel = ImgModel()
                    returnData = returnData.initLoad(data2)
                    closure(returnData,nil)
                }else{
                    if let data2 = data["error"] as? [String:Any]{
                        //message
                        var  returnData:ImgModel = ImgModel()
                        if let data = data2["message"] as? String{
                            returnData.link = data
                        }
                        closure(returnData,nil)
                    }
                }
            }else{
                closure(nil,nil)
            }
        }
        closure(nil, nil)
    }
    
    func requestParseJSON(_ url: String,
                    param: ApiParam?,
                    method: ApiMethod,
                    loading: Bool,
                    completion: @escaping ApiCompletion)
    {
        var request:URLRequest!
        
        // set method & param
        if method == .GET {
            if let paramString = param?.stringFromHttpParameters() {
                request = URLRequest(url: URL(string:"\(url)?\(paramString)")!)
            }
            else {
                request = URLRequest(url: URL(string:url)!)
            }
        }
        else if method == .POST {
            request = URLRequest(url: URL(string:url)!)
            
            // content-type
            let headers: Dictionary = ["Content-Type": "application/json"]
            request.allHTTPHeaderFields = headers
            
            do {
                if let p = param {
                    request.httpBody = try JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
                }
            } catch { }
        }
        
        request.timeoutInterval = 30
        request.httpMethod = method.rawValue
        
        //
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                // check for fundamental networking error
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                
                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                }
                
                if let resJson = self.convertToJson(data) {
                    completion(resJson, nil)
                }
                else if let resString = String(data: data, encoding: .utf8) {
                    completion(resString, error)
                }
                else {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func getAll_Location(closure: @escaping (_ response: [ListImageGocModel]?, _ error: Error?) -> Void) {
        requestParseJSON("https://raw.githubusercontent.com/sonnh7289/animepro/main/sklyhon.json", param: nil, method: .GET, loading: true) { (data, error) in
            if let dataList = data as? [[String: Any]] {
                var listComicReturn:[ListImageGocModel] = [ListImageGocModel]()
                for item1 in dataList{
                    var commicAdd:ListImageGocModel = ListImageGocModel()
                    commicAdd = commicAdd.initLoad(item1)
                    listComicReturn.append(commicAdd)
                }
                closure(listComicReturn, nil)
            }
            else {
                closure(nil,nil)
            }
        }
    }
    func Post2ImageServer( key:String, param1:Data, closure: @escaping (_ response: ImgModel?, _ error: Error?) -> Void) {
        request_Upload2Image("https://api.imgbb.com/1/upload?expiration=600&key=" + key, param1: param1 , method: .POST, loading: true) { (data, error) in
            if let data = data as? [String:Any]{
                if let data2 = data["data"] as? [String:Any]{
                    var  returnData:ImgModel = ImgModel()
                    returnData = returnData.initLoad(data2)
                    closure(returnData,nil)
                }else{
                    if let data2 = data["error"] as? [String:Any]{
                        //message
                        var  returnData:ImgModel = ImgModel()
                        if let data = data2["message"] as? String{
                            returnData.link = data
                        }
                        closure(returnData,nil)
                    }
                }
            }else{
                closure(nil,nil)
            }
        }
        closure(nil, nil)
    }
    
}
    

    
    
    

    

