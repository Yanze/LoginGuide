//
//  ViewController.swift
//  LoginGuide
//
//  Created by yanze on 9/13/16.
//  Copyright © 2016 yanzeliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LoginCellDelegate {
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonAnchor: NSLayoutConstraint?
    var nextButtonAnchor: NSLayoutConstraint?
    var loginCell: LoginCell?
    
    
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
//    let homepageId = "homepageId"
    
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
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type:.custom) as UIButton
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
        button.setTitleColor(UIColor(red:247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skipButtonPressed), for:.touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type:.custom) as UIButton
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red:247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
        button.addTarget(self, action: #selector(nexButtonPressed), for:.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        pageControlBottomAnchor = pageControl.anchor(nil, left:view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)[1]
        skipButtonAnchor = skipButton.anchor(view.topAnchor, left:view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 70).first
        nextButtonAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 70).first
      
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        registerCells()
        
        let gestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(ViewController.hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func skipButtonPressed() {
        let indexPath = IndexPath(item: pageControl.numberOfPages - 1, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        hideButtonsAndDots()      
    }
    
    func nexButtonPressed() {
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        pageControl.currentPage += 1
        if pageControl.currentPage == pages.count {
           hideButtonsAndDots()

        }
    }
    
    func hideButtonsAndDots() {
        pageControlBottomAnchor?.constant = 80
        skipButtonAnchor?.constant = -50
        nextButtonAnchor?.constant = -50
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
            loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as? LoginCell
            loginCell?.delegate = self
            return loginCell!
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        let page = pages[(indexPath as NSIndexPath).item]
        cell.page = page
        return cell
        
    }
    
    func loginButtonPressed() {
        let username = loginCell?.usernameTextField.text
        let pwd = loginCell?.passwordTextField.text
        if username != nil && pwd != nil {
            
            let myUrl = NSURL(string: "https://ios-login.herokuapp.com/login")
            
            var request = URLRequest(url: myUrl as! URL)
            request.httpMethod = "POST"
            let postString = "{\"username\":\"\(username!)\",\"pwd\":\"\(pwd!)\"}"
            print(postString)
            request.httpBody = postString.data(using: .utf8)

            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else{
                    print(error.debugDescription)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print(httpStatus)
                }
                
                let responseString = String(data: data, encoding: .utf8)
                if responseString! == "OK" {
                    // present viewcontroller
                    DispatchQueue.main.async() {
                        self.performSegue(withIdentifier: "homepageId", sender: self)
                    }

                }
                
            })
            task.resume()
        
        }
    }
    
    // define cell size to the full screen size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        if pageNumber == pages.count {
            hideButtonsAndDots()
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
    
    
    
    
    

}
