//
//  CornerSide.swift
//  IBAnimatable
//
//  Created by Miroslav Valkovic-Madjer on 17/11/16.
//  Copyright © 2016 IBAnimatable. All rights reserved.
//

import Foundation

///枚举值
public enum CornerSide: String {
  case topLeft = "topleft"
  case topRight = "topright"
  case bottomLeft = "bottomleft"
  case bottomRight = "bottomright"
}

#if swift(>=4.2)
extension CornerSide: CaseIterable {}
#endif

public struct CornerSides: OptionSet {
  public let rawValue: Int

  public static let unknown = CornerSides(rawValue: 0)

  public static let topLeft = CornerSides(rawValue: 1)
  public static let topRight = CornerSides(rawValue: 1 << 1)
  public static let bottomLeft = CornerSides(rawValue: 1 << 2)
  public static let bottomRight = CornerSides(rawValue: 1 << 3)

  ///所有的边
  public static let allSides: CornerSides = [.topLeft, .topRight, .bottomLeft, .bottomRight]

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  ///生成边
  init(rawValue: String?) {
    guard let rawValue = rawValue, !rawValue.isEmpty else {
      self = .allSides
      return
    }

    ///分割
    let sideElements = rawValue.lowercased().split(separator: ",")
      .map(String.init)
      ///去重空格
      .map { CornerSide(rawValue: $0.trimmingCharacters(in: CharacterSet.whitespaces)) }
      ///生成边
      .map { CornerSides(side: $0) }

    guard !sideElements.contains(.unknown) else {
      self = .allSides
      return
    }

    self = CornerSides(sideElements)
  }

  init(side: CornerSide?) {
    guard let side = side else {
      self = .unknown
      return
    }

    switch side {
    case .topLeft: self = .topLeft
    case .topRight: self = .topRight
    case .bottomLeft: self = .bottomLeft
    case .bottomRight: self = .bottomRight
    }
  }
}
