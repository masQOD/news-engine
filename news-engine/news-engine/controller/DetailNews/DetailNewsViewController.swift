//
//  DetailNewsViewController.swift
//  news-engine
//
//  Created by Qodir Masruri on 03/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailNewsViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    
    var news = NewsObj()
    var comments = [CommentsObj]()
        
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let idPost = news.idPost else { return }
        self.fetchComments(postId: idPost)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(news)
        // Do any additional setup after loading the view.
        setupView()
        setupTable()
    }
    
    private func setupView(){
        title = news.company
        usernameLabel.text = news.username
        titleLabel.text = news.title
        contentLabel.text = news.body
    }
    
    private func setupTable(){
        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.register(UINib.init(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension DetailNewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CommentsTableViewCell
        return cell
    }
}

extension DetailNewsViewController {
    private func fetchComments(postId: Int){
        let url = Contants.Endpoints.urlComments+"?postId=\(postId)"
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    if let rawData = try? JSON(data).rawData() {
                        if let decoded = try? JSONDecoder().decode(ListCommentsResponse.self, from: rawData) {
//                            completion(decoded)
                        }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
}
