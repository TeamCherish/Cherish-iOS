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
    
    // 캘린더 정보 불러오기
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
    
    // 캘린더 리뷰 수정
    func reviewEdit(CherishId: Int, water_date: String, review: String, keyword1: String, keyword2: String, keyword3: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
        
        let url = APIConstants.calendarURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [ "CherishId" : CherishId,
                                 "water_date": water_date,
                                 "review": review,
                                 "keyword1": keyword1,
                                 "keyword2": keyword2,
                                 "keyword3": keyword3,
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
                completion(judgeData(status: statusCode, data: data))
            case .failure(let err): print(err)
                completion(.networkFail) }
        }
    }
    
    // 캘린더 리뷰 삭제
    func reviewDelete(CherishId: Int, water_date: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
        
        let url = APIConstants.calendarURL
        let header: HTTPHeaders = [ "Content-Type":"application/json"]
        let body: Parameters = [ "CherishId" : CherishId,
                                 "water_date": water_date,
        ]
        let dataRequest = AF.request(url,
                                     method: .delete,
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
    
    
    
    
    
    private func judgeCheckData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CalendarSeeData>.self, from: data) else {
            return .pathErr }
        switch status {
        case 200:
            print("캘린더 정보 불러오기 성공")
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail }
    }
    
    private func judgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {
            return .pathErr }
        switch status {
        case 200:
            print("리뷰 수정or삭제 성공")
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail }
    }
}
