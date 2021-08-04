//
//  DetailPhotoUserViewController.swift
//  news-engine
//
//  Created by Qodir Masruri on 04/08/21.
//

import UIKit
import Kingfisher

class DetailPhotoUserViewController: UIViewController {

    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var imageScroolView: UIScrollView!
    @IBOutlet weak var photoNameLabel: UILabel!
    
    private var photoName: String = ""
    private var selectedPhotoUrl: String = ""
    
    convenience init(albums: String, selectedPhoto: String){
        self.init(nibName: "DetailPhotoUserViewController", bundle: nil)
        self.photoName = albums
        self.selectedPhotoUrl = selectedPhoto
        self.setData(photoUrl: selectedPhotoUrl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView(){
        title = "Detail Photo"
        photoNameLabel.text = photoName
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
    
}

extension DetailPhotoUserViewController{
    private func setData(photoUrl: String){
        let url = URL(string: photoUrl)
        photoImg.load(url: url!)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
