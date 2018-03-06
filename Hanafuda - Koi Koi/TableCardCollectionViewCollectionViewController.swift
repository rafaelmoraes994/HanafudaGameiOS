//
//  TableCardCollectionViewCollectionViewController.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 3/2/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class TableCardCollectionViewCollectionViewController: KDDragAndDropCollectionView {
    
    override func canDragAtPoint(_ point: CGPoint) -> Bool {
        let condition = false
        return super.canDragAtPoint(point) && condition
    }

}
