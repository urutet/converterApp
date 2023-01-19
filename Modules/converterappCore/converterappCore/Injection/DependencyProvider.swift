//
//  DependencyProvider.swift
//  converterapp
//
//  Created by user on 20.12.2022.
//

import Foundation
import Swinject

public final class DependencyProvider {
  
  public let container = Container()
  public let assembler: Assembler
  
  public init() {
    assembler = Assembler([
      RepositoryAssembly(),
    ],
    container: container)
  }
  
}
