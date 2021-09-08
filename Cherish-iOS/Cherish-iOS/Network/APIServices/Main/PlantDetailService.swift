//
//  PlantDetailService.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/12.
//

import Foundation
import Alamofire

struct PlantDetailService {
    static let shared = PlantDetailService()
    
    func inquirePlantDetailView(friendsIdx:Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
        
        let url = APIConstants.plantDetailURL + "\(friendsIdx)"
        print(url)
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default, headers: header)
        
        
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
        guard let decodedData = try? decoder.decode(GenericResponse<PlantDetailData>.self, from: data) else {
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
            return .networkFail
        }
    }
}


