//
//  HomeView.swift
//  WalkShare
//
//  Created by 加藤 on 2024/03/28.
//

import SwiftUI

struct TabBar: View {
    @State var tabSelectedId: Int = 1
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(1)
            WalkingView()
                .tabItem {
                    Image(systemName: "figure.walk")
                }
                .tag(2)
        }
        
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
