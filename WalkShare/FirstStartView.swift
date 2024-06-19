//
//  FirstStartView.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/05/31.
//

import SwiftUI

struct FirstStartView: View {
    var body: some View {
        Text("アプリ名〇〇を\n始めよう！")
            .font(.system(size: 40, weight: .bold, design: .default))
            .padding(.top, -100)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    FirstStartView()
}
