//
//  SignUpService.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/16.
//

import Foundation
import Alamofire

struct SignUpService {
    static let shared = SignUpService()
    
    func doSignUp(email: String, password: String, phone: String, sex: String, birth: String, nickname: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.signupURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [
            "email":email,
            "password":password,
            "phone": phone,
            "sex": sex,
            "birth": birth,
            "nickname": nickname
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
            print("회원가입 성공")
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail }
    }
}
