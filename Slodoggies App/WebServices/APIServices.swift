//
//  AppDelegate.swift
//  RPG
//
//  Created by Satyam on 07/02/24.
//
import Alamofire
import Combine
import SwiftyJSON
import Photos
import SwiftUI

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias SuccessResponse = (_ json : JSON) -> ()
typealias SuccessResponseNew = (_ json : JSON, _ msg : String) -> ()
typealias FailureResponse = (NSError) -> (Void)
typealias ResponseMessage = (_ message : String) -> ()
typealias CompletionHandler = ( _ upl:UploadFileParameter?) -> Void
typealias DownloadData = (_ data : Data) -> ()
typealias UploadFileParameter = (fileName: String, key: String, data: Data?, mimeType: String,id:String? )

struct Media{
    var image : UIImage!
    var data : Data!
    var url : String? = ""
    var type : String? = ""
    var id : String? = ""
    var phAsset : PHAsset?
    var URL : URL?
    var uploadFile:UploadFileParameter?
    var fileName:String?
    var ext:String?
}
enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case encode
    case decode
    case invalidResponse
}

struct EmptyModel: Decodable {}
typealias DefaultAPIService = APIServices<EmptyModel>
protocol APIServiceProtocol {
    associatedtype Model: Decodable
    
    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?,token:String?) -> AnyPublisher<BaseResponse<Model>, Error>
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data?]?, progressHandler: ((Double) -> Void)?,loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
}



final class APIServices<T: Decodable>: APIServiceProtocol {
    let userDefaultsManager: UserDefaultManagerProtocol
    @EnvironmentObject var coordinator: Coordinator
    
    init(userDefaultsManager : UserDefaultManagerProtocol = USerDefaultManager()) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            
            print("==========================URL yai hai=====================")
            
            print(endpoint.path)
            let token = UserDetail.shared.getTokenWith()
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            if loader ?? false {
                //   GameLoaderView.show(in: topViewController.view)
            }
            print(endpoint.path,"endpoint.path")
            AF.request(endpoint.path, method: .get, parameters: parameters, headers: headers)
            //  .validate(statusCode: 200..<404)
                .responseDecodable(of: BaseResponse<T>.self) { response in
                    //GameLoaderView.hide(from: topViewController.view)
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            print("Unauthorized (401) detected. Logging out...")
                            self.handleUnauthorized()
                           
                            return
                        }
                        if statusCode == 500 {
                            print("Server Error (500) detected.")
                            self.handleInternalServerError(Code: statusCode)
                            return
                        }

                    }
                    print("\n==========================Parameters=====================\n")
                    print(parameters)
                    print("\n==========================Header=====================\n")
                    print(headers)
                    print("\n==========================Response=======================\n")
                    
                    if let data = response.data {
                        print(JSON(data))
                    }
                    
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    func uploadMultiData(para: [String: Any],images: [String: Data?]? = [:], imageData: [UploadFileParameter]? = [],videoData: [UploadFileParameter]? = [],pdfData: [UploadFileParameter]? = [],endpoint:AppURL.Endpoint,loader:Bool? = true) ->  AnyPublisher<BaseResponse<T>, Error> {
        
        
        return Future<BaseResponse<T>, Error>{ promise in
            
            
            let token = UserDetail.shared.getTokenWith()
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            
            if loader ?? false {
                //    GameLoaderView.show(in: topViewController.view)
            }
            
            print("==========================URL=====================")
            print(endpoint.path)
            print("\n==========================Parameters=====================\n")
            print(para)
            print("\n==========================Header=====================\n")
            print(headers)
            
            AF.upload(multipartFormData: { multipartFormData in
                
                for (key, value) in para {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    } else if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    } else if let temp = value as? NSArray {
                        temp.forEach { element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        }
                    }
                }
                imageData?.forEach { imageData in
                    multipartFormData.append(imageData.data ?? Data(), withName: imageData.key, fileName: imageData.fileName, mimeType: imageData.mimeType)
                }
                videoData?.forEach { vdoData in
                    multipartFormData.append(vdoData.data ?? Data(), withName: vdoData.key, fileName: vdoData.fileName, mimeType: vdoData.mimeType)
                }
                pdfData?.forEach { pdfData in
                    multipartFormData.append(pdfData.data ?? Data(), withName: pdfData.key, fileName: pdfData.fileName, mimeType: pdfData.mimeType)
                }
                // Add images
                let name = Date()
                var i = 0
                if let images = images {
                    print("========================== Image Parameters =====================")
                    for (key, imageData) in images {
                        if let imageData = imageData, !imageData.isEmpty  {
                            // Replace index inside brackets with empty brackets "[]"
                            let modifiedKey = key.replacingOccurrences(of: "\\[.*?\\]", with: "[]", options: .regularExpression)
                            
                            multipartFormData.append(imageData, withName: modifiedKey, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                            print("data ==>", imageData, "withName ==>", modifiedKey, "fileName ==>", "\(name)\(i).jpeg", "mimeType ==>", "image/jpeg")
                            
                        }
                        i += 1
                    }
                }
                
            }, to: endpoint.path, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: BaseResponse<T>.self){ response in
                
                // GameLoaderView.hide(from: topViewController.view)
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        print("Unauthorized (401) detected. Logging out...")
                        self.handleUnauthorized()
                       
                        return
                    }
                    if statusCode == 500 {
                        print("Server Error (500) detected.")
                        self.handleInternalServerError(Code: statusCode)
                        return
                    }
                }
                print("\n==========================Response=======================\n")
                
                if let data = response.data {
                    print(JSON(data))
                }
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                    
                    
                case .failure(let error):
                    print("==========================failure=====================")
                    //                    if let statusCode = response.response?.statusCode {
                    //                        if statusCode == 401 {
                    //                            print("Unauthorized (401) detected. Logging out...")
                    //                            self.handleUnauthorized()
                    //                            return
                    //                        }
                    //                    }
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func postModel< Parameter: Encodable>(endpoint: AppURL.Endpoint,parameters: Parameter,loader: Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            
            let token = UserDetail.shared.getTokenWith()
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            if loader ?? false {
                // GameLoaderView.show(in: topViewController.view)
            }
            
            print("==========================URL=====================")
            print(endpoint.path)
            print("\n==========================Parameters=====================\n")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                let jsonData = try encoder.encode(parameters)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    
                }
            } catch {
                print("Error encoding intervals to JSON: \(error)")
            }
            
            print("\n==========================Header=====================\n")
            print(headers)
            AF.request(endpoint.path,
                       method: .post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            //            .validate(statusCode: 200..<404)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                // GameLoaderView.hide(from: topViewController.view)
                
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        print("Unauthorized (401) detected. Logging out...")
                        self.handleUnauthorized()
                       
                        return
                    }
                    if statusCode == 500 {
                        print("Server Error (500) detected.")
                        self.handleInternalServerError(Code: statusCode)
                        return
                    }

                }
                print("\n==========================Response=======================\n")
                
                if let data = response.data {
                    print(JSON(data))
                }
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================failure=====================")
                    //                    if let statusCode = response.response?.statusCode {
                    //                        if statusCode == 401 {
                    //                            print("Unauthorized (401) detected. Logging out...")
                    //                            self.handleUnauthorized()
                    //                            return
                    //                        }
                    //                    }
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], loader: Bool? = true,token:String? = "") -> AnyPublisher<BaseResponse<T>, Error> {
        let maxRetries = 3
        let initialDelay: TimeInterval = 1
        
        return Future<BaseResponse<T>, Error> { promise in
            var headers: HTTPHeaders = []
            
            if !endpoint.path.contains("auth") {
                guard let token = token?.isEmpty == false ? token : UserDetail.shared.getTokenWith() else {
                    // self.handleUnauthorized()
                    return
                }
                
                headers = [
                    "Authorization": "Bearer \(token)",
                    "Accept": "application/json"
                ]
            }
            
            if loader ?? false {
                //   GameLoaderView.show(in: topViewController.view)
            }
            
            func makeRequest(attempt: Int) {
                AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .validate(statusCode: 200..<425)
                    .responseDecodable(of: BaseResponse<T>.self) { response in
                        //   GameLoaderView.hide(from: topViewController.view)
                        
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 401 {
                                print("Unauthorized (401) detected. Logging out...")
                                self.handleUnauthorized()
                               
                                return
                            }
                            if statusCode == 500 {
                                print("Server Error (500) detected.")
                                self.handleInternalServerError(Code: statusCode)
                                return
                            }

                        }
                        
                        print("==========================URL=====================")
                        print(endpoint.path)
                        print("\n==========================Parameters=====================\n")
                        print(parameters)
                        print("\n==========================Header=====================\n")
                        print(headers)
                        print("\n==========================Response=======================\n")
                        if let data = response.data {
                            print(JSON(data))
                        }
                        switch response.result {
                            
                        case .success(let value):
                            promise(.success(value))
                            
                        case .failure(let error):
                            print(response.response?.statusCode ?? 0)
                            
                            print("Attempt \(attempt + 1) failed: \(error.localizedDescription)")
                            
                            if attempt < maxRetries, let afError = error.asAFError, afError.isSessionTaskError {
                                let retryDelay = initialDelay * pow(2, Double(attempt))
                                print("Retrying in \(retryDelay) seconds...")
                                DispatchQueue.global().asyncAfter(deadline: .now() + retryDelay) {
                                    makeRequest(attempt: attempt + 1)
                                }
                            } else {
                                print(error)
                                promise(.failure(error))
                            }
                        }
                    }
            }
            
            makeRequest(attempt: 0)
        }
        .eraseToAnyPublisher()
    }
    
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data?]?, progressHandler: ((Double) -> Void)? = nil, loader: Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        let maxRetries = 3
        let initialDelay: TimeInterval = 1
        
        return Future<BaseResponse<T>, Error> { promise in
            
            
            let token = UserDetail.shared.getTokenWith()
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            
            if loader ?? false {
                //  GameLoaderView.show(in: topViewController.view)
            }
            
            func makeRequest(attempt: Int) {
                AF.upload(multipartFormData: { multipartFormData in
                    // Add parameters
                    for (key, value) in parameters {
                        if let data = "\(value)".data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    
                    // Add images
                    let name = Date()
                    var i = 0
                    if let images = images {
                        print("========================== Image Parameters =====================")
                        for (key, imageData) in images {
                            if let imageData = imageData, !imageData.isEmpty  {
                                // Replace index inside brackets with empty brackets "[]"
                                let modifiedKey = key.replacingOccurrences(of: "\\[.*?\\]", with: "[]", options: .regularExpression)
                                
                                multipartFormData.append(imageData, withName: modifiedKey, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                                print("data ==>", imageData, "withName ==>", modifiedKey, "fileName ==>", "\(name)\(i).jpeg", "mimeType ==>", "image/jpeg")
                                
                            }
                            i += 1
                        }
                    }
                }, to: endpoint.path, headers: headers)
                .uploadProgress { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    progressHandler?(progress.fractionCompleted)
                }
                
                .responseDecodable(of: BaseResponse<T>.self) { response in
                    // GameLoaderView.hide(from: topViewController.view)
                    
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            print("Unauthorized (401) detected. Logging out...")
                            self.handleUnauthorized()
                           
                            return
                        }
                        if statusCode == 500 {
                            print("Server Error (500) detected.")
                            self.handleInternalServerError(Code: statusCode)
                            return
                        }

                    }
                    print("==========================URL=====================")
                    print(endpoint.path)
                    print("\n==========================Parameters=====================\n")
                    print(parameters)
                    print("\n==========================Header=====================\n")
                    print(headers)
                    print("\n==========================Response=======================\n")
                    
                    if let data = response.data {
                        print(JSON(data))
                        let json = JSON(data)
                        //                        if let dict = json.dictionaryObject, let status = dict["code"] as? Int, status == 206 || status == 401 {
                        //
                        //                                UserDetail.shared.setUserId("")
                        //                                UserDetail.shared.setSessntId("")
                        //                        }
                    }
                    
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print("Attempt \(attempt + 1) failed: \(error.localizedDescription)")
                        
                        if attempt < maxRetries, let afError = error.asAFError, afError.isSessionTaskError {
                            let retryDelay = initialDelay * pow(2, Double(attempt)) // 1s, 2s, 4s...
                            print("Retrying in \(retryDelay) seconds...")
                            DispatchQueue.global().asyncAfter(deadline: .now() + retryDelay) {
                                makeRequest(attempt: attempt + 1)
                            }
                        } else {
                            promise(.failure(error))
                        }
                    }
                }
            }
            makeRequest(attempt: 0)
        }
        .eraseToAnyPublisher()
    }
    
    func SendAnyThing(endpoint: AppURL.Endpoint, parameters: [String: Any],images: [String: Data]?,progressHandler: ((Double) -> Void)? = nil,loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            
            guard let token = self.userDefaultsManager.getItem(key: .authToken, type: String.self) else {return}
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            
            if loader ?? false {
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let arrayValue = value as? [Any] {
                        arrayValue.forEach { value in
                            if let data = "\(value)".data(using: .utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    } else if let stringValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(stringValue, withName: key)
                    }
                }
                // Add images
                let name = Date()
                var i = 0
                if let images = images {
                    print("==========================ImageParameters=====================")
                    for (key, imageData) in images {
                        multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                        print("data ==>",imageData,"withName ==>",key,"fileName==>","\(name)\(i).jpeg","mimeType ==>" ,"image/jpeg")
                        i += 1
                    }
                }
            }, to: endpoint.path,headers: headers)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
                progressHandler?(progress.fractionCompleted)
            }
            .responseDecodable(of: BaseResponse<T>.self) { response in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        print("Unauthorized (401) detected. Logging out...")
                        self.handleUnauthorized()
                       
                        return
                    }
                    if statusCode == 500 {
                        print("Server Error (500) detected.")
                        self.handleInternalServerError(Code: statusCode)
                        return
                    }

                }
                print("==========================URL=====================")
                print(endpoint.path)
                print("\n==========================Parameters=====================\n")
                for (key, value) in parameters {
                    print("\(key): \(value)")
                }
                print("\n==========================Header=====================\n")
                print(headers)
                print("\n==========================Response=======================\n")
                
                
                if let data = response.data {
                    print(JSON(data))
                }
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================failure=====================")
                    
                    print(error)
                    promise(.failure(error))
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
    func handleUnauthorized() {

        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
    }
    func handleInternalServerError(Code: Int) {

        NotificationCenter.default.post(
            name: Notification.Name("ServerError"),
            object: nil,
            userInfo: ["code": Code]
        )

       
    }
}

extension UIViewController {
    func topmostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topmostViewController() // Recursively find presented view controller
        } else if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topmostViewController() ?? self
        } else if let tabController = self as? UITabBarController {
            return tabController.selectedViewController?.topmostViewController() ?? self
        }
        return self
    }
}

extension Result {
    func handle(success: @escaping (Success) -> Void) {
        switch self {
        case .success(let value):
            success(value)
        case .failure(let error):
            print(error.localizedDescription)
            //            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
            //                _ = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
            //                return
            //            }
            
            //            topViewController.AlertControllerOnr(title: "", message: "\(error.localizedDescription)")
            
        }
    }
}
