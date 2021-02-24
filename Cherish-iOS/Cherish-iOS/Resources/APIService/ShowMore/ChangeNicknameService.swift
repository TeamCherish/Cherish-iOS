//
//  ChangeNicknameService.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/02/24.
//

import Foundation
import Alamofire

struct ChangeNicknameService {
    static let shared = ChangeNicknameService()
    
    func updateNicknameInfo(userId:Int, nickname: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.addViewChangeNicknameURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [
            "id": userId,
            "nickname": nickname
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
                completion(judgeUpdateNicknameChangeData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    private func judgeUpdateNicknameChangeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<PushReviewData>.self, from: data) else {
            return .pathErr
        }
        switch status {
        case 200:
            print("닉네임 업데이트 성공")
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


