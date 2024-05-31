//
//  SetCityView.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/05/16.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Firebase

struct SetCityView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    private var db = Firestore.firestore()
    @State var cityTextField: String = ""
    @State var isNextIconViewActive = false // 追加：次のビューがアクティブかどうかを示す状態変数

    var body: some View {
        VStack{
            VStack(spacing: 20) {
                Text("住んでいる都道府県を\n入力してください")
                    .font(.system(size: 30, weight: .heavy, design: .default))
                    .padding(.top, -220)
                Text("あとから非公開設定にすることもできます")
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .padding(.top, -160)
                let prefecture: [String] = [
                    "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
                ]
                Picker("住んでいる都道府県を選択", selection: $cityTextField) {
                    ForEach(prefecture, id: \.self) { prefecture in
                        Text(prefecture)
                    }
                }
                .padding(.horizontal, 50)
                .padding(.top, -140)
            }
                NavigationLink(destination: SetIconView(), isActive: $isNextIconViewActive) {
                    EmptyView()
                }
                Button(action: {
                    isNextIconViewActive = true
                    saveCityToFirestore()
                }) {
                    Text("次へ")
                        .frame(width: 300, height: 50)
                        .background(
                            Color(hex: "#39FF14"),
                            in: RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                        .font(.system(size: 15, weight: .heavy, design: .default))
//                        .padding(.top, -280)
                }
            }
            .multilineTextAlignment(.center)
            .ignoresSafeArea(.keyboard, edges: .all)
    }
    func saveCityToFirestore() {
        guard authViewModel.isSignedIn else {
            print("userログインしてない")
            return
        }
        
        let userData: [String: Any] = [
            "city": cityTextField
            // Add other user data if needed
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
    SetCityView()
}
