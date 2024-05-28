//
//  SeyIconView.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/05/16.
//

import SwiftUI

struct SetIconView: View {
    @State private var city: String = ""
    var body: some View {
        VStack {
            Picker(selection: $city, label: Text("フルーツ")) {
            Text("apple").tag(0)
            Text("banana").tag(1)
            Text("orange").tag(2)
            }
        .pickerStyle(WheelPickerStyle())
        }
    }
}

#Preview {
    SetIconView()
}
