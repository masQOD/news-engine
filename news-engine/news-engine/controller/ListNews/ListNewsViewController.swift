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
    var listpost = [Posts]()
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
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupTable()
    }
    
    private func setupView(){
        title = "Berita Terbaru"
        view.backgroundColor = .systemPink
    }
    
    private func setupTable(){
        listNewsTable.delegate = self
        listNewsTable.dataSource = self
        listNewsTable.register(UINib.init(nibName: "ListNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func fetchData(){
        AF.request(Contants.Endpoints.urlPosts).responseJSON(completionHandler: { (response) in
            debugPrint(response.result)
            if let json = JSON(response.result).array{
                for obj in json{
                    print(obj["body"].stringValue)
                }
            }
    
        })
    }
}

extension ListNewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListNewsTableViewCell
        
        return cell
    }
}
