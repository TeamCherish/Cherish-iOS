//
//  UpdatePasswordService.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/06.
//

import Foundation
import Alamofire

struct UpdatePasswordService {
    static let shared = UpdatePasswordService()
    
    func updatePW(email: String, password1: String, password2: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.updatePasswordURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [
            "email":email,
            "password1":password1,
            "password2":password2,
        ]
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
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
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {
            return .pathErr }
        switch status {
        case 200:
            print("비밀번호 변경 성공")
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail }
    }
}
