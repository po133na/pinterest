//
//  PinterestViewModel.swift
//  pinterest
//
//  Created by Polina Stelmakh on 03.04.2025.
//

import Foundation

class PinterestViewModel: ObservableObject {
    @Published var images: [PinterestModel] = []
    @Published var errorMessage: String?
    
    func fetchImages() {
        let group = DispatchGroup()
        var newImages = [PinterestModel]()
        let queue = DispatchQueue(label: "com.gallery.imageFetch", attributes: .concurrent)
        let syncQueue = DispatchQueue(label: "com.gallery.syncQueue") // Очередь для синхронизации

        for _ in 1...5 {
            group.enter()
            queue.async {
                let id = UUID().uuidString
                let urlString = "https://picsum.photos/200/300?random=\(id)"
                
                guard let url = URL(string: urlString), let _ = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error loading image"
                    }
                    group.leave()
                    return
                }

                let image = PinterestModel(id: id, url: urlString)
                
                syncQueue.async {
                    newImages.append(image)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.images.append(contentsOf: newImages) // Обновление UI одним разом
        }
    }
    
    func retryLoading(image: PinterestModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            let newUrl = "https://picsum.photos/200/300?random=\(UUID().uuidString.prefix(8))"
            DispatchQueue.main.async {
                if let index = self.images.firstIndex(where: { $0.id == image.id }) {
                    self.images[index] = PinterestModel(id: image.id, url: newUrl)
                }
            }
        }
    }
}
