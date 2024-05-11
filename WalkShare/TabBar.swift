//
//  HomeView.swift
//  WalkShare
//
//  Created by 加藤 on 2024/03/28.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            WalkingView()
                .tabItem {
                    Image(systemName: "figure.walk")
                }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
