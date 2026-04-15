//
//  UserLoginStatus.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/15.
//

import Foundation

public enum UserLoginStatus {
    case guest
    case pending
    case active(User)
}
