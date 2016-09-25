//
//  ViewController.swift
//  LoginGuide
//
//  Created by yanze on 9/13/16.
//  Copyright © 2016 yanzeliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonAnchor: NSLayoutConstraint?
    var nextButtonAnchor: NSLayoutConstraint?
    var currentpageNumber: Int = 0
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    let cellId = "Cell"
    let loginCellId = "loginCellId"
    
    let pages: [Page] = {
        let firstPage = Page(title: "Chicken Soup for the Soul", message: "If everything seems under control, you're just not going fast enough.", imageName: "4.jpg")
        let secondPage = Page(title: "Fortune Cookie Comments", message: "A woman who doesn’t wear perfume has no future.", imageName: "2.jpg")
        let thirdPage = Page(title: "Inspirational nonsense", message: "Do not delay anything that adds laughter and joy to your life", imageName: "3.jpg")
        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red:247/255, green: 154/255, blue: 27/255, alpha: 1)
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()
    
    let skipButton: UIButton = {
        let button = UIButton(type:.custom) as UIButton
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
        button.setTitleColor(UIColor(red:247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type:.custom) as UIButton
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red:247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        pageControlBottomAnchor = pageControl.anchor(nil, left:view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)[1]
        print(pageControlBottomAnchor)
        skipButtonAnchor = skipButton.anchor(view.topAnchor, left:view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 70).first
        nextButtonAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 70).first
        
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        registerCells()
        
        let gestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(ViewController.hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for:.touchUpInside)
        nextButton.addTarget(self, action: #selector(nexButtonPressed), for:.touchUpInside)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func skipButtonPressed() {
        
        let indexPath = IndexPath(item: pageControl.numberOfPages-1, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        hideButtonsAndDots()
    }
    
    func nexButtonPressed() {
        currentpageNumber = currentpageNumber + 1
        pageControl.currentPage = currentpageNumber
        
        if pageControl.currentPage == pages.count {
            hideButtonsAndDots()
        }
        collectionView.selectItem(at: IndexPath(item: currentpageNumber, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }

    
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath)
            return loginCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        let page = pages[(indexPath as NSIndexPath).item]
        cell.page = page
        return cell
        
    }
    
    // define cell size to the full screen size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        currentpageNumber = pageNumber
        if pageNumber == pages.count {
            pageControlBottomAnchor?.constant = 80
            skipButtonAnchor?.constant = -50
            nextButtonAnchor?.constant = -50
        }
        else {
            pageControlBottomAnchor?.constant = 0
            skipButtonAnchor?.constant = 0
            nextButtonAnchor?.constant = 0
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func hideButtonsAndDots() {
        pageControlBottomAnchor?.constant = 80
        skipButtonAnchor?.constant = -50
        nextButtonAnchor?.constant = -50
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

}



