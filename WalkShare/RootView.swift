//
//  ContentView.swift
//  WalkShare
//
//  Created by 加藤 on 2024/03/27.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    var body: some View {
        TabBar()
//            .fullScreenCover(isPresented: $isFirstLaunch) {
//                LoginView()
//            }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
//Preview書くとクラッシュしちゃうので閉じた
