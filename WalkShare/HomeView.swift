//
//  Home.swift
//  WalkShare
//
//  Created by 加藤 on 2024/03/28.
//

import SwiftUI

struct Friend: Identifiable {
    var id = UUID()
    var ranking: String
    var image: String
    var name: String
    var walking: String
}
struct Home: View {
    @State var name = "名前"
    @State var prefecture = "都道府県"
    @State var city = "市区町村"
    
    init () {
        UITableView.appearance().backgroundColor = .clear
    }
    
    let friendsRanking = [
        Friend(ranking: "1", image: "image1", name: "name1", walking: "walking1"),
        Friend(ranking: "2", image: "image2", name: "name2", walking: "walking2"),
        Friend(ranking: "3", image: "image3", name: "name3", walking: "walking3"),
        Friend(ranking: "3", image: "image3", name: "name3", walking: "walking3"),
        Friend(ranking: "3", image: "image3", name: "name3", walking: "walking3")
        ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#F4F5F7").edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        Button {
                            //多分ここにactionを書く
                        } label: {
                            Text("ボタン")
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 310, height: 180) //臨機応変に
                        .background(Color.white)
                        .cornerRadius(12) // セルの角を丸める
                        .shadow(color: Color.black, radius: 4, x: 1, y: 1)
                        //                        .border(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.clear)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "#39FF14"), lineWidth: 3)
                                )
                        )
                        .padding(.top, 50) //ボタン全体の位置決め
//                        HStack {
//                            Image(systemName:"person")
//                                .font(.system(size: 80))
//                        }
                    }
                    List {
                        ForEach(friendsRanking) { friend in
                            VStack {
                                HStack {
                                    Text(friend.ranking)
                                        .padding(.leading, 1)
                                    Image(friend.image)
                                        .resizable() //動的にサイズ変更
                                        .frame(width: 56, height: 56)
                                        .padding(.leading, 19)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                    Text(friend.name)
                                    Text(friend.walking)
                                }
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))  // Important!
                    .scrollContentBackground(.hidden)
                    .padding(.top, 0)
//                    .background(.clear)
                    .frame(width: 350, height: 450)
                    .aspectRatio(contentMode: .fit)
                }
            }
//            .navigationBarTitle("Home")
        }
    }
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: 1
        )
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
