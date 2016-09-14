//
//  ViewController.swift
//  LoginGuide
//
//  Created by yanze on 9/13/16.
//  Copyright © 2016 yanzeliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var pageControl: UIPageControl = UIPageControl(frame: CGRectMake(20, 300, 100, 40))
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .whiteColor()
        cv.dataSource = self
        cv.delegate = self
        cv.pagingEnabled = true
        return cv
    }()
    
    let cellId = "Cell"
    
    let pages: [Page] = {
        let firstPage = Page(title: "Chicken Soup for the Soul", message: "If everything seems under control, you're just not going fast enough.", imageName: "1.jpg")
        let secondPage = Page(title: "Fortune Cookie Comments", message: "A woman who doesn’t wear perfume has no future.", imageName: "2.jpg")
        let thirdPage = Page(title: "Inspirational nonsense", message: "Do not delay anything that adds laughter and joy to your life", imageName: "3.jpg")
        return [firstPage, secondPage, thirdPage]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        // use autolayout
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
   
        collectionView.registerClass(PageCell.self, forCellWithReuseIdentifier: cellId)
        configurePageControl()
        pageControl.addTarget(self, action: #selector(ViewController.changePage(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    // page control
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * collectionView.frame.size.width
        collectionView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = .redColor()
        self.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        self.view.addSubview(pageControl)
    }
    // end of page control
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
        
    }
    
    // define cell size to the full screen size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    


}

extension UIView {
    func anchorToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraintEqualToAnchor(top, constant: topConstant).active = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraintEqualToAnchor(bottom, constant: -bottomConstant).active = true
        }
        
        if let left = left {
            leftAnchor.constraintEqualToAnchor(left, constant: leftConstant).active = true
        }
        
        if let right = right {
            rightAnchor.constraintEqualToAnchor(right, constant: -rightConstant).active = true
        }
        
    }
}

