//
//  ImageDownloadHelper.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

protocol ImageDownloaderHelperProtocol {
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ())
}


class ImageDownloaderHelper: ImageDownloaderHelperProtocol {
    
    let urlSession: URLSession = URLSession.shared
    
    static var shared: ImageDownloaderHelper = {
       return ImageDownloaderHelper()
    }()
    
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
        urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion(UIImage(data: data), response, error)
            } else {
                completion(nil, response, error)
            }
        }.resume()
    }
    
}

class MockImageDownloadHelper: ImageDownloaderHelperProtocol {

    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
    
        DispatchQueue.global().async {
            usleep(1000000 + (arc4random() % 9)*100000)
            let images = ["sample", "sample2", "sample3", "sample4", "sample5", "profile"]
            let idx = Int(arc4random()) % images.count
            let randName = images[idx]
            let image = UIImage(contentsOfFile: Bundle.main.path(forResource: randName, ofType: "jpg")!)
            completion(image, nil, nil)
        }
        
    }
}




import UIKit

class DetailView: NibView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentDetails: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelFooterDetail: UILabel!
    
    var commonConstraints = [NSLayoutConstraint]()
    var iphoneConstraints = [NSLayoutConstraint]()
    var iPadPortraitConstraints = [NSLayoutConstraint]()
    var iPadLandscapeConstraints = [NSLayoutConstraint]()
    
    var isLandscape: Bool {
        if let window = UIApplication.shared.windows.first {
            let fr = window.frame
            if fr.width > fr.height {
                return true
            }
        }
        return false
    }
    
    func initialSetup() {
        self.addFonts()
        self.disableAutoResize()
        self.setHuggingResistance()
        self.setupCommonConstraints()
        self.setupCompactWidthRegularHeight()
        self.setupIpadLayout(isLandscape: false)
        
        self.imageView.image = UIImage(named: "stock.jpg")
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        
        self.labelTitle.text = ""
        self.labelDetail.text = ""
        self.labelFooterDetail.text = ""
        
        self.updateLayoutConstraint(sizeClass: traitCollection.horizontalSizeClass)
    }
    
    func updateLayoutConstraint(sizeClass: UIUserInterfaceSizeClass) {
        traitCollection.horizontalSizeClass == .compact ? compactLayout() : regularLayout()
    }
    
    func compactLayout() {
        NSLayoutConstraint.activate(self.commonConstraints)
        NSLayoutConstraint.activate(self.iphoneConstraints)
        NSLayoutConstraint.deactivate(self.iPadPortraitConstraints)
    }
    
    func regularLayout() {
        NSLayoutConstraint.activate(self.commonConstraints)
        NSLayoutConstraint.activate(self.iPadPortraitConstraints)
        NSLayoutConstraint.deactivate(self.iphoneConstraints)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass && traitCollection.horizontalSizeClass == .compact {
            // It either changed from Width-Comptact to Width-Regular or viceversa
            // for Compact width => design should look like iPhone
            // for Regular width => design should look like iPad
            // iPad for both portrait and landscape orientation, sizeclasses will be same but it changes for 1/3,2/3,1/2 split screen
            // iPad portrait split => 2/3, 1/3 it is compact width
            // iPad landscape split => 1/3 is compact width & 2/3,1/2 is regular width
            
            // ======== iPhone layout, iPad split layout ========
            self.compactLayout()
            
        } else {
            // There is no change in horizontal size class.
            // For iPad check for Portrait and Landscape orientation for diffent layouts.
            if traitCollection.horizontalSizeClass != .compact {
                self.regularLayout()
            }
        }
    }
    
}

extension DetailView {
    private func addFonts() {
        self.labelTitle.dynamicTypeFont(style: .headline)
        self.labelDetail.dynamicTypeFont(style: .body)
        self.labelFooterDetail.dynamicTypeFont(style: .caption1)
        
        self.labelTitle.addMultiLine()
        self.labelDetail.addMultiLine()
        self.labelFooterDetail.addMultiLine()
    }
    
    private func disableAutoResize() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentDetails.translatesAutoresizingMaskIntoConstraints = false
        self.labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.labelDetail.translatesAutoresizingMaskIntoConstraints = false
        self.labelFooterDetail.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setHuggingResistance() {
        self.labelTitle.setContentHuggingPriority(UILayoutPriority.init(253), for: .vertical)
        self.labelTitle.setContentCompressionResistancePriority(UILayoutPriority.init(753), for: .vertical)

        self.labelDetail.setContentHuggingPriority(UILayoutPriority.init(252), for: .vertical)
        self.labelDetail.setContentCompressionResistancePriority(UILayoutPriority.init(752), for: .vertical)

        self.labelFooterDetail.setContentHuggingPriority(UILayoutPriority.init(251), for: .vertical)
        self.labelFooterDetail.setContentCompressionResistancePriority(UILayoutPriority.init(751), for: .vertical)
        
    }
    
    func setupCommonConstraints() {
        self.commonConstraints = [
            self.labelTitle.topAnchor.constraint(equalTo: self.contentDetails.topAnchor, constant: 5),
            self.labelTitle.leadingAnchor.constraint(equalTo: self.contentDetails.leadingAnchor, constant: 0),
            self.labelTitle.trailingAnchor.constraint(equalTo: self.contentDetails.trailingAnchor, constant: -8),
            self.labelTitle.bottomAnchor.constraint(equalTo: self.labelDetail.topAnchor, constant: -8),
            self.labelDetail.leadingAnchor.constraint(equalTo: self.contentDetails.leadingAnchor, constant: 0),
            self.labelDetail.trailingAnchor.constraint(equalTo: self.contentDetails.trailingAnchor, constant: -8),
            self.labelDetail.bottomAnchor.constraint(equalTo: self.labelFooterDetail.topAnchor, constant: -8),
            self.labelFooterDetail.leadingAnchor.constraint(equalTo: self.contentDetails.leadingAnchor, constant: 0),
            self.labelFooterDetail.trailingAnchor.constraint(equalTo: self.contentDetails.trailingAnchor, constant: -8),
            self.labelFooterDetail.bottomAnchor.constraint(equalTo: self.contentDetails.bottomAnchor, constant: -8),
            
            self.imageView.topAnchor.constraint(equalTo: self.imageView.superview!.topAnchor, constant: 5),
            self.imageView.leadingAnchor.constraint(equalTo: self.imageView.superview!.leadingAnchor, constant: 0),
            
            self.contentDetails.trailingAnchor.constraint(equalTo: self.contentDetails.superview!.trailingAnchor, constant: 0),
            self.contentDetails.bottomAnchor.constraint(equalTo:  self.contentDetails.superview!.bottomAnchor, constant: -8),
        ]
        
    }
    
    // iPhone layout
    func setupCompactWidthRegularHeight() {
        self.iphoneConstraints = [
            self.imageView.trailingAnchor.constraint(equalTo: self.imageView.superview!.trailingAnchor, constant: 0),
            self.imageView.heightAnchor.constraint(lessThanOrEqualTo: self.imageView.widthAnchor, multiplier: 0.4),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentDetails.topAnchor, constant: -8),
            
            self.contentDetails.leadingAnchor.constraint(equalTo: self.contentDetails.superview!.leadingAnchor, constant: 0),

        ]
    }
    
    func setupIpadLayout(isLandscape: Bool) {
        let width_proportional: CGFloat = self.isLandscape ? 0.5 : 0.65
        let bottom_imageView_superview = self.imageView.bottomAnchor.constraint(greaterThanOrEqualTo: self.imageView.superview!.bottomAnchor, constant: -8)
//        bottom_imageView_superview.priority = UILayoutPriority.init(999)
                
        self.iPadPortraitConstraints = [
            self.imageView.trailingAnchor.constraint(equalTo: self.contentDetails.leadingAnchor, constant: -10),
//            bottom_imageView_superview,
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.superview!.widthAnchor, multiplier: width_proportional),
            self.imageView.heightAnchor.constraint(greaterThanOrEqualTo: self.imageView.widthAnchor, multiplier: width_proportional),
            self.contentDetails.topAnchor.constraint(equalTo: self.contentDetails.superview!.topAnchor, constant: 5),
//            self.imageView.heightAnchor.constraint(lessThanOrEqualTo: self.contentDetails.heightAnchor)
//            self.imageView.bottomAnchor.constraint(equalTo: self.contentDetails.bottomAnchor, constant: 5)
        ]
    }
}




import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detail view"
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
    }


}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionCell", for: indexPath) as? DetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}
