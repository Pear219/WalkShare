//
//  LoginView.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/05/12.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift


struct LoginView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            GoogleSignInButton(action: handleSignInButton)
        }
        .padding()
    }
    func handleSignInButton() {

        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
                
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
            if let error = error {
                print("Google sign in failed: \(error.localizedDescription)")
                return
            }
            
            // Google sign in succeeded, now you can handle the user object
            if let user = user {
                print("Google sign in succeeded. User: \(user)")
                // Here you can handle the signed-in user, for example, you can use Firebase Authentication to sign in the user
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
