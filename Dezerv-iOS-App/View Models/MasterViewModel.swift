//
//  MasterViewModel.swift
//  Dezerv-iOS-App
//
//  Created by Harsh Kumar Agrawal on 18/04/23.
//

import Foundation
import UIKit

protocol MasterViewModelDelegate {
    func updateUI()
    func updateCellAt(_ indexPath: IndexPath)
}

class MasterViewModel {
    
    // MARK: Private Properties
    private var apparelList: Apparels? {
        didSet {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else {return}
                self.downloadImages()
                self.makeApparelMap()
                self.delegate?.updateUI()
            }
        }
    }
    private var apparelMap = [Int : Apparel]()
    var categoryApparelMap = [Category : Apparels]()
    private var apparelImages = [Int : UIImage]()
    private var counts: Int = 0
    
    var delegate: MasterViewModelDelegate?
}

// MARK: Fetch Data and Parse
extension MasterViewModel {
    
    func makeNetworkCall(_ urlString: String = Constants.URL) {
        
        NetworkManager.shared.apiCall(urlString) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let data):
                strongSelf.decodeData(data)
                
            case .failure(let error):
                print(error, "--")
            }
        }
    }
    
    private func decodeData(_ data: Data) {
        
        if let responseData = try? JSONDecoder().decode(Apparels.self, from: data) {
            self.apparelList = responseData
        } else {
            print(NetworkError.unableToParse)
        }
    }
    
    
    private func makeApparelMap() {
        guard let apparelList = apparelList else {return}
        for item in apparelList {
            apparelMap[item.id] = item
            guard let category = item.category else { return }
            if categoryApparelMap[category] != nil{
                categoryApparelMap[category]?.append(item)
            } else {
                categoryApparelMap[category] = [item]
            }
        }
    }
    
    private func downloadImages() {
        guard let apparelData = self.apparelList else { return }
        
        for item in apparelData {
           // self.counts += 1
            guard let url = item.image else { return }
            
            NetworkManager.shared.downloadImage(from: url) { [weak self] image, error in
                guard let self = self else {return}
                
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    self.apparelImages[item.id] = UIImage(named: "image-404")
                } else if let image = image {
                    self.apparelImages[item.id] = image
                }
                
                self.delegate?.updateCellAt(IndexPath(row: item.id - 1, section: 0))
            }
        }
    }
}

// MARK: Data transfer Methods
extension MasterViewModel: ApparelCellViewModelDelegate {
    func getApparelDataAtID(_ id: Int) -> Apparel? {
        return apparelMap[id]
    }
    
    func getImageAtID(_ id: Int) -> UIImage? {
        return apparelImages[id]
    }
    
    func getApparelCount() -> Int {
        return apparelList?.count ?? 1
    }
}
