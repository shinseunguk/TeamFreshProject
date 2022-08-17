//
//  Helper.swift
//  TeamFreshProject
//
//  Created by ukBook on 2022/08/11.
//

import Foundation
import UIKit
import Alamofire


class Helper : UIViewController {
    func showAlertAction1(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String = "", message: String = "", completeTitle: String = "확인", _ completeHandler:(() -> Void)? = nil){
                
                guard let currentVc = vc else {
                    completeHandler?()
                    return
                }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
                    
                    let completeAction = UIAlertAction(title: completeTitle, style: .default) { action in
                        completeHandler?()
                    }
                    
                    alert.addAction(completeAction)
                    
                    currentVc.present(alert, animated: true, completion: nil)
                }
    }
    
    func showLoadingOneSec() {
            DispatchQueue.main.async {
                // 아래 윈도우는 최상단 윈도우
                guard let window = UIApplication.shared.windows.last else { return }

                let loadingIndicatorView: UIActivityIndicatorView
                // 최상단에 이미 IndicatorView가 있는 경우 그대로 사용.
                if let existedView = window.subviews.first(
                    where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                    loadingIndicatorView = existedView
                } else { // 새로 만들기.
                    loadingIndicatorView = UIActivityIndicatorView(style: .large)
                    // 아래는 다른 UI를 클릭하는 것 방지.
                    loadingIndicatorView.frame = window.frame
                    loadingIndicatorView.color = .systemBlue

                    window.addSubview(loadingIndicatorView)
                }
                loadingIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                window.subviews.filter({ $0 is UIActivityIndicatorView })
                    .forEach { $0.removeFromSuperview() }
            }
        }
    }
}

extension UITextField {
    func addLeftPadding() {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: self.frame.height))
      self.leftView = paddingView
      self.leftViewMode = ViewMode.always
    }
}

extension String {
    func validateEmail(_ input: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = emailPredicate.evaluate(with: input)

        if isValid {
            return true
        } else {
            return false
        }
    }
}

extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}

extension CALayer {
              func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
                  for edge in arr_edge {
                      let border = CALayer()
                      switch edge {
                      case UIRectEdge.top:
                          border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                          break
                      case UIRectEdge.bottom:
                          border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                          break
                      case UIRectEdge.left:
                          border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                          break
                      case UIRectEdge.right:
                          border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                          break
                      default:
                          break
                      }
                      border.backgroundColor = color.cgColor;
                      self.addSublayer(border)
                  }
              }
}
