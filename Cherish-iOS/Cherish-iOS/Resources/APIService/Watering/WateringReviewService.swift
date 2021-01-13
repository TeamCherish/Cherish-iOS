//
//  WateringReviewService.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/12.
//

import Foundation
import Alamofire

struct WateringReviewService {
    static let shared = WateringReviewService()
    
    func wateringReview(review: String, keyword1: String, keyword2: String, keyword3: String, CherishId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.wateringReviewURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [ "review" : review,
                                 "keyword1" : keyword1,
                                 "keyword2" : keyword2,
                                 "keyword3" : keyword3,
                                 "CherishId" : CherishId
                                ]
                     
        let dataRequest = AF.request(url,
                                     method: .get,
                                     parameters: body,
                                     encoding: JSONEncoding.default,headers: header)
        
        
        dataRequest.responseData {(response) in
            switch response.result { case .success:
                guard let statusCode = response.response?.statusCode else { return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeData(status: statusCode, data: data))
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    
    
    private func judgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {
            return .pathErr }
        switch status {
        case 200:
            print("성공")
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail }
    }
}
