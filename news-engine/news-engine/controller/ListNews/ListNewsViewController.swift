//
//  ListNewsViewController.swift
//  news-engine
//
//  Created by Qodir Masruri on 02/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListNewsViewController: UIViewController {

    @IBOutlet weak var listNewsTable: UITableView!
    
    var listNews = [NewsObj]()
    private var refreshControl: UIRefreshControl!
    
    // MARK: - Initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
        refreshControl = UIRefreshControl()
    }
    
    fileprivate func xibSetup() {
        view = loadViewFromNib()
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ListNewsViewController", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupTable()
    }
    
    private func setupView(){
        title = "News"
        view.backgroundColor = .systemBackground
    }
    
    private func setupTable(){
        listNewsTable.delegate = self
        listNewsTable.dataSource = self
        listNewsTable.register(UINib.init(nibName: "ListNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension ListNewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNews.count
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListNewsTableViewCell
        cell.titleLabel.text = self.listNews[indexPath.row].title
        cell.userLabel.text = "\(self.listNews[indexPath.row].company ?? "") \u{2022} \(self.listNews[indexPath.row].username ?? "")"
        cell.contentLabel.text = self.listNews[indexPath.row].body
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.listNews[indexPath.row]
        let vc = DetailNewsViewController(nibName: "DetailNewsViewController", bundle: nil)
        vc.news = news
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListNewsViewController {
    private func fetchPosts() {
        let url = Contants.Endpoints.urlPosts
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    if let rawData = try? JSON(data).rawData() {
                        if let decoded = try? JSONDecoder().decode(ListPostsResponse.self, from: rawData) {
                            self.chain(using: decoded)
                        }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func fetchUsers(completion: @escaping ((ListUserResponse) -> Void)) {
        let url = Contants.Endpoints.urlUsers
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    if let rawData = try? JSON(data).rawData()  {
                        if let decoded = try? JSONDecoder().decode(ListUserResponse.self, from: rawData) {
                            completion(decoded)
                        }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func chain(using posts: ListPostsResponse) {
        
        var news: [NewsObj] = []
        
        self.fetchUsers { users in
            for user in users {
                let merge = posts.filter({ $0.userId == user.id })
                    for post in merge {
                        news.append(
                            NewsObj(
                                idPost: post.id ?? 0,
                                idUser: user.id ?? 0,
                                title: post.title ?? "",
                                body: post.body ?? "",
                                username: user.username ?? "",
                                company: user.company?.name ?? ""
                            )
                        )
                    }
            }
            self.listNews = news
            print(self.listNews.count)
            
            // Checking all posts belongs to `Bret`
            let bret = self.listNews.filter { $0.username == "Bret" }
            print(bret.count)
            dump(bret)
            
            DispatchQueue.main.async {
                self.listNewsTable.reloadData()
            }
        }
       
    }
}
