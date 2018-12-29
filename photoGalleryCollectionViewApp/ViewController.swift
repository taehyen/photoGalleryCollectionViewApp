//
//  ViewController.swift
//  photoGalleryCollectionViewApp
//
//  Created by innergraph on 28/12/2018.
//  Copyright © 2018 taehyen. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	
	var itemWidth: Double = 0
	var assets: PHFetchResult<PHAsset>?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.delegate = self
		collectionView.dataSource = self
		
		let itemCountInLine: Double = 3
		let collectionViewFlowlayout = UICollectionViewFlowLayout()
		collectionViewFlowlayout.minimumLineSpacing = 1.0
		collectionViewFlowlayout.minimumInteritemSpacing = 1.0
		let itemWidth: Double = (Double(collectionView.frame.size.width) / itemCountInLine) - (Double(collectionViewFlowlayout.minimumInteritemSpacing) * (itemCountInLine - 1))
		collectionViewFlowlayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		collectionView.collectionViewLayout = collectionViewFlowlayout
		
		readyForPhotoLibrary()
	}
	
	private func readyForPhotoLibrary() {
		if PHPhotoLibrary.authorizationStatus() == .authorized {
			reloadAssets()
		} else {
			PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
				if status == .authorized {
					self.reloadAssets()
				}
			})
		}
	}
	
	private func reloadAssets() {
		assets = nil
		collectionView.reloadData()
		assets = PHAsset.fetchAssets(with: .image, options: nil)
		collectionView.reloadData()
	}
}

extension ViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let assets = assets else { return }
		
		let size = Double(collectionView.frame.size.width)
		PHCachingImageManager.default().requestImage(for: assets[indexPath.row], targetSize: CGSize(width: size, height: size), contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
			(cell as! CustomCollectionViewCell).imageView.image = image
		}
	}
}

extension ViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (assets != nil) ? assets!.count : 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
	}
}


