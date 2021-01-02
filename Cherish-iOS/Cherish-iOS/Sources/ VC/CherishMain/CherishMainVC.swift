//
//  CherishMainVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import OverlayContainer

enum Notches : Int, CaseIterable {
    case minimum, medium, maximum
}

class CherishMainVC: OverlayContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeOverlayContainerContents()
        
        //cherishPeople cell 클릭되었을 때 노티를 보낸걸 감지
        NotificationCenter.default.addObserver(self, selector: #selector(scrollNotchDownAction), name: .cherishPeopleCellClicked, object: nil)
    }
    
    //MARK:- overlayContainer에 VC 구성
    func makeOverlayContainerContents(){
        let cherishMainStoryboard = UIStoryboard(name: "CherishMain", bundle: nil)
        let mainContentContoller = cherishMainStoryboard.instantiateViewController(identifier: "MainContentVC") as! MainContentVC
        let backdropController = cherishMainStoryboard.instantiateViewController(identifier: "BackdropVC") as! BackdropVC
        let detailContentController = cherishMainStoryboard.instantiateViewController(identifier: "DetailContentVC") as! DetailContentVC
        
        self.viewControllers = [mainContentContoller, backdropController, detailContentController]
        
        self.delegate = self
        
        //중간 노치부터 띄우기
        moveOverlay(toNotchAt: 1, animated: false)
    }
    
    //MARK: - 노치를 중간으로 내려주는 액션함수
    @objc func scrollNotchDownAction(_ notification: Notification) {
        moveOverlay(toNotchAt: 1, animated: true)
    }
}



//MARK: - OverlayContainerViewControllerDelegate extension

extension CherishMainVC : OverlayContainerViewControllerDelegate {
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        return Notches.allCases.count
    }
    
    /// minimum, medium, maximum에 해당하는 각 노치 사이즈를 정하는 함수
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        switch Notches.allCases[index] {
        case .minimum:
            return availableSpace * 1/6
        case .medium:
            return availableSpace * 2.1/7
        case .maximum:
            return availableSpace * 3/4
        }
    }
    
    /// content에 scrollView가 있을 때 그 scrollView를 지정해주는 함수 
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, scrollViewDrivingOverlay overlayViewController: UIViewController) -> UIScrollView? {
        return (overlayViewController as? DetailContentVC)?.cherishPeopleCV
    }
    
    /// 노치 handle area를 정하는 함수
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, shouldStartDraggingOverlay overlayViewController: UIViewController, at point: CGPoint, in coordinateSpace: UICoordinateSpace) -> Bool {
        guard let header = (overlayViewController as? DetailContentVC)?.headerView else {
            return false
        }
        let convertedPoint = coordinateSpace.convert(point, to: header)
        return header.bounds.contains(convertedPoint)
    }
    
    /// 오버레이(노치)가 움직이기 전에 액션처리 해주는 함수
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, willMoveOverlay overlayViewController: UIViewController, toNotchAt index: Int) {
        let cherishMainStoryboard = UIStoryboard(name: "CherishMain", bundle: nil)
        let mainContentContoller = cherishMainStoryboard.instantiateViewController(identifier: "MainContentVC") as! MainContentVC
        let backdropController = cherishMainStoryboard.instantiateViewController(identifier: "BackdropVC") as! BackdropVC
        let detailContentController = cherishMainStoryboard.instantiateViewController(identifier: "DetailContentVC") as! DetailContentVC
        
        switch Notches.allCases[index] {
        case .minimum:
            viewControllers = [backdropController,mainContentContoller,detailContentController]
        case .medium:
            viewControllers = [backdropController,mainContentContoller,detailContentController]
        case .maximum:
            viewControllers = [mainContentContoller,backdropController,detailContentController]
        }
    }
}


