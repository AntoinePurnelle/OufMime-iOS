//
//  StringExt.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 25/03/2022.
//

import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
  return NSLocalizedString(string, comment: "")
}
