//
//  ViewController.swift
//  InEventRx
//
//  Created by José Eduardo Vieira Morango on 12/01/17.
//  Copyright © 2017 José Eduardo Vieira Morango. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ViewController: UIViewController {
    
    let bag = DisposeBag()
    let apiManager = InEventAPIManager()
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var lbLoginStatus: UILabel!
    @IBOutlet weak var lbToken: UILabel!
    @IBOutlet weak var tfEventId: UITextField!
    @IBOutlet weak var btBindEvent: UIButton!
    @IBOutlet weak var lbBindStatus: UILabel!
    
    
    
    
    override func viewDidLoad() {
     var pessoa : Variable<Pessoa>!
     let  tfNomeIsValid  =   tfNome.rx.text.orEmpty.skip(1).map{$0.characters.count > 2}
     let  tfEmailIsValid =  tfEmail.rx.text.orEmpty.skip(1).map{$0.characters.count > 5}
     let  tfSenhaIsValid =  tfSenha.rx.text.orEmpty.skip(1).map{$0.characters.count > 5}
     let  btLoginIsValid =  Observable.combineLatest(tfNomeIsValid,tfEmailIsValid,tfSenhaIsValid){ return $0 && $1 && $2 }
        btLoginIsValid.startWith(true).subscribe(onNext:{ isValid in
            self.btLogin.isEnabled = isValid
            if isValid{
                self.btLogin.alpha = 1
            }else{
                self.btLogin.alpha = 0.5
            }
        }).addDisposableTo(bag)
     btLogin.rx.tap.subscribe(onNext:{
            let pessoaObj = Pessoa(nome: self.tfNome.text!, login: self.tfEmail.text!, senha: self.tfSenha.text!)
            pessoa = Variable<Pessoa>(pessoaObj)
            pessoa.asObservable().map{ $0.token == nil ? "Deslogado" : "Logado"}.bindTo(self.lbLoginStatus.rx.text).addDisposableTo(self.bag)
            pessoa.asObservable().map{ $0.token == nil ? "Token" : $0.token!}.bindTo(self.lbToken.rx.text).addDisposableTo(self.bag)
            pessoa.asObservable().map{ $0.token == nil ? false : true}.bindTo(self.tfEventId.rx.isEnabled).addDisposableTo(self.bag)
            self.apiManager.requestLogin(pessoa: pessoa)
     }).addDisposableTo(bag)
        
    
    let tfEventIsValid = tfEventId.rx.text.orEmpty.skip(1).map{$0.characters.count >= 1}
    
    let btBindEventIsValid = tfEventIsValid
        btBindEventIsValid.startWith(false).subscribe(onNext:{
            self.btBindEvent.isEnabled = $0
            if $0{
                self.btBindEvent.alpha = 1
            }else{
                self.btBindEvent.alpha = 0.5
            }
        }).addDisposableTo(bag)
   
    
        btBindEvent.rx.tap.subscribe(onNext:{
            
            
        }).addDisposableTo(bag)
    
    }
    
    
   


}

