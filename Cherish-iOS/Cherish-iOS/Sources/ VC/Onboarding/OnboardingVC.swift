//
//  OnboardingVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/30.
//

import UIKit

class OnboardingVC: UIViewController {
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    @IBOutlet weak var onboardingCV: UICollectionView!{
        didSet{
            onboardingCV.delegate = self
            onboardingCV.dataSource = self
            onboardingCV.register(OnboardingCVCell.nib(), forCellWithReuseIdentifier: OnboardingCVCell.identifier)
            onboardingCV.register(OnboardingLastCVCell.nib(), forCellWithReuseIdentifier: OnboardingLastCVCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 4{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingLastCVCell.identifier, for: indexPath) as? OnboardingLastCVCell else{
                return UICollectionViewCell()
            }
//            startBtn.isHidden = false
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCVCell.identifier, for: indexPath) as? OnboardingCVCell else{
                return UICollectionViewCell()
            }
//            startBtn.isHidden = true
            cell.setCell(imageName: onboardingData[indexPath.row].onboardingImageName, title: onboardingData[indexPath.row].titleLabelName, description: onboardingData[indexPath.row].descriptionLabelName)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.onboardingCV.frame.width
        let height =  self.onboardingCV.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

//MARK: - collectionView Horizontal Scrolling Magnetic Effect 적용
extension OnboardingVC: UIScrollViewDelegate{
    /// collectionView magnetic scrolling Effect
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.onboardingCV.scrollToNearestVisibleCollectionViewCell()
    }
    
    /// collectionView magnetic scrolling Effect
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.onboardingCV.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / onboardingCV.frame.width)
        self.onboardingPageControl.currentPage = page
    }
    
    //MARK: - scroll animation이 끝나고 적용되는 함수
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        /// scrollAnimation이 끝나고 pageControl의 현재 페이지를 animation이 끝난 상태값으로 바꿔준다.
        onboardingPageControl.currentPage = Int(onboardingCV.contentOffset.x) / Int(onboardingCV.frame.width)
    }
}

