//
//  PlantDetailPopUpExplainVC.swift
//  Cherish-iOS
//
//  Edited by 이원석 on 2021/08/05.
//

import UIKit
import Kingfisher

class PlantDetailPopUpExplainVC: UIViewController {
    var plantId:Int?
    var scrollItem:Int?
    var plantStepExplainArray:[PlantDetail] = []
    var plantExplain:[PlantResponse] = []
    private var indexOfCellBeforeDragging = 0 // 페이징 관련 index 정의 함수
    
    @IBOutlet var popUpPlantDetailExplainView: UIView! {
        didSet {
            popUpPlantDetailExplainView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet var plantExplainCV: UICollectionView!
    @IBOutlet var plantExplainPageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDelegates()
        setPlantDetailExplainData()
        setPageControlProperty()
    }
    
    private func makeDelegates() {
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
    
    private func setPlantDetailExplainData() {
        if let plantId = self.plantId {
            print(plantId)
            PlantDetailCardService.shared.inquirePlantDetailCardView(plantIdx: plantId){ [self]
                (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    if let detailCardData = data as? PlantDetailCardData {
                        plantExplain = detailCardData.plantResponse
                        plantStepExplainArray = detailCardData.plantDetail // 4개 카드 중 3개 정보 받는 array
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
    
    private func setPageControlProperty() {
        plantExplainPageControl.hidesForSinglePage = true
        plantExplainPageControl.numberOfPages = 4
        plantExplainPageControl.pageIndicatorTintColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
        plantExplainPageControl.currentPageIndicatorTintColor = .seaweed
    }
    
    // MARK: - 식물 단계 별 이미지와 설명 에셋 세팅
    private func setPopUpAsset(_ imageView: UIImageView, _ url: URL) {
        let processor = DownsamplingImageProcessor(size: imageView.frame.size)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ]) {
            result in
            switch result {
            case .success(_):
                print("Task done")
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
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
        
        if !plantExplain.isEmpty {
            
            switch indexPath.item {
            case 0:
                plantExplainCell.plantExplainTitleLabel.text = plantExplain[0].modifier
                plantExplainCell.plantExplainSubtitleLabel.text = plantExplain[0].explanation
                
                if let meaningUrl = URL(string: plantExplain[0].image) {
                    setPopUpAsset(plantExplainCell.flowerMeaningImageView, meaningUrl)
                }
                if let imageUrl = URL(string: plantExplain[0].imageURL) {
                    setPopUpAsset(plantExplainCell.plantImageView, imageUrl)
                }
            case 1:
                plantExplainCell.plantExplainTitleLabel.text = "1단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[0].plantDetailDescription
                
                if let meaningUrl = URL(string: plantStepExplainArray[0].image) {
                    setPopUpAsset(plantExplainCell.flowerMeaningImageView, meaningUrl)
                }
                if let imageUrl = URL(string: plantStepExplainArray[0].imageURL) {
                    setPopUpAsset(plantExplainCell.plantImageView, imageUrl)
                }
            case 2:
                plantExplainCell.plantExplainTitleLabel.text = "2단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[1].plantDetailDescription
                
                if let meaningUrl = URL(string: plantStepExplainArray[1].image) {
                    setPopUpAsset(plantExplainCell.flowerMeaningImageView, meaningUrl)
                }
                if let imageUrl = URL(string: plantStepExplainArray[1].imageURL) {
                    setPopUpAsset(plantExplainCell.plantImageView, imageUrl)
                }
            default:
                plantExplainCell.plantExplainTitleLabel.text = "3단계"
                plantExplainCell.plantExplainSubtitleLabel.text = plantStepExplainArray[1].plantDetailDescription
                
                if let meaningUrl = URL(string: plantStepExplainArray[2].image) {
                    setPopUpAsset(plantExplainCell.flowerMeaningImageView, meaningUrl)
                }
                if let imageUrl = URL(string: plantStepExplainArray[2].imageURL) {
                    setPopUpAsset(plantExplainCell.plantImageView, imageUrl)
                }
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
