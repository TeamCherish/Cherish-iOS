//
//  FindPasswordService.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/06.
//

import Foundation
import Alamofire

struct FindPasswordService {
    static let shared = FindPasswordService()
    // 비번찾기시 메시지 인증
    func findPassword(email: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.findPasswordURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [
            "email":email
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
        guard let decodedData = try? decoder.decode(GenericResponse<FindPasswordData>.self, from: data) else {
            return .pathErr }
        switch status {
        case 200:
            print("인증메시지 전송 성공")
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail }
    }
}
