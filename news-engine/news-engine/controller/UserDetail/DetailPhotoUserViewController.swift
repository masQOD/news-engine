//
//  DetailPhotoUserViewController.swift
//  news-engine
//
//  Created by Qodir Masruri on 04/08/21.
//

import UIKit
import Kingfisher

class DetailPhotoUserViewController: UIViewController, UIScrollViewDelegate  {

    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var imageScroolView: UIScrollView!
    @IBOutlet weak var photoNameLabel: UILabel!
    
    private var photoName: String?
    private var selectedPhotoUrl: String?
    
    convenience init(albums: String, selectedPhoto: String){
        self.init(nibName: "DetailPhotoUserViewController", bundle: nil)
        self.photoName = albums
        self.selectedPhotoUrl = selectedPhoto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupGesture()
        setData()
    }
    
    private func setupView(){
        title = "Detail Photo"
        photoNameLabel.text = photoName
        imageScroolView.delegate = self
        imageScroolView.flashScrollIndicators()
        imageScroolView.minimumZoomScale = 1.0
        imageScroolView.maximumZoomScale = 4.0
        photoImg.clipsToBounds = false
    }
    
    private func setupGesture(){
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        imageScroolView.addGestureRecognizer(doubleTapGest)
    }
    
    // MARK: OBJC FUNC
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if imageScroolView.zoomScale == 1 {
            imageScroolView.zoom(to: zoomRectForScale(scale: 4.0, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            imageScroolView.setZoomScale(1, animated: true)
        }
    }
    
    // MARK: ZOOM FUNC
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = photoImg.frame.size.height / scale
        zoomRect.size.width  = photoImg.frame.size.width  / scale
        let newCenter = photoImg.convert(center, from: imageScroolView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImg
    }
    
    private func setData(){
        if let imgUrl = selectedPhotoUrl, let url = URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!){
            self.photoImg.kf.setImage(with: url, placeholder: UIImage.init(named: ""), options: [.transition(.fade(0))], progressBlock: nil, completionHandler: nil)
        }
    }
}

