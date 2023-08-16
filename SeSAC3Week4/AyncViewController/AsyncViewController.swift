//
//  AsyncViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/11.
//

import UIKit

final class AsyncViewController: UIViewController {
        

    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstImageView.backgroundColor = .black
        
        DispatchQueue.main.async {
            self.firstImageView.layer.cornerRadius = self.firstImageView.frame.width / 2.0
        }
        
        
        /*
         비율 layout
         */
    }
 
    /*
     sync aync serial concurrent
     UI Freezing
     
     */
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg")!
        
        // global
        DispatchQueue.global().async { [weak self] in
            let data = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self?.firstImageView.image = UIImage(data: data)
            }
        }
    }
}
