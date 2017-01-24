//
//  Evento.swift
//  InEventRx
//
//  Created by José Eduardo Vieira Morango on 12/01/17.
//  Copyright © 2017 José Eduardo Vieira Morango. All rights reserved.
//

import Foundation



struct Evento{

    init(data : [String : AnyObject]) {
        
        eventId = data["eventID"] as! String
        pessoa = Pessoa.init(data: data["pessoa"] as! [String : AnyObject] )
    
    }

    
    let  eventId : String
    let  pessoa : Pessoa

}
