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
    
    var plantExplainArray:[PlantDetailExplainData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDelegates()
        setPlantDetailExplainData()
    }
    
    func makeDelegates(){
        plantExplainCV.delegate = self
        plantExplainCV.dataSource = self
    }
    
    func setPlantDetailExplainData(){
        plantExplainArray.append(contentsOf: [
            PlantDetailExplainData(animationName: "33650-recolor-plant", Title: "쑥쑥자라는 단계", SubTitle: "일주일에 물을 3번 씩만 줘도 \n 잘 자라나는 식물이에요!"),
            PlantDetailExplainData(animationName: "38217-money-growth", Title: "성장하는 단계", SubTitle: "일주일에 물을 2번 씩만 줘도 \n 잘 자라나는 식물이에요!"),
            PlantDetailExplainData(animationName: "29583-flower", Title: "성장완료 단계", SubTitle: "일주일에 물을 1번 씩만 줘도 \n 잘 자라나는 식물이에요!")
        ])
        
        plantExplainCV.reloadData()
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
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.plantExplainCV.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.plantExplainCV.scrollToNearestVisibleCollectionViewCell()
        }
    }
}
