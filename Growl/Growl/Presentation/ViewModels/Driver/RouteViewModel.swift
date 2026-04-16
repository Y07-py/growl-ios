//
//  RouteViewModel.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/16.
//

import SwiftUI
import Combine

public class RouteViewModel<Route: Equatable>: ObservableObject {
    var routes: [Route] = [Route]()
    
    public var onPush: ((Route) -> Void)?
    public var onPop: ((Int) -> Void)?
    
    public init(route: Route) {
        routes.append(route)
    }
    
    public func push(_ route: Route) {
        routes.append(route)
        onPush?(route)
    }
    
    public func pop(_ cnt: Int) {
        guard cnt >= 0, cnt <= routes.count else { return }
        routes.removeLast(cnt)
        onPop?(cnt)
    }
}
