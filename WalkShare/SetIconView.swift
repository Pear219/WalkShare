//
//  SeyIconView.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/05/16.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import Firebase
import FirebaseStorage

struct SetIconView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    private var db = Firestore.firestore()
    @State var selectedItems: [PhotosPickerItem] = []
    @State var images = UIImage(systemName: "person.circle")!
    @State var isNextStartViewActive = false
    @State private var uploadProgress: Double = 0

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 1,
                matching: .images
            ) {
                Text("アイコンを選択")
                    .padding(.top, 100)
            }
            .onChange(of: selectedItems) { newItems in
                for newItem in newItems {
                    loadImage(from: newItem)
                }
            }

            Image(uiImage: images)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .clipped()
                .padding(.top, -270)
            
            NavigationLink(destination: FirstStartView(), isActive: $isNextStartViewActive) {
                EmptyView()
            }
            
            Button(action: {
                uploadImageToFirebase()
                isNextStartViewActive = true
            }) {
                Text("次へ")
                    .frame(width: 300, height: 50)
                    .background(
                        Color(hex: "#39FF14"),
                        in: RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
                    .font(.system(size: 15, weight: .heavy, design: .default))
                    .padding(.top, 20)
            }
        }
    }

    private func loadImage(from item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data?):
                    if let image = UIImage(data: data) {
                        images = image
                    } else {
                        print("画像データの変換に失敗しました")
                    }
                case .success(nil):
                    print("データが見つかりません")
                case .failure(let error):
                    print("画像の読み込みに失敗しました: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func uploadImageToFirebase() {
        guard let imageData = images.jpegData(compressionQuality: 0.8) else { return }

        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uploadTask = imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    saveIconURLToFirestore(url: url)
                }
            }
        }

        uploadTask.observe(.progress) { snapshot in
            uploadProgress = Double(snapshot.progress?.fractionCompleted ?? 0)
        }

        uploadTask.observe(.success) { snapshot in
            print("Upload completed successfully")
        }

        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                print("Upload failed: \(error.localizedDescription)")
            }
        }
    }

    private func saveIconURLToFirestore(url: URL) {
        guard authViewModel.isSignedIn else {
            print("userログインしてない")
            return
        }

        if let currentUser = Auth.auth().currentUser {
            let userUid = currentUser.uid
            let userDocRef = db.collection("user").document(userUid)

            userDocRef.setData(["iconURL": url.absoluteString], merge: true) { error in
                if let error = error {
                    print("ドキュメント追加失敗: \(error)")
                } else {
                    print("ドキュメントをこのidに追加したよ: \(userDocRef.documentID)")
                }
            }
        }
    }
}


#Preview {
    SetIconView()
}
