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
import Toast_Swift

class UserDetailViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var albumTable: UITableView!
    
    private var news = NewsObj()
    private var albums = [AlbumsObj]()
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoName = self.albums[indexPath.row].titlePhoto
        let url = self.albums[indexPath.row].url
        let vc = DetailPhotoUserViewController(albums: photoName, selectedPhoto: url)
        self.navigationController?.pushViewController(vc, animated: true)
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
                            self.view.makeToastActivity(.center)
                            self.createAlbums(for: decoded)
                        }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func fetchPhoto(albumId: Int, completion: @escaping ((Result<Any, AFError>) -> Void)) {
        let url = Contants.Endpoints.urlPhotos+"?albumId=\(albumId)"
        AF.request(url)
            .validate()
            .responseJSON { response in
                completion(response.result)
            }
        
    }
    
    private func createAlbums(for albums: ListAlbumsResponse) {
        
        guard let album = albums.first else {
            return
        }
        
        self.fetchPhoto(albumId: album.id ?? 0) { result in
            switch result {
            case let .success(data):
                if let rawData = try? JSON(data).rawData() {
                    if let decoded = try? JSONDecoder().decode(ListPhotosResponse.self, from: rawData) {
                        // Album Recursion
                        self.createAlbums(for: Array(albums.dropFirst()))
                        self.populatePhotos(with: decoded.reversed(), album: album)
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func populatePhotos(with photos: ListPhotosResponse, album: AlbumResponseElement) {
        guard let photo = photos.first else {
            DispatchQueue.main.async {
                self.albumTable.reloadData()
                self.view.hideToastActivity()
            }
            return
        }
        
        let albumObj = AlbumsObj(
            userId: album.userId ?? 0,
            albumId: album.id ?? 0,
            titleAlbum: album.title ?? "",
            photoId: photo.id ?? 0,
            titlePhoto: photo.title ?? "",
            url: photo.url ?? "",
            thumbnailUrl: photo.thumbnailUrl ?? ""
        )
        // Photo Recursion
        self.populatePhotos(with: Array(photos.dropFirst()), album: album)
        self.albums.append(albumObj)
    }
}

