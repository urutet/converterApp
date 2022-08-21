//
//  Rate.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation

struct Currency: Codable {
  let id: Int?
  let date: String
  let abbreviation: String?
  let scale: Int?
  let name: String?
  var rate: Decimal?
  
  var isFavourite = false
  
  enum CodingKeys: String, CodingKey {
    case id = "Cur_ID"
    case date = "Date"
    case abbreviation = "Cur_Abbreviation"
    case scale = "Cur_Scale"
    case name = "Cur_Name"
    case rate = "Cur_OfficialRate"
  }
}
