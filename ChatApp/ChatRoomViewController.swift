//
//  ChatRoomViewController.swift
//  ChatApp
//
//  Created by Sai Madhukar on 12/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController,iCarouselDelegate,iCarouselDataSource {

    
    
    
    @IBOutlet weak var iCarouselView: iCarousel!
    
    
    @objc var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ChatRoom"
        
        images = [#imageLiteral(resourceName: "IMG_0151"),#imageLiteral(resourceName: "IMG_0353"),#imageLiteral(resourceName: "IMG_0346"),#imageLiteral(resourceName: "32396550222_c519172bfa_o"),#imageLiteral(resourceName: "IMG_0118")]

        iCarouselView.backgroundColor = .clear
        iCarouselView.type = .rotary
        iCarouselView.isPagingEnabled = true
        iCarouselView.stopAtItemBoundary = true
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        iCarouselView.reloadData()
    }
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        print("1")
        return images.count
    }
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        
        title = "Group Chats"
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 230, height: 250))
        
        let ImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 220, height: 240))
        ImgView.frame = v.bounds
        ImgView.image = images[index]
        ImgView.clipsToBounds = true
        ImgView.contentMode = .scaleAspectFill
        
        v.addSubview(ImgView)
        return v
    
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
