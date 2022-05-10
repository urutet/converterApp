//
//  String+Extensions.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 9.05.22.
//

import UIKit

extension String {
  func flagFromCurrency() -> String {
    return String(String.UnicodeScalarView(
      String(self.dropLast()).unicodeScalars.compactMap(
        { UnicodeScalar(127397 + $0.value) })))
  }
}

