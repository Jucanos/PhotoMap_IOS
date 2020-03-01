//
//  ImagePicker.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/24.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Combine
import YPImagePicker

final class ImagePicker: ObservableObject {
    static let shared : ImagePicker = ImagePicker()
    private init() {}  //force using the singleton: ImagePicker.shared
    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()
    
    // Bindable Object part
    let willChange = PassthroughSubject<UIImage, Never>()
    @Published var image: UIImage? {
        didSet {
            if image != nil {
                willChange.send(image!)
            }
        }
    }
}

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            ImagePicker.shared.image = uiImage
            picker.dismiss(animated:true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated:true)
        }
    }
    
    struct View: UIViewControllerRepresentable {
        func makeCoordinator() -> Coordinator {
            ImagePicker.shared.coordinator
        }
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker.View>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "NanumSquareRoundR", size: 20)!]
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().backgroundColor = appColor
            UINavigationBar.appearance().isTranslucent = true
            
            return picker
        }
        func updateUIViewController(_ uiViewController: UIImagePickerController,
                                    context: UIViewControllerRepresentableContext<ImagePicker.View>) {
        }
    }
}

class MyImagePicker: ObservableObject {
    static let shared: MyImagePicker = MyImagePicker()
    let view = MyImagePicker.View()
    
    let willChange = PassthroughSubject<[UIImage], Never>()
    @Published var images: [UIImage] = [] {
        didSet{
            if !images.isEmpty {
                willChange.send(images)
            }
        }
    }
}


extension MyImagePicker{
    
    struct View: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> YPImagePicker {
            MyImagePicker.shared.images.removeAll()
            var config = YPImagePickerConfiguration()
            
            config.startOnScreen = YPPickerScreen.library
            config.shouldSaveNewPicturesToAlbum = false
            config.library.maxNumberOfItems = 5
            config.wordings.libraryTitle = "갤러리"
            config.wordings.cameraTitle = "카메라"
            config.wordings.next = "다음"
            config.wordings.filter = "필터"
            config.wordings.cancel = "취소"
            
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "NanumSquareRoundB", size: 17)!]
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, cancelled in
                if cancelled {
                    MyImagePicker.shared.images.removeAll()
                }
                for item in items {
                    switch item {
                    case .photo(let photo):
                        MyImagePicker.shared.images.append(photo.image)
                    case .video(let video):
                        print(video)
                    }
                }
                picker.dismiss(animated: true, completion: nil)
            }
            
            return picker
        }
        func updateUIViewController(_ uiViewController: YPImagePicker, context: UIViewControllerRepresentableContext<MyImagePicker.View>) {
            
        }
    }
}
