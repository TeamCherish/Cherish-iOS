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
    var plantId:Int?
    var scrollItem:Int?
    
    var plantStepExplainArray:[PlantDetail] = []
    var plantExplain:[PlantResponse] = []
    
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
        if let plantId = self.plantId {
            print(plantId)
            PlantDetailCardService.shared.inquirePlantDetailCardView(plantIdx: plantId){ [self]
                (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    if let detailCardData = data as? PlantDetailCardData {
                        print("통신이 됩니닷")
                        plantExplain = detailCardData.plantResponse
                        // 4개 카드 중 3개 정보 받는 array
                        plantStepExplainArray = detailCardData.plantDetail
                        plantExplainCV.reloadData()
                    }
                case .requestErr(let msg):
                    print(msg)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
                
            }
        }
    }
    
    func setPageControlProperty() {
        plantExplainPageControl.hidesForSinglePage = true
        plantExplainPageControl.numberOfPages = 4
        plantExplainPageControl.pageIndicatorTintColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
        plantExplainPageControl.currentPageIndicatorTintColor = .seaweed
    }
    
    
    @IBAction func dismissPopUpExplainView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension PlantDetailPopUpExplainVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let plantExplainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlantExplainCVC", for: indexPath) as! PlantExplainCVC
        
        if plantExplain.count != 0 {
            
            if indexPath.item == 0 {
                plantExplainCell.plantExplainTitleLabel.text = plantExplain[0].modifier
                plantExplainCell.plantExplainSubtitleLabel.text = plantExplain[0].explanation
                
                let first_url = URL(string: plantExplain[0].image )
                let first_imageData = try? Data(contentsOf: first_url!)
                plantExplainCell.flowerMeaningImageView.image = UIImage(data: first_imageData!)
                
                let url = URL(string: plantExplain[0].imageURL )
                let imageData = try? Data(contentsOf: url!)
                plantExplainCell.plantImageView.image = UIImage(data: imageData!)
//                plantExplainCell.plantImageView.image = UIImage(named: "imgMinLevel3")
            }
            else if indexPath.item == 1 {
                plantExplainCell.plantExplainTitleLabel.text = "1단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[0].plantDetailDescription
                
                let step1 = URL(string: plantStepExplainArray[0].image )
                let step1_imageData = try? Data(contentsOf: step1!)
                plantExplainCell.flowerMeaningImageView.image = UIImage(data: step1_imageData!)
                
                let url = URL(string: plantStepExplainArray[0].imageURL )
                let imageData = try? Data(contentsOf: url!)
                plantExplainCell.plantImageView.image = UIImage(data: imageData!)
            }
            else if indexPath.item == 2 {
                plantExplainCell.plantExplainTitleLabel.text = "2단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[1].plantDetailDescription
                
                let step2 = URL(string: plantStepExplainArray[1].image )
                let step2_imageData = try? Data(contentsOf: step2!)
                plantExplainCell.flowerMeaningImageView.image = UIImage(data: step2_imageData!)
                
                let url = URL(string: plantStepExplainArray[1].imageURL )
                let imageData = try? Data(contentsOf: url!)
                plantExplainCell.plantImageView.image = UIImage(data: imageData!)
            }
            else {
                plantExplainCell.plantExplainTitleLabel.text = "3단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[1].plantDetailDescription
                
                let step3 = URL(string: plantStepExplainArray[2].image )
                let step3_imageData = try? Data(contentsOf: step3!)
                plantExplainCell.flowerMeaningImageView.image = UIImage(data: step3_imageData!)
                
                let url = URL(string: plantStepExplainArray[2].imageURL )
                let imageData = try? Data(contentsOf: url!)
                plantExplainCell.plantImageView.image = UIImage(data: imageData!)
            }
        }
        
        return plantExplainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height: 283)
    }
    
    
}
//MARK: - collectionView Horizontal Scrolling Magnetic Effect
extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 1.5))
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
