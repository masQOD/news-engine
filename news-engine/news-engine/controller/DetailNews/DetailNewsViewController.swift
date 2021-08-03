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
    
    private var news = NewsObj()
    private var comments = [CommentsObj]()
     
    convenience init(news: NewsObj) {
        self.init(nibName: "DetailNewsViewController", bundle: nil)
        self.news = news
        self.fetchComments(postId: news.idPost ?? 0)
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupTable()
        setupGesture()
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
    
    private func setupGesture(){
        let userTap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        usernameLabel.addGestureRecognizer(userTap)
        usernameLabel.isUserInteractionEnabled = true
    }
    
    @objc private func userTapped(){
        let news = self.news
        let vc = UserDetailViewController(news: news)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailNewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CommentsTableViewCell
        cell.nameLabel.text = self.comments[indexPath.row].name
        cell.commentLabel.text = self.comments[indexPath.row].body
        return cell
    }
}

extension DetailNewsViewController {
    private func fetchComments(postId: Int) {
        let url = Contants.Endpoints.urlComments+"?postId=\(postId)"
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    if let rawData = try? JSON(data).rawData() {
                        if let decoded = try? JSONDecoder().decode(ListCommentsResponse.self, from: rawData) {
                            self.mapComments(from: decoded)
                        }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func mapComments(from response: ListCommentsResponse) {
        let mapped = response.map { data in
            CommentsObj(
                id: data.id ?? 0,
                name: data.name ?? "",
                email: data.email ?? "",
                body: data.body ?? ""
            )
        }
        self.comments = mapped
        
        DispatchQueue.main.async {
            self.commentTable.reloadData()
        }
    }
}
