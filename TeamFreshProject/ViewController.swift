//
//  ViewController.swift
//  TeamFreshProject
//
//  Created by mac on 2022/08/11.
//

// 08.11 commit => notion rgb추출하여 placeholder 적용, imageview setImage

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
        
        setUP()
        
        loginBtn.tag = 0
    }
    
    func setUP(){
        //아이디 텍스트필드 설정
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        idTextField.spellCheckingType = .no // 자동 맞춤법 사용x
        idTextField.autocapitalizationType = .none // 자동 첫알파벳 대문자로 변경 사용x
        idTextField.returnKeyType = .next // 키보드 return 키 타입을 next로 변경 (시뮬레이션 혹은 블루투스 키보드에서는 확인 불가)
        idTextField.textContentType = .emailAddress // 키보드 ContentType(이메일을 입력 받아야 하기 때문에 이메일로 처리)
//        idTextField.textContentType
        idTextField.addLeftPadding()
        
        //비밀번호 텍스트필드 설정
        pwTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        pwTextField.addLeftPadding()
        idTextField.spellCheckingType = .no // 자동 맞춤법 사용x
        idTextField.autocapitalizationType = .none // 자동 첫알파벳 대문자로 변경 사용x
        idTextField.returnKeyType = .done // 키보드 return 키 타입을 done로 변경 (시뮬레이션 혹은 블루투스 키보드에서는 확인 불가, done터치시 btnAction함수 실행)
        pwTextField.textContentType = .password // 키보드 ContentType(비밀번호를 입력 받아야 하기 때문에 password로 처리)
    }
    
    override func viewDidLayoutSubviews() {
        
        //아이디 텍스트필드
        idTextField.layer.cornerRadius = 10
        idTextField.backgroundColor = .systemGray6
        
        //패스워드 텍스트필드
        pwTextField.layer.cornerRadius = 10
        pwTextField.backgroundColor = .systemGray6
        
        //로그인 버튼 #ff6348
        loginBtn.layer.cornerRadius = 30
    }

    @IBAction func btnAction(_ sender: Any) {
        print((sender as AnyObject).tag!)
        print("idTextField => \(idTextField.text!)")
        print("pwTextField => \(pwTextField.text!)")
    }
    

}

