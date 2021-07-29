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
        
        func testTemplatesCoordinators() {
            let baseCoordinator = BaseCoordinator(rootCoordinator: nil)
            let secondCoordinator = BaseCoordinator(rootCoordinator: baseCoordinator)
            let presenter = UIViewController()
            let basePresenter = BasePresenter(presenter: presenter, rootCoordinator: secondCoordinator)
            
            XCTAssertEqual(baseCoordinator.childCoordinators.count, 1)
            XCTAssertTrue(secondCoordinator.rootCoordinator === baseCoordinator)
            XCTAssertTrue(secondCoordinator.childCoordinators.first! === basePresenter)
            XCTAssertNotNil(basePresenter.rootCoordinator)
            XCTAssertTrue(basePresenter.presenter === presenter)
            XCTAssertEqual(basePresenter.childControllers.count, 0)
        }
        
    }
