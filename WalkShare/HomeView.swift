//
//  HomeView.swift
//  WalkShare
//
//  Created by 加藤 on 2024/03/28.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Home()
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
