//
//  PhotoCollectionCollectionViewController.swift
//  Day One Clone
//
//  Created by Phizer Cost on 5/13/19.
//  Copyright © 2019 Phizer Cost. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class PhotoCollectionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var pictures : Results<Picture>?

    override func viewWillAppear(_ animated: Bool) {
        getPictures()
    }
    
    func getPictures(){
        if let realm = try? Realm() {
            pictures  = realm.objects(Picture.self)
            collectionView?.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let pictures = self.pictures {
            return pictures.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell{
            
            if let picture = pictures?[indexPath.row]{
                cell.previewImageView.image = picture.thumbnail()
                cell.dayLabel.text = picture.entry?.dayString()
                cell.monthYearLabel.text = picture.entry?.monthYearString()
            }
            return cell
            
            
        }
    
        // Configure the cell
    
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2)
    }


}


class PhotoCell:UICollectionViewCell {
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
}
