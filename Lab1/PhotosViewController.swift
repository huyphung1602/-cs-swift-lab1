//
//  PhotosViewController.swift
//  Lab1
//
//  Created by Chau Vo on 10/12/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var photos = [NSDictionary]()
    let refreshControl = UIRefreshControl()
    let accessToken = "435569061.c66ada7.d12d19c8687e427591f254586e4f3e47"
    let userId = "435569061"
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
//        let accessToken = "Put your client id here"
//        let userId = "Put your user id here"
        url = URL(string: "https://api.instagram.com/v1/users/\(userId)/media/recent/?access_token=\(accessToken)")

        refreshControl.addTarget(self, action: #selector(PhotosViewController.fetchData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        fetchData()

//
//        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
//        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        loadingView.startAnimating()
//        loadingView.center = tableFooterView.center
//        tableFooterView.addSubview(loadingView)
//        self.tableView.tableFooterView = tableFooterView
    }

    func fetchData() {
        if let url = url {
            let request = URLRequest(
                url: url,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main)
            let task = session.dataTask(
                with: request,
                completionHandler: { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            if let photoData = responseDictionary["data"] as? [NSDictionary] {
                                self.photos = photoData
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                        }
                    }
            })
            task.resume()
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PhotoDetailsViewController, let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            destinationVC.selectedPhotoUrlString = photos[indexPath.row].value(forKeyPath: "images.standard_resolution.url") as? String
        }
    }

}

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        if let urlString = photos[indexPath.section].value(forKeyPath: "images.standard_resolution.url") as? String, let url = URL(string: urlString) {
            cell.photoImageView.setImageWith(url)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)

        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1

        if let urlString = photos[section].value(forKeyPath: "user.profile_picture") as? String, let url = URL(string: urlString) {
            profileView.setImageWith(url)
        }

        headerView.addSubview(profileView)
        
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 200, height: 30))
        label.text = photos[section].value(forKeyPath: "user.username") as? String ?? "Anonymous"
        headerView.addSubview(label)

        return headerView
    }

}
