//
//  InEventProvider.swift
//  InEventRx
//
//  Created by José Eduardo Vieira Morango on 12/01/17.
//  Copyright © 2017 José Eduardo Vieira Morango. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import Alamofire


extension Response{
    
    func removeAPIWrappers() -> Response{
        
        guard let json = try? self.mapJSON() as?  Dictionary<String, AnyObject>,
            let results = json?["data"],
            let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted) else{
                return self
        }
        
        return Response(statusCode: self.statusCode, data: newData, response: self.response)
    }
}

struct InEventAPIManager{
    
    let provider: RxMoyaProvider<InEventAPI>
    let bag = DisposeBag()
    
    init() {
        provider = RxMoyaProvider<InEventAPI>()
    }
}

extension InEventAPIManager{
    
    public func requestLogin( pessoa: Variable<Pessoa>) {
        
        provider.request(.login(pessoa: pessoa.value)).debug().map{$0.removeAPIWrappers()}.subscribe{ event in
            switch event{
            case .next(let obj):
                guard let dat = try? obj.mapJSON() as? [[String : AnyObject]] else{
                            return
                }
                pessoa.value = Pessoa.init(data: dat!.first! )
                
            case .error(let error): print(error)
            default: break
            }
        
        }.addDisposableTo(bag)

    }
    
    public func requestBindPersonEvent(evento: Variable<Evento>){
    
        provider.request(.evento(evento: (evento.value))).debug().map{$0.removeAPIWrappers()}.subscribe{ event in
            switch event{
            case .next(let obj):
                guard let dat = try? obj.mapJSON() as? [[String: AnyObject]] else{return}
                evento.value = Evento(data: dat!.first!)
            case .error(let error): print(error)
            default : break
            }
        }.addDisposableTo(bag)
        
    }

    
    
    
}


