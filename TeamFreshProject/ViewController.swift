//
//  ViewController.swift
//  TeamFreshProject
//
//  Created by mac on 2022/08/11.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(#function)
        
        loginBtn.tag = 0
    }
    
    override func viewDidLayoutSubviews() {
        
        //아이디 텍스트필드
        idTextField.layer.cornerRadius = 10
        idTextField.backgroundColor = .systemGray6
        
        //패스워드 텍스트필드
        pwTextField.layer.cornerRadius = 10
        pwTextField.backgroundColor = .systemGray6
        
        //로그인 버튼 #ff6348
        loginBtn.layer.cornerRadius = 20
    }

    @IBAction func btnAction(_ sender: Any) {
        print((sender as AnyObject).tag!)
    }
    

}

