//
//  PlantDetailPopUpExplainVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/04.
//

import UIKit

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
    
    // 페이징 관련 index 정의 함수
    private var indexOfCellBeforeDragging = 0
    
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
    
    // 오른쪽으로 넘길 때
    private func indexOfMajorCell() -> Int {
        let itemWidth = plantExplainCV.frame.size.width
        let proportionalOffset = (plantExplainCV.contentOffset.x / itemWidth)+0.3
        print("Offset: \(proportionalOffset)")
        let index = Int(round(proportionalOffset))
        print("index: \(index)")
        let safeIndex = max(0, min(4, index))
        print("safteIndex: \(safeIndex)")
        return safeIndex
    }
    
    // 왼쪽으로 넘길 때
    private func indexOfBeforCell() -> Int {
        let itemWidth = plantExplainCV.frame.size.width
        let proportionalOffset = (plantExplainCV.contentOffset.x / itemWidth)
        let back_index = Int(floor(proportionalOffset))
        let safeIndex = max(0, min(4, back_index))
        return safeIndex
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
                        
                        print("plantExplain",plantExplain)
                        print("plantStepExplainArray",plantStepExplainArray)
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
                
                let first_url = URL(string: plantExplain[0].image)
                let first_imageData = try? Data(contentsOf: first_url!)
                plantExplainCell.flowerMeaningImageView.image = UIImage(data: first_imageData!)
                
                /// 이미지 url 처리
                DispatchQueue.global(qos: .default).async(execute: { [self]() -> Void in
                    
                    let url = URL(string: plantExplain[0].imageURL )
                    let imageData = try? Data(contentsOf: url!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        plantExplainCell.plantImageView.image = UIImage(data: imageData!)
                    })
                })
                
//                plantExplainCell.plantImageView.image = UIImage(named: "imgMinLevel3")
            }
            else if indexPath.item == 1 {
                plantExplainCell.plantExplainTitleLabel.text = "1단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[0].plantDetailDescription
                
                let step1 = URL(string: plantStepExplainArray[0].image)
                let step1_imageData = try? Data(contentsOf: step1!)
                plantExplainCell.flowerMeaningImageView.image = UIImage(data: step1_imageData!)
                
                /// 이미지 url 처리
                DispatchQueue.global(qos: .default).async(execute: { [self]() -> Void in
                    
                    let url = URL(string: plantStepExplainArray[0].imageURL)
                    let imageData = try? Data(contentsOf: url!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        plantExplainCell.plantImageView.image = UIImage(data: imageData!)
                    })
                })
            }
            else if indexPath.item == 2 {
                plantExplainCell.plantExplainTitleLabel.text = "2단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[1].plantDetailDescription
                
                let step2 = URL(string: plantStepExplainArray[1].image)
                let step2_imageData = try? Data(contentsOf: step2!)
                plantExplainCell.flowerMeaningImageView.image = UIImage(data: step2_imageData!)
                /// 이미지 url 처리
                DispatchQueue.global(qos: .default).async(execute: { [self]() -> Void in
                    
                    let url = URL(string: plantStepExplainArray[1].imageURL)
                    let imageData = try? Data(contentsOf: url!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        plantExplainCell.plantImageView.image = UIImage(data: imageData!)
                    })
                })
            }
            else {
                plantExplainCell.plantExplainTitleLabel.text = "3단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[1].plantDetailDescription
                
                let step3 = URL(string: plantStepExplainArray[2].image)
                let step3_imageData = try? Data(contentsOf: step3!)
                plantExplainCell.flowerMeaningImageView.image = UIImage(data: step3_imageData!)
                /// 이미지 url 처리
                DispatchQueue.global(qos: .default).async(execute: { [self]() -> Void in
                    
                    let url = URL(string: plantStepExplainArray[2].imageURL)
                    let imageData = try? Data(contentsOf: url!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        plantExplainCell.plantImageView.image = UIImage(data: imageData!)
                    })
                })
            }
        }
        
        return plantExplainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 283)
    }
    
    
}
//MARK: - collectionView Horizontal Paging Effect 적용
extension PlantDetailPopUpExplainVC : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        if velocity.x > 0 {
            let indexOfMajorCell = self.indexOfMajorCell()
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            plantExplainCV.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }else{
            let indexOfBeforCell = self.indexOfBeforCell()
            let indexPath = IndexPath(row: indexOfBeforCell, section: 0)
            plantExplainCV.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    //MARK: - scroll animation이 끝나고 적용되는 함수
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        /// scrollAnimation이 끝나고 pageControl의 현재 페이지를 animation이 끝난 상태값으로 바꿔준다.
        plantExplainPageControl.currentPage = Int(plantExplainCV.contentOffset.x) / Int(plantExplainCV.frame.width)
    }
}
