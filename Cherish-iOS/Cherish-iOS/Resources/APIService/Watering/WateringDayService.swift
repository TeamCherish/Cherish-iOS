//
//  WateringDayService.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/11.
//

import Foundation
import Alamofire

struct WateringDayService {
    static let shared = WateringDayService()
    
    func whenWateringDay(CherishId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.wateringDayURL + "\(CherishId)"
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default)
        
        
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
        guard let decodedData = try? decoder.decode(GenericResponse<WateringDayData>.self, from: data) else {
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
