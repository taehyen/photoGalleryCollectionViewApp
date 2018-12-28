//
//  CustomPhotoAlbum.swift
//  photoGalleryCollectionViewApp
//
//  Created by innergraph on 28/12/2018.
//  Copyright © 2018 taehyen. All rights reserved.
//

import Photos

class CustomPhotoAlbum {
	
	static let albumName = "Album"
	static let sharedInstance = CustomPhotoAlbum()
	
	var assetCollection: PHAssetCollection!
	
	init() {
		func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
			
			let fetchOptions = PHFetchOptions()
			fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
			let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
			
			if let firstObject: AnyObject = collection.firstObject {
				return firstObject as? PHAssetCollection
			}
			
			return nil
		}
		
		if let assetCollection = fetchAssetCollectionForAlbum() {
			self.assetCollection = assetCollection
			return
		}
		
		PHPhotoLibrary.shared().performChanges({
			PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
		}) { success, _ in
			if success {
				self.assetCollection = fetchAssetCollectionForAlbum()
			}
		}
	}
	
	func saveImage(image: UIImage) {
		
		if assetCollection == nil {
			return   // If there was an error upstream, skip the save.
		}
		
		PHPhotoLibrary.shared().performChanges({
			let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
			let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
			let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
			albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
		}, completionHandler: nil)
	}
}
