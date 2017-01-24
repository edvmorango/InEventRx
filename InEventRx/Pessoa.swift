//
//  Pessoa.swift
//  InEventRx
//
//  Created by José Eduardo Vieira Morango on 12/01/17.
//  Copyright © 2017 José Eduardo Vieira Morango. All rights reserved.
//

import Foundation




struct Pessoa{

    init(nome: String, login: String, senha: String) {
        self.nome = nome
        self.login = login
        self.senha = senha
    }
    init(data : [String : AnyObject]) {
        
        token = data["tokenID"] as! String?
        nome  = data["name"] as! String
        login = data["email"] as! String
        senha = nil
    }
    
    var token : String?
    let nome  : String
    let login : String
    let senha : String?
    
    

}
