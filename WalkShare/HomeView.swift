import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Firebase
import FirebaseStorage

struct Friend: Identifiable {
    var id = UUID()
    var ranking: String
    var image: String
    var name: String
    var walking: String
}

struct HomeView: View {
    private var db = Firestore.firestore()
    @State var name: String = "名前"
    @State var prefecture = "都道府県"
    @State var city = "市区町村"
    @State var icon: UIImage? = nil
    private var storage = Storage.storage()
    
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
                    Button {
                        //多分ここにactionを書く
                    } label: {
                        HStack {
                            if let icon = icon {
                                Image(uiImage: icon)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding(.leading, 30) // 必要に応じてパディングを調整
                            }
                            VStack(alignment: .leading) {
                                Text(name)
                                    .font(.system(size: 30, weight: .bold, design: .default))
                                    .foregroundColor(.black) // テキストの色を黒に設定
                                Text(prefecture)
                                    .font(.system(size: 20, weight: .light, design: .default))
                                    .foregroundColor(.black) // テキストの色を黒に設定
                            }
                            .padding(.leading, 30) // 必要に応じてパディングを調整
                            Spacer()
                        }

                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 310, height: 180) // 必要に応じてサイズを調整
                    .background(Color.white)
                    .cornerRadius(12) // セルの角を丸める
                    .shadow(color: Color.black, radius: 4, x: 1, y: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.clear)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#39FF14"), lineWidth: 3)
                            )
                    )
                    .padding(.top, 30)
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
                    .frame(width: 350, height: 450)
                    .aspectRatio(contentMode: .fit)
                }
            }
        }
        .multilineTextAlignment(.center)
        .onAppear {
            getData()
        }
    }
    
    func getData() {
        if let currentUser = Auth.auth().currentUser {
            let userUid = currentUser.uid
            let userDocRef = db.collection("user").document(userUid)
            userDocRef.getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    if let document = documentSnapshot, document.exists {
                        if let imageURL = document.data()?["iconURL"] as? String {
                            let storageRef = self.storage.reference(forURL: imageURL)
                            storageRef.getData(maxSize: 1*1024*1024) { (data, error) in
                                if let error = error {
                                    print("画像のダウンロードエラー: \(error)")
                                } else {
                                    if let data = data, let image = UIImage(data: data) {
                                        self.name = document.get("name") as? String ?? "No name found"
                                        self.icon = image
                                        self.prefecture = document.get("city") as? String ?? "No prefecture"
                                    }
                                }
                            }
                        }
                    } else {
                        userDocRef.getDocument { (documentSnapshot, error) in
                            if let error = error {
                                print("Error getting document: \(error)")
                            } else {
                                print("ここ")
                            }
                        }
                    }
                }
            }
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
