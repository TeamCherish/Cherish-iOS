//
//  WithdrawalService.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/06.
//

import Foundation
import Alamofire

struct WithdrawalService {
    static let shared = WithdrawalService()
    
    func withdrawalAccount(userId:Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.mypageURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [
            "id": userId,
        ]
        let dataRequest = AF.request(url,
                                     method: .delete,
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
                completion(judgeUserWithdrawalData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    private func judgeUserWithdrawalData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {
            return .pathErr
        }
        switch status {
        case 200:
            print("회원탈퇴 성공")
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
