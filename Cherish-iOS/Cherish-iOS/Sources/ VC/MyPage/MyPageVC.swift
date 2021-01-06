//
//  MyPageVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class MyPageVC: UIViewController {
    
    @IBOutlet var mypageUserImageView: UIImageView!
    @IBOutlet var mypageSV: UIScrollView!
    @IBOutlet var sectionHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet var mypageTV: UITableView!
    @IBOutlet var mypageTVHeight: NSLayoutConstraint!
    @IBOutlet var mypageNaviView: UIView!
    @IBOutlet var sectionHeaderView: UIView!
    var mypageSVContentOffset:CGPoint!
    
    @objc func panAction (_ sender : UIPanGestureRecognizer) {
        let maxScrOffY = maxContentOffsetY(mypageSV)
        let scrOffY = mypageSV.contentOffset.y
        let maxTabOffY = maxContentOffsetY(mypageTV)
        let tabOffY = mypageTV.contentOffset.y
        let velocityY = sender.velocity(in: mypageSV).y / 100
        
      
        if scrOffY - velocityY < 0 {
            //스크롤뷰 위로 스크롤할 때 !
            mypageSV.contentOffset.y = 0
            mypageTV.isScrollEnabled = false
            mypageSV.isScrollEnabled = true
            sectionHeaderView.frame = CGRect(x: 0, y: 228, width: self.view.frame.width, height: 59)
            self.mypageNaviView.backgroundColor = .mypageBackgroundGrey
            changeStatusBarBackgroundColor("mypageBackground")
        }
        else if scrOffY - velocityY > maxScrOffY {
            //스크롤뷰 -> 테이블뷰 넘어갈 때
            print("hi")
            mypageSV.isScrollEnabled = true
            mypageTV.isScrollEnabled = true
            mypageSV.contentOffset.y = maxScrOffY
            sectionHeaderView.frame = CGRect(x: 0, y: 228, width: self.view.frame.width, height: 100)
            if mypageTV.visibleCells.count > 10 {
                mypageTV.contentOffset.y = (tabOffY - velocityY > maxTabOffY) ? maxTabOffY : tabOffY - velocityY
            }
            
        }
        else {
            if velocityY < 0 {
                mypageSV.contentOffset.y = scrOffY - velocityY
            }
            else {
                if(tabOffY - velocityY < 0) {
                    
                    mypageTV.contentOffset.y = 0
                    mypageSV.contentOffset.y = scrOffY - velocityY
                }
                else {
                    sectionHeaderView.frame = CGRect(x: 0, y: 228, width: self.view.frame.width, height: 59)
                    mypageTV.contentOffset.y = tabOffY - velocityY
                }
                
                mypageTV.isScrollEnabled = false
                
            }
        }
    }
    
    private func maxContentOffsetY(_ scrollView: UIScrollView) -> CGFloat {
        return scrollView.contentSize.height - scrollView.bounds.height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeStatusBarBackgroundColor("mypageBackground")
        setImageViewRounded()
        setSVProperties()
        setTVProperties()
    }
    
    //MARK: - 상태바 백그라운드 컬러 변경
    func changeStatusBarBackgroundColor(_ Color : String){
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(named: Color)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    
    //MARK: - 프로필 이미지 뷰 round 처리
    func setImageViewRounded(){
        mypageUserImageView.clipsToBounds = true
        mypageUserImageView.layer.cornerRadius = mypageUserImageView.frame.height / 2
    }
    
    func setSVProperties(){
        mypageSV.isScrollEnabled = false
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        self.mypageSV.addGestureRecognizer(panGestureRecognizer)
    }
    
    func setTVProperties(){
        mypageTV.delegate = self
        mypageTV.dataSource = self
        mypageTV.isScrollEnabled = false
        mypageTVHeight.constant = mypageSV.bounds.height - sectionHeaderViewHeight.constant
    }
    
}

extension MyPageVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "index \(indexPath.row + 1)"
        cell.backgroundColor = .yellow
        return cell
    }
}

extension MyPageVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        /// tableView가 스크롤되면 네비바, 상태바 색을 white로 변경
        if mypageTV.contentOffset.y > 0 {
            self.mypageNaviView.backgroundColor = .white
            changeStatusBarBackgroundColor("white")
        }
        /// tableView가 스크롤되지않을땐 네비바, 상태바 색을 mypageBackgroundGrey로 변경
        else {
            self.mypageNaviView.backgroundColor = .mypageBackgroundGrey
            changeStatusBarBackgroundColor("mypageBackground")
            print(mypageSV.contentOffset)
        }
        
        
        ///현재 스크롤되는 스크롤뷰가
        if scrollView == self.mypageSV {
            mypageTV.isScrollEnabled = (self.mypageSV.contentOffset.y >= 200)
        }
        
        if scrollView == self.mypageTV {
            self.mypageTV.isScrollEnabled = (mypageTV.contentOffset.y > 0)
        }
    }
}
