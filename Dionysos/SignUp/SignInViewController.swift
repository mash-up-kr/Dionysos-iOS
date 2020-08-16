//
//  SignInViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import AuthenticationServices
import FacebookLogin
import KakaoOpenSDK
import Moya
import Promises
import UIKit

enum SocialLoginType: String {
    case facebook
    case apple
    case kakao
    case guest
    
    func getRawValue() -> String {
        rawValue.uppercased()
    }
}

final class SignInViewController: UIViewController {
    @IBAction private func kakaoSignInClicked(_ sender: Any) { kakaoButtonDidTap() }
    @IBAction private func fbSignInClicked(_ sender: Any) { facebookButtonDidTap() }
    @IBAction private func appleSignInClicked(_ sender: Any) { appleButtonDidTap() }
    @IBAction private func guestSignInClicked(_ sender: Any) {
        //apiCall(type: .guest, UID: UIDevice.current.identifierForVendor?.uuidString)
        MainTabCenter.showCurrentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializedLogin()
    }
    
    private func apiCall(type: SocialLoginType, UID: String?) {
        guard let token = UID else { return }
        
        DionysosProvider.callSignIn(provider: type.getRawValue(), token: token).then { _ in
            MainTabCenter.showCurrentViewController()
        }.catch {
            if isNotRegisterUser(error: $0) {
                openSignupViewController()
            }
        }
        
        func isNotRegisterUser(error: Error) -> Bool {
            guard let error = error as? Moya.MoyaError else { return false }
            return error.response?.statusCode == 401 || error.response?.statusCode == 400
        }
        
        func openSignupViewController() {
            let signUpViewController: NicknameInputViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(identifier: "NicknameInputViewController") as! NicknameInputViewController
            signUpViewController.setData(provider: type.getRawValue(), token: token)
            present(signUpViewController, animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SignInViewController {
    private func initializedLogin() {
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logOut()
        addNotificationForFaceBookLogin()
        KakaoAuth.logout()
    }
}

///Kakao Login
extension SignInViewController {
    private func kakaoButtonDidTap() {
        Promise.start {
            KakaoAuth.login()
        }.then {
            KakaoAuth.getUID()
        }.then {
            self.apiCall(type: .kakao, UID: $0)
        }.catch {
            logger($0.localizedDescription)
        }
    }
}

///Facebook Login
extension SignInViewController {
    private func facebookButtonDidTap() {
        Promise.start {
            FacebookAuth.login()
        }.then { _ in
            FacebookAuth.getUID()
        }.then {
            logger($0)
        }.catch {
            logger($0)
        }
    }
    
    private func addNotificationForFaceBookLogin() {
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: .main) { notification in
            guard isChangeUser(notification) else { return }
            
            guard let useId: String = AccessToken.current?.userID else { return }
            self.apiCall(type: .facebook, UID: useId)
        }
        
        func isChangeUser(_ notification: Notification) -> Bool {
            ((notification.userInfo?[AccessTokenDidChangeUserIDKey]) != nil) as Bool
        }
    }
}

///Apple Login
extension SignInViewController {
    private func appleButtonDidTap() {
        let request: ASAuthorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        let userId: String = credential.user
        apiCall(type: .apple, UID: userId)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        logger("애플 로그인 에러")
        logger(error)
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
