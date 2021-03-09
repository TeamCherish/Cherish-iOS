//
//  CheckPhoneService.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/03/08.
//

import Foundation
import Alamofire

struct CheckPhoneService {
    static let shared = CheckPhoneService()
    
    func checkPhone(phone: String, UserId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.checkPhoneURL
        let header: HTTPHeaders = [ "Contentp-Type" : "application/json" ]
        let body: Parameters = [
            "phone": phone,
            "UserId" : UserId
        ]
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData {(response) in
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
        guard let decodedData = try? decoder.decode(GenericResponse<CheckPhoneData>.self, from: data) else {
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
