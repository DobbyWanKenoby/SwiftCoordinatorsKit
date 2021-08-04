//
//  File.swift
//  
//
//  Created by Vasily Usov on 28.07.2021.
//

import Foundation
import SwiftCoordinatorsKit

// Пример главного координатора приложения
class ApplicationCoordinator: Coordinator {
    var options: [CoordinatorOption] = []
    
    var finishCompletion: (() -> Void)?
    
    var rootCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    func startFlow(finishCompletion: (() -> Void)?) {}
    
    func finishFlow() {}
}

// Пример подчиненного координатора
class ChildCoordinator: Coordinator {
    var options: [CoordinatorOption] = []
    
    var finishCompletion: (() -> Void)?
    
    var rootCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    
    init(rootCoordinator: Coordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func startFlow(finishCompletion: (() -> Void)?) {}
    func finishFlow() {}
}
