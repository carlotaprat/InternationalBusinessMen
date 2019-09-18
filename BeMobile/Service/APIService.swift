//
//  APIService.swift
//  BeMobile
//
//  Created by Carlota Prat on 18/9/19.
//  Copyright © 2019 Carlota Prat. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum ApiUrls: String {
    case rates = "rates"
    case transactions = "transactions"
    
    var getUrl: String {
        
        return "http://quiet-stone-2094.herokuapp.com/\(self.rawValue)"

        
    }
}

struct APIService {
    
    
    func getTransactions() -> Observable<Transaction> {
        
        return Observable<Transaction>.create({ (observer) -> Disposable in
            
            let requestReference = Alamofire.request(ApiUrls.transactions.getUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            return observer.onCompleted()
                        }
                        
                        do {
                            
                            let transactions = try JSONDecoder()
                                .decode([Transaction].self, from: data)
                                //.compactMap { $0 }
                            
                            //let transactions = try JSONDecoder().decode(CargoList.self, from: data)
                            
                            for transaction in transactions {
                                observer.onNext(transaction)
                            }
                            
                        } catch {
                            /*do {
                                let error = try JSONDecoder().decode(InnrouteError.self, from: data)
                                observer.onError(error)
                            } catch {
                                let error = InnrouteError(code: "", message: "", type: "")
                                observer.onError(error)
                            }*/
                            print("ERROR IN CATCH")
                        }
                        
                        observer.onCompleted()
                        
                    case .failure (let encodingError):
                        
                        /*var innrouteError = InnrouteError(code: "", message: "", type: "")
                        
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            
                            innrouteError = InnrouteError(code: String(err.code.rawValue), message: "No Internet connection", type: "AFError")*/
                        observer.onError(encodingError)
                            
                        //} else {
                            
                            //innrouteError = InnrouteError(code: "0", message: "Unknown error", type: "CustomError")
                            
                        //}
                        
                        //observer.onError(innrouteError)
                        
                        return observer.onCompleted()
                        
                    }
            }
            return Disposables.create(with: {
                requestReference.cancel()
            })
            
        })
        
        /*let transactions = try JSONDecoder()
            .decode([FailableDecodable<Transaction>].self, from: json)
            .compactMap { $0.base }*/
        
    }
    
    func getRates() -> Observable<Rate> {
        
        return Observable<Rate>.create({ (observer) -> Disposable in
            
            let requestReference = Alamofire.request(ApiUrls.rates.getUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            return observer.onCompleted()
                        }
                        
                        do {
                            
                            let rates = try JSONDecoder()
                                .decode([Rate].self, from: data)
                            
                            for rate in rates {
                                observer.onNext(rate)
                            }
                            
                        } catch {
                    
                            print("ERROR IN CATCH")
                        }
                        
                        observer.onCompleted()
                        
                    case .failure (let encodingError):
                      
                        observer.onError(encodingError)
                        
                        return observer.onCompleted()
                        
                    }
            }
            return Disposables.create(with: {
                requestReference.cancel()
            })
            
        })
    
        
    }
}

