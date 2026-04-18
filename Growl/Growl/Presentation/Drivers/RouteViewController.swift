//
//  RouteViewController.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/16.
//

import UIKit
import SwiftUI

/// `RouteViewControllerTransitionDirection` is defines the transition direction for UI transitions using `RouteViewController`
public enum RouteViewControllerTransitionDirection {
    case bottom
    case up
    case right
    case left
}


/// `RouteViewController` is a SwiftUI wrapper for `UINavigationController` that manages screen transitions
/// based on a provided route model. It supports custom directional animations and handles the 
/// integration between SwiftUI views and UIKit's navigation stack.
public struct RouteViewController<Route: Equatable, Screen: View>: UIViewControllerRepresentable {
    private let routeViewModel: RouteViewModel<Route>
    private let hiddenBackButton: Bool
    private let transitionAnimated: Bool
    private let transitionDirection: RouteViewControllerTransitionDirection
    private let builder: (Route) -> Screen
    
    public init(
        routeViewModel: RouteViewModel<Route>,
        hiddenBackButton: Bool = true,
        transitionAnimated: Bool = true,
        transitionDirection: RouteViewControllerTransitionDirection = .right,
        @ViewBuilder builder: @escaping (Route) -> Screen
    ) {
        self.routeViewModel = routeViewModel
        self.hiddenBackButton = hiddenBackButton
        self.transitionAnimated = transitionAnimated
        self.transitionDirection = transitionDirection
        self.builder = builder
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        
        // Set delegate to handle custom transitions.
        navigationController.delegate = context.coordinator
        
        navigationController.setNavigationBarHidden(hiddenBackButton, animated: false)
        
        // Set routing view into navigation controller.
        routeViewModel.routes.forEach { route in
            let hostingController = RouteViewHostingController(rootView: builder(route))
            hostingController.navigationItem.setHidesBackButton(hiddenBackButton, animated: false)
            navigationController.pushViewController(hostingController, animated: false)
        }
        
        routeViewModel.onPush = { route in
            let hostingController = RouteViewHostingController(rootView: builder(route))
            hostingController.navigationItem.setHidesBackButton(hiddenBackButton, animated: false)
            navigationController.pushViewController(hostingController, animated: transitionAnimated)
        }
        
        routeViewModel.onPop = { cnt in
            let count = navigationController.viewControllers.count
            let targetIndex = max(count - cnt - 1, 0)
            if targetIndex < count {
                let targetVC = navigationController.viewControllers[targetIndex]
                navigationController.popToViewController(targetVC, animated: transitionAnimated)
            }
        }
        
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    
    public class Coordinator: NSObject, UINavigationControllerDelegate {
        let parent: RouteViewController
        
        init(parent: RouteViewController) {
            self.parent = parent
        }
        
        public func navigationController(
            _ navigationController: UINavigationController,
            animationControllerFor operation: UINavigationController.Operation,
            from fromVC: UIViewController,
            to toVC: UIViewController
        ) -> (any UIViewControllerAnimatedTransitioning)? {
            // Return the custom animator with the specified direction and operation type.
            return RouteViewControllerTransitionAnimator(operation: operation, direction: parent.transitionDirection)
        }
    }
}


/// `RouteViewControllerTransitionAnimator` is a custom animator that implements directional
/// view controller transitions. It calculates the start and end frames for both the incoming 
/// and outgoing views based on the specified `RouteViewControllerTransitionDirection`.
fileprivate class RouteViewControllerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let operation: UINavigationController.Operation
    private let direction: RouteViewControllerTransitionDirection
    private let duration: Double
    
    init(operation: UINavigationController.Operation, direction: RouteViewControllerTransitionDirection, transitionDuration duration: Double = 0.35) {
        self.operation = operation
        self.direction = direction
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        // Standard transition duration.
        return duration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let isPush = operation == .push
        
        // Add the destination view to the container.
        if isPush {
            containerView.addSubview(toView)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        let width = containerView.bounds.width
        let height = containerView.bounds.height
        
        var toViewInitialFrame = containerView.bounds
        var fromViewFinalFrame = containerView.bounds
        
        // Calculate frames based on the transition direction.
        switch direction {
        case .right:
            // Push towards right, Pop towards left.
            if isPush {
                toViewInitialFrame.origin.x = -width
                fromViewFinalFrame.origin.x = width
            } else {
                toViewInitialFrame.origin.x = width
                fromViewFinalFrame.origin.x = -width
            }
        case .left:
            // Push towards left, Pop towards right.
            if isPush {
                toViewInitialFrame.origin.x = width
                fromViewFinalFrame.origin.x = -width
            } else {
                toViewInitialFrame.origin.x = -width
                fromViewFinalFrame.origin.x = width
            }
        case .up:
            // Push move up, Pop move down.
            if isPush {
                toViewInitialFrame.origin.y = height
                fromViewFinalFrame.origin.y = -height
            } else {
                toViewInitialFrame.origin.y = -height
                fromViewFinalFrame.origin.y = height
            }
        case .bottom:
            // Push move down, Pop move up.
            if isPush {
                toViewInitialFrame.origin.y = -height
                fromViewFinalFrame.origin.y = height
            } else {
                toViewInitialFrame.origin.y = height
                fromViewFinalFrame.origin.y = -height
            }
        }
        
        toView.frame = toViewInitialFrame
        
        // Perform the animation.
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                toView.frame = containerView.bounds
                fromView.frame = fromViewFinalFrame
            },
            completion: { finished in
                // Finalize the transition state.
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}


/// `RouteViewHostingController` is acts as an Adapter between the iOS UIKit environment and the application's presentation logic,
/// ensuring a consistent user experience by overriding default framework behaviors.
fileprivate class RouteViewHostingController<Content: View>: UIHostingController<Content> {
    var transitionDelegate: UIViewControllerTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.edgesForExtendedLayout = .all
    }

    // Enforce a full-screen experience by strictly controlling the visibility of the system navigation bar.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        additionalSafeAreaInsets.bottom = .zero
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        additionalSafeAreaInsets.bottom = .zero
    }
}
