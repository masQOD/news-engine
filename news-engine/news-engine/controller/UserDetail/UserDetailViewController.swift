//
//  UserDetailViewController.swift
//  news-engine
//
//  Created by Qodir Masruri on 03/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class UserDetailViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var albumTable: UITableView!
    
    var news = NewsObj()
    var albums = [AlbumsObj]()
    
    convenience init(news: NewsObj){
        self.init(nibName: "UserDetailViewController", bundle: nil)
        self.news = news
        self.fetchAlbumPhoto(userId: news.idUser ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupTable()
    }

    private func setupView(){
        title = news.username
        emailLabel.text = news.email
        addressLabel.text = news.address
        companyLabel.text = news.company
    }

    private func setupTable(){
        albumTable.delegate = self
        albumTable.dataSource = self
        albumTable.register(UINib.init(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AlbumTableViewCell
        cell.albumnameLabel.text = albums[indexPath.row].titleAlbum
        if let imageAlbum = albums[indexPath.row].thumbnailUrl, let url = URL(string: imageAlbum.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!){
            cell.photoImg.kf.setImage(with: url, placeholder: UIImage.init(named: ""), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        }
        return cell
    }
    
    
}

extension UserDetailViewController{
    private func fetchAlbumPhoto(userId: Int){
        let url = Contants.Endpoints.urlAlbums+"?userId=\(userId)"
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    if let rawData = try? JSON(data).rawData() {
                        if let decoded = try? JSONDecoder().decode(ListAlbumsResponse.self, from: rawData) {

                        }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func fetchPhoto(albumId: Int){
        let url = Contants.Endpoints.urlPhotos+"?albumId=\(albumId)"
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    if let rawData = try? JSON(data).rawData() {
                        if let decoded = try? JSONDecoder().decode(ListPhotosResponse.self, from: rawData) {

                        }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
    
   
}
