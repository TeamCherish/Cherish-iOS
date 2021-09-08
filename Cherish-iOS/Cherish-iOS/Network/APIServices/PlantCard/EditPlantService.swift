//
//  EditPlantService.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/02/19.
//

import Foundation
import Alamofire

struct EditPlantService {
    static let shared = EditPlantService()
    
    func editPlant(nickname: String, birth: String, cycle_date: Int, notice_time: String, water_notice_: Bool, id: Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.addURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [
            "nickname": nickname,
            "birth": birth,
            "cycle_date": cycle_date,
            "notice_time": notice_time,
            "water_notice" : water_notice_,
            "id": id
        ]
        let dataRequest = AF.request(url,
                                     method: .put,
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
                completion(judgeData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    private func judgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<EditPlantData>.self, from: data) else {
            return .pathErr
        }
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


