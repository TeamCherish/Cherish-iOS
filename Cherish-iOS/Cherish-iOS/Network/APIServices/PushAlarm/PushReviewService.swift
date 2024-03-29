//
//  PushReviewService.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/02/15.
//

import Foundation
import Alamofire

struct PushReviewService {
    static let shared = PushReviewService()
    
    func postContact(cherishId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.pushReviewURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [
            "CherishId": cherishId
        ]
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgePushReviewData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    private func judgePushReviewData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<PushReviewData>.self, from: data) else {
            return .pathErr
        }
        switch status {
        case 200:
            print("성공")
            return .success(decodedData.message)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}

