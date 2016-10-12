//
//  PhotoDetailsViewController.swift
//  Lab1
//
//  Created by Chau Vo on 10/12/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    var selectedPhotoUrlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = selectedPhotoUrlString, let url = URL(string: urlString) {
            photoImageView.setImageWith(url)
        }
    }

}
