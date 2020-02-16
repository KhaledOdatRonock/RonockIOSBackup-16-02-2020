//
//  CommonFunctions.swift
//  MVVM_Starter_Project
//
//  Created by Saferoad on 7/16/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    func responsePhoto(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<Photo>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseSliceDetials(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SliceDetailsResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseMapListAdsResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[Ad]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseMapLocationsResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[MapLocation]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseSuccess(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[Catalog]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseDone(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[Ad]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseFailed(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[Catalog]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseUnAuthorized(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[Catalog]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseForceUpdate(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[Catalog]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseMyCart(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[CartHeader]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseFlyers(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<ListDataResponse<Flyer>>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseProfile(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<Profile>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseIntrests(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[Intrest]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseSilentNewUser(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<String>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseAdvertiserProfile(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<AdvertiserProfile>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseDeals(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[DealSection]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseAdsByCategory(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<ListDataResponse<HomeAd>>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseVideoAdDetails(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<VideoAdDetails>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseRegularAdDetails(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<RegularAdDetails>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseReplaceIntrests(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<String>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseMyCoupons(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<ListDataResponse<Coupon>>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseMyNotifications(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<ListDataResponse<Notification>>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseCouponDetails(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<CouponDetails>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseStory(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[Story]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseHotDeals(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[HomeAd]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseWalkthrough(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<[WalkthroughPage]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseFavouriteAds(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<ListDataResponse<FavoriteAd>>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseBrands(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WebAPIResponse<ListDataResponse<Brand>>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}


// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
