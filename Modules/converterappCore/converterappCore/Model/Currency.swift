//
//  Rate.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation

public struct Currency: Codable, Identifiable {
  public let id: Int?
  public let date: String
  public let abbreviation: String?
  public let scale: Int?
  public let name: String?
  public var rate: Decimal?
  
  public var isFavourite = false
  
  public init(id: Int?, date: String, abbreviation: String?, scale: Int?, name: String?, rate: Decimal? = nil, isFavourite: Bool = false) {
    self.id = id
    self.date = date
    self.abbreviation = abbreviation
    self.scale = scale
    self.name = name
    self.rate = rate
    self.isFavourite = isFavourite
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "Cur_ID"
    case date = "Date"
    case abbreviation = "Cur_Abbreviation"
    case scale = "Cur_Scale"
    case name = "Cur_Name"
    case rate = "Cur_OfficialRate"
  }
}
