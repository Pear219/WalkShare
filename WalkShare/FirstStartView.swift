//
//  FirstStartView.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/05/31.
//

import SwiftUI

struct FirstStartView: View {
    @State var isGoHome: Bool = false

    var body: some View {
        Group {
            if isGoHome {
                HomeView()
            } else {
                Text("アプリ名〇〇を\n始めよう！")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .padding(.top, -100)
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            startDelayAndNavigate()
        }
        .fullScreenCover(isPresented: $isGoHome) {
                    HomeView()
        }
    }

    func startDelayAndNavigate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isGoHome = true
        }
    }
}

#Preview {
    FirstStartView()
}

