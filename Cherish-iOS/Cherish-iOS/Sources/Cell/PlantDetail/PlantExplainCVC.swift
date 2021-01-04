//
//  PlantExplainCVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/04.
//

import UIKit
import Lottie

class PlantExplainCVC: UICollectionViewCell {
    
    @IBOutlet var plantExplainAnimationView: UIView!
    @IBOutlet var plantExplainTitleLabel: CustomLabel!
    @IBOutlet var plantExplainSubtitleLabel: CustomLabel!
    
    //MARK: - collectionviewcell 재사용 할 때 셀을 초기화해줌
    // 만일 스크롤을 통해 하나의 Cell이 화면에서 사라지고 그 Cell이 새로운 Cell을 위해 재사용이 되는데 사라진 Cell에 해당하는 종목은 사용자가 보유하여 보유량이 표현이 된다.
    // 새로 생길 Cell에 해당하는 종목은 보유하고 있지 않으면 보유량을 표시해주지 말아야 하지만 Custom Cell을 디자인할 때는 보유량의 유무와 상관없이 UILabel을 올리기 때문에 사용자가 보유하고 있는 사라진 Cell의 보유량이 새로 보일 사용자가 보유하고 있지 않는 Cell에 그대로 나타나게 된다.
    //따라서 prepareForReuse함수를 사용해서 재사용할 때 셀에 데이터를 넣기 전에 셀을 초기화해줌으로써 재사용됨으로 인해 생기는 중복문제를 막는다.
    
    override func prepareForReuse() {
        self.plantExplainAnimationView = UIView()
        self.plantExplainTitleLabel.text = ""
        self.plantExplainSubtitleLabel.text = ""
    }
    
    
    //MARK: - LottieAnimtaion 적용
    func makeLottieAnimation(animationName:String){
        

        let lottieAnimationView = AnimationView()
        
        // 적용할 파일 이름 적기 ( 확장자는 안적어도 됨 )
        lottieAnimationView.animation = Animation.named(animationName)
        
        lottieAnimationView.frame = plantExplainAnimationView.bounds
        lottieAnimationView.backgroundColor = .clear
        
        lottieAnimationView.contentMode = .scaleToFill
        lottieAnimationView.loopMode = .loop
        
        // loopMode 방식 5개 !
        // playOnce : 한번만 돌고 끝남
        // loop : 처음부터 끝까지 반복
        // autoReverse : 애니메이션이 앞 뒤로 재생되고 멈출때까지 재생
        // repeat(특정숫자) : 특정숫자 값 만큼 반복
        // repeatBackwards(특정숫자) : 특정숫자만큼 뒤로 반복 ex) 2 면 앞뒤앞뒤앞 이렇게 실행됨.
        lottieAnimationView.play()
        plantExplainAnimationView.addSubview(lottieAnimationView)
    }
}
