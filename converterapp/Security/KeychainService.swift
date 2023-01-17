//
//  KeychainService.swift
//  converterapp
//
//  Created by user on 17.01.2023.
//

import Foundation
import Security

final class KeychainService {
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  
  private func save(_ data: Data, service: String, account: String) {
    let query = [
      kSecValueData: data,
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: account
    ] as CFDictionary
    
    let status = SecItemAdd(query, nil)
    
    if status == errSecDuplicateItem {
      update(query: query, data: data)
      return
    }
    
    if status != errSecSuccess {
      print("Error: \(status)")
    }
  }
  
  private func update(query: CFDictionary, data: Data) {
    let attributesToUpdate = [kSecValueData : data] as CFDictionary
    
    SecItemUpdate(query, attributesToUpdate)
  }
  
  private func read(service: String, account: String) -> Data? {
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword,
      kSecReturnData: true
    ] as CFDictionary
    
    var result: AnyObject?
    SecItemCopyMatching(query, &result)
    
    return result as? Data
  }
  
    func delete(service: String, account: String) {
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword
    ] as CFDictionary
    
    SecItemDelete(query)
  }
  
  func save<T>(_ item: T, service: String, account: String) where T : Codable {
    do {
      let data = try encoder.encode(item)
      save(data, service: service, account: account)
    } catch {
      print("Encoding failure: \(error.localizedDescription)")
    }
  }
  
  func read<T>(service: String, account: String, ofType: T.Type) -> T? where T : Codable {
    guard let data = read(service: service, account: account) else { return nil }
    do {
      let item = try decoder.decode(T.self, from: data)
      return item
    } catch {
      print("Decoding failure: \(error.localizedDescription)")
    }
    return nil
  }
}
