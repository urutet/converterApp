//
//  RemoteConfigProtocol.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 4.07.22.
//

import Foundation

protocol RemoteConfigProtocol {
  var boolParameters: [String : Bool] { get }
  
  func fetchParameters()
}
