//
//  WalkingView.swift
//  WalkShare
//
//  Created by 加藤 on 2024/03/28.
//

import SwiftUI
import MapKit

struct IdentifiableCoordinate: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct WalkingView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var pinLocation: IdentifiableCoordinate?
    @State private var distanceFromCurrentLocation: CLLocationDistance?
//    @State private var  travelTime = Int.self

    var body: some View {
        ZStack {
            MapViewRepresentable(region: $region, pinLocation: $pinLocation, distanceFromCurrentLocation: $distanceFromCurrentLocation, locationManager: locationManager)
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 360, height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke((Color(hex: "#39FF14")), lineWidth: 3)
                        )
                        .shadow(radius: 5)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("現在地")
                                .font(.title)
                                .fontWeight(.heavy)
                            Text(locationManager.address)
                                .font(.headline)
                                .fontWeight(.semibold)
                            if let distance = distanceFromCurrentLocation {
                                /*\(String(format: "%.2f", distance)*/
                                let travelTime = String(format: "%.2f", distance)
                                let travel = distance / 80 // Convert to minutes (assuming 80 meters per minute)
                                let travelTimeRounded = Int(travel) // Convert to integer to remove decimals
                                Text("所要時間:  \(travelTimeRounded)分")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("所要時間はあくまで目安です")
                                    .font(.footnote)
                                    .fontWeight(.light)
                            }
                        }
                        .padding(.leading, 30)
                        Button(action: {
                            locationManager.requestLocation()
                            
                        }) {
                            Text("開始")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 120, height: 120)
                                .background(Circle().fill(Color(hex: "#39FF14")))
                        }
                        .padding(.trailing, 30)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            locationManager.requestAuthorization()
            locationManager.requestLocation()
        }
    }
}

struct WalkingView_Previews: PreviewProvider {
    static var previews: some View {
        WalkingView()
    }
}


