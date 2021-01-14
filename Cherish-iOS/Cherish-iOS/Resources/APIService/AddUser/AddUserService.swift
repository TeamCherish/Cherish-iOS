//
//  AddUserService.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/12.
//

import Foundation
import Alamofire

struct AddUserService {
    static let shared = AddUserService()
    
    func addUser(name: String, nickname: String, birth: String, phone: String, cycle_date: Int, notice_time: String, water_notice_: Bool, UserId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.addURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [
            "name": name,
            "nickname": nickname,
            "birth": birth,
            "phone": phone,
            "cycle_date": cycle_date,
            "notice_time": notice_time,
            "water_notice_" : water_notice_,
            "UserId": UserId
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
                completion(judgeAddUserData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    private func judgeAddUserData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<AddUserData>.self, from: data) else {
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

