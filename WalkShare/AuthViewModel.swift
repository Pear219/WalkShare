import Foundation
import Firebase
import GoogleSignIn

class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false

    init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.isSignedIn = user != nil
        }
    }

    func handleSignInButton() {
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        let config = GIDConfiguration(clientID: clientID)
                
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                print("Googlesignin失敗: \(error.localizedDescription)")
                return
            }
            
            guard let user = signInResult?.user else {
                print("googlesigninない")
                return
            }
            
            guard let idToken = user.idToken?.tokenString else {
                print("GoogleidTokenない")
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebaseサインイン失敗: \(error.localizedDescription)")
                    return
                }
                print("Firebaseサインイン成功")
                self.isSignedIn = true
            }
        }
    }
}
