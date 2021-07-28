    import XCTest
    @testable import SwiftCoordinatorsKit

    final class SwiftCoordinatorsKitTests: XCTestCase {
        
        func testCreateSimpleCoordinator() {
            let coordinator = ApplicationCoordinator()
            
            XCTAssertNil(coordinator.rootCoordinator)
            XCTAssertTrue(coordinator.childCoordinators.count == 0)
        }
        
        func testCreateCoordinatorSimpleHierarchy() {
            let coordinator = ApplicationCoordinator()
            let childCoordinator = ChildCoordinator(rootCoordinator: coordinator)
            coordinator.childCoordinators.append(coordinator)
            
            XCTAssertNotNil(childCoordinator.rootCoordinator)
            XCTAssertTrue(childCoordinator.childCoordinators.count == 0)
            XCTAssertTrue(coordinator.childCoordinators.count == 1)
        }
        
    }
