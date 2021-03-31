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
    @IBOutlet weak var startBtn: UIButton!{
        didSet{
            startBtn.makeRounded(cornerRadius: 25.0)
            startBtn.alpha = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 페이징 관련 index 정의 함수
    private var indexOfCellBeforeDragging = 0
    
    // 오른쪽으로 넘길 때
    private func indexOfMajorCell() -> Int {
        let itemWidth = onboardingCV.frame.size.width
        let proportionalOffset = (onboardingCV.contentOffset.x / itemWidth)+0.3
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(onboardingData.count - 1, index))
        return safeIndex
    }
    
    // 왼쪽으로 넘길 때
    private func indexOfBeforCell() -> Int {
        let itemWidth = onboardingCV.frame.size.width
        let proportionalOffset = (onboardingCV.contentOffset.x / itemWidth)
        let back_index = Int(floor(proportionalOffset))
        let safeIndex = max(0, min(onboardingData.count - 1, back_index))
        return safeIndex
    }
    
    @IBAction func moveToLoginView(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "LoginVC") as? LoginVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 4{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingLastCVCell.identifier, for: indexPath) as? OnboardingLastCVCell else{
                return UICollectionViewCell()
            }
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCVCell.identifier, for: indexPath) as? OnboardingCVCell else{
                return UICollectionViewCell()
            }
            cell.setCell(imageName: onboardingData[indexPath.row].onboardingImageName, title: onboardingData[indexPath.row].titleLabelName, description: onboardingData[indexPath.row].descriptionLabelName)
            onboardingPageControl.isHidden = false
            UIView.animate(withDuration: 0.3, animations:
                            {
                                self.startBtn.alpha = 0.0
                                self.view.layoutIfNeeded()
                            })
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        if velocity.x > 0 {
            let indexOfMajorCell = self.indexOfMajorCell()
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            if indexPath.item == 4 {
                onboardingPageControl.isHidden = true
                UIView.animate(withDuration: 1.0, animations:
                                {
                                    self.startBtn.alpha = 1.0
                                    self.view.layoutIfNeeded()
                                })
            }
            onboardingCV.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }else{
            let indexOfBeforCell = self.indexOfBeforCell()
            
            let indexPath = IndexPath(row: indexOfBeforCell, section: 0)
            onboardingCV.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    //MARK: - scroll animation이 끝나고 적용되는 함수
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        /// scrollAnimation이 끝나고 pageControl의 현재 페이지를 animation이 끝난 상태값으로 바꿔준다.
        onboardingPageControl.currentPage = Int(round(onboardingCV.contentOffset.x / onboardingCV.frame.size.width))
    }
}

