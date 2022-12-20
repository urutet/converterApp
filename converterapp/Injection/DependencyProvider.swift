//
//  DependencyProvider.swift
//  converterapp
//
//  Created by user on 20.12.2022.
//

import Foundation
import Swinject

final class DependencyProvider {
  
  let container = Container()
  let assembler: Assembler
  
  init() {
    assembler = Assembler([
      RepositoryAssembly(),
      ViewModelAssembly()
    ],
    container: container)
  }
  
}
