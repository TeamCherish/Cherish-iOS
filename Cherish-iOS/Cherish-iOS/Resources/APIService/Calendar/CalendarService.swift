//
//  CalendarService.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/14.
//

import Foundation
import Alamofire

struct CalendarService {
    static let shared = CalendarService()

    func calendarLoad(id: Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.calendarURL+"\(id)"
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
                completion(judgeCheckData(status: statusCode, data: data))
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    func doLater(id: Int, postpone: Int, is_limit_postpone_number: Bool, completion: @escaping (NetworkResult<Any>) -> (Void)){
       
        let url = APIConstants.laterURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [ "id" : id,
                                 "postpone": postpone,
                                 "is_limit_postpone_number": is_limit_postpone_number
                                ]
        let dataRequest = AF.request(url,
                                     method: .put,
                                     parameters: body,
                                     encoding: JSONEncoding.default, headers: header)
        
        
        dataRequest.responseData {(response) in
            switch response.result { case .success:
                guard let statusCode = response.response?.statusCode else { return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeLaterData(status: statusCode, data: data))
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    
    
    private func judgeCheckData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CalendarSeeData>.self, from: data) else {
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
    
    private func judgeLaterData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {
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
