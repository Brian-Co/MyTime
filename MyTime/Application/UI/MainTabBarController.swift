//
//  MainTabBarController.swift
//  MyTime
//
//  Created by Brian Corrieri on 27/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    typealias DidSelectItemIndex = ((Int) -> ())
    typealias DeinitBlock = (() -> ())
    
    
    var didSelectItemIndex: DidSelectItemIndex?
    var deinitBlock: DeinitBlock?
    
    init(didSelectItemIndex: DidSelectItemIndex?, deinitBlock: DeinitBlock?) {
        self.didSelectItemIndex = didSelectItemIndex
        self.deinitBlock = deinitBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            didSelectItemIndex?(index)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
