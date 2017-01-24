//
//  InEventAPI.swift
//  InEventRx
//
//  Created by José Eduardo Vieira Morango on 12/01/17.
//  Copyright © 2017 José Eduardo Vieira Morango. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum InEventAPI{
    case login(pessoa : Pessoa )
    case evento(evento : Evento)
}

struct InEventEncoding: ParameterEncoding{
   
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        
        let newUrl = urlRequest.urlRequest!.url!.absoluteString.replacingOccurrences(of: "/api/", with: "/api/?action=")
        let url = URL(string: newUrl)!
        let body = parameters?.map{$0.key + "=" + String(describing: $0.value)}.joined(separator: "&")
        
        var request = URLRequest(url: url)
            request.httpBody = body?.data(using: .utf8)
            request.httpMethod = urlRequest.urlRequest?.httpMethod
        
        
        return request
    }
}

extension InEventAPI: TargetType{
    /// The method used for parameter encoding.
   
   
  
    var baseURL: URL { return
        URL(fileURLWithPath: "https://inevent.us/api/")
    }

    public var path: String {
       
        switch self {
        case .login(let pessoa):
            
           return "person.signIn&username="+pessoa.login
           case .evento(let evento):
           return "action=event.person.bind&eventID="+evento.eventId+"&tokenID="+evento.pessoa.token!
        }
    }
    
    var method: Moya.Method {
        switch self{
        
        case  .login, .evento: return .post
       
        }
    }

    public var parameterEncoding: ParameterEncoding {
        return InEventEncoding()
    }
    

    
    public var parameters: [String : Any]? {
        switch self{
        
        case .login(let pessoa):  return ["password": pessoa.senha!]
        case .evento(let evento): return ["name" : evento.pessoa.nome,
                                          "username" : evento.pessoa.login,
                                          "password" : evento.pessoa.senha!]
        
        }
    }

    
     public var task: Task {
        return .request
    }

    public var sampleData: Data {
        switch self{
        default : return Data()
        }
    }
    
    
    
    
    
    

}
