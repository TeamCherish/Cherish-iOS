//
//  PlantDetailPopUpExplainVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/04.
//

import UIKit
import Lottie

class PlantDetailPopUpExplainVC: UIViewController {

    @IBOutlet var popUpPlantDetailExplainView: UIView! {
        didSet {
            popUpPlantDetailExplainView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet var plantExplainCV: UICollectionView!
    @IBOutlet var plantExplainPageControl: UIPageControl!
    var scrollItem:Int?
    
    var plantExplainArray:[PlantDetailExplainData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDelegates()
        setPlantDetailExplainData()
        setPageControlProperty()
    }
    
    func makeDelegates() {
        plantExplainCV.delegate = self
        plantExplainCV.dataSource = self
    }
    
    func setPlantDetailExplainData() {
        plantExplainArray.append(contentsOf: [
            PlantDetailExplainData(animationName: "33650-recolor-plant", Title: "쑥쑥자라는 단계", SubTitle: "일주일에 물을 3번 씩만 줘도 \n 잘 자라나는 식물이에요!"),
            PlantDetailExplainData(animationName: "38217-money-growth", Title: "성장하는 단계", SubTitle: "일주일에 물을 2번 씩만 줘도 \n 잘 자라나는 식물이에요!"),
            PlantDetailExplainData(animationName: "29583-flower", Title: "성장완료 단계", SubTitle: "일주일에 물을 1번 씩만 줘도 \n 잘 자라나는 식물이에요!")
        ])
        
        plantExplainCV.reloadData()
    }
    
    func setPageControlProperty() {
        plantExplainPageControl.hidesForSinglePage = true
        plantExplainPageControl.numberOfPages = plantExplainArray.count
        plantExplainPageControl.pageIndicatorTintColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
        plantExplainPageControl.currentPageIndicatorTintColor = .seaweed
    }
    
    @IBAction func dismissPopUpExplainView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PlantDetailPopUpExplainVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantExplainArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let plantExplainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlantExplainCVC", for: indexPath) as! PlantExplainCVC
        
        plantExplainCell.makeLottieAnimation(animationName: plantExplainArray[indexPath.row].animationName)
        plantExplainCell.plantExplainTitleLabel.text = plantExplainArray[indexPath.row].Title
        plantExplainCell.plantExplainSubtitleLabel.text = plantExplainArray[indexPath.row].SubTitle
        
        
        return plantExplainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 173, height: 283)
    }
    
    
}
//MARK: - collectionView Horizontal Scrolling Magnetic Effect
extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 1.3))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
//MARK: - collectionView Horizontal Scrolling Magnetic Effect 적용
extension PlantDetailPopUpExplainVC : UIScrollViewDelegate {
    
    /// collectionView magnetic scrolling Effect
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.plantExplainCV.scrollToNearestVisibleCollectionViewCell()
    }

    /// collectionView magnetic scrolling Effect
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.plantExplainCV.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / plantExplainCV.frame.width)
        self.plantExplainPageControl.currentPage = page
      }
    
    //MARK: - scroll animation이 끝나고 적용되는 함수
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        /// scrollAnimation이 끝나고 pageControl의 현재 페이지를 animation이 끝난 상태값으로 바꿔준다.
        plantExplainPageControl.currentPage = Int(plantExplainCV.contentOffset.x) / Int(plantExplainCV.frame.width)
    }
}
