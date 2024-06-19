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
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if authViewModel.isSignedIn {
                TutorialView()
            } else {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("ようこそ、アプリ名〇〇へ！")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .padding(.top, -150)
                    GoogleSignInButton(action: authViewModel.handleSignInButton)
                }
                .padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}

