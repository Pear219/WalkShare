//
//  TutorialView.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/05/14.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("〇〇(アプリ名)へようこそ！")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .padding(.top, -150)
                Text("このアプリは他の人とウォーキングのコースを\n共有できるアプリです")
                    .font(.system(size: 15, weight: .light, design: .default))
                    .padding(.top, -80)
                NavigationLink(destination: SetNameView()) {
                    Text("次へ")
                }
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TutorialView()
}
