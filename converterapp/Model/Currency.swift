//
//  Rate.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation

struct Currency: Codable {
  let id: Int?
  let abbreviation: String?
  let date: Date
  let scale: Int?
  let name: String?
  let rate: Decimal?
  
  enum CodingKeys: String, CodingKey {
    case id = "Cur_ID"
    case abbreviation = "Cur_Abbreviation"
    case date = "Date"
    case scale = "Cur_Scale"
    case name = "Cur_Name"
    case rate = "Cur_OfficialRate"
  }
}
