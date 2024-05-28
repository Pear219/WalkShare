//
//  SetNameView.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/05/16.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Firebase

struct SetNameView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var nameTextField: String = ""
    private var db = Firestore.firestore()
    @State private var isNextCityViewActive = false // 追加：次のビューがアクティブかどうかを示す状態変数
    

    var body: some View {
        VStack {
            Text("名前を入力してください")
                .font(.system(size: 30, weight: .heavy, design: .default))
                .padding(.top, -230)
            Text("本名は入力しないでください")
                .font(.system(size: 20, weight: .regular, design: .default))
                .padding(.top, -200)
            TextField("名前を入力してください", text: $nameTextField)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
                .padding(.top, -170)
            NavigationLink(destination: SetCityView(), isActive: $isNextCityViewActive) {
                EmptyView()
            }
            Button(action: {
                saveNameToFirestore()
                isNextCityViewActive = true
            }) {
                Text("次へ")
                    .frame(width: 300, height: 50)
                    .background(Color(hex: "#39FF14"), in: RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
                    .font(.system(size: 15, weight: .heavy, design: .default))
            }.multilineTextAlignment(.center)
        }
    }
    
    func saveNameToFirestore() {
        guard authViewModel.isSignedIn else {
            print("userログインしてない")
            return
        }
        
        let userData: [String: Any] = [
            "name": nameTextField
        ]
        
        if let currentUser = Auth.auth().currentUser {
            let userUid = currentUser.uid
            let userDocRef = db.collection("user").document(userUid)
        
            userDocRef.setData(userData, merge: true) { error in
                if let error = error {
                    print("ドキュメント追加失敗: \(error)")
                } else {
                    print("ドキュメントをこのidに追加したよ: \(userDocRef.documentID)")
                }
            }
        }
    }
}



#Preview {
    SetNameView()
}
