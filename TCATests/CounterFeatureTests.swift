//
//  CounterFeatureTests.swift
//  TCATests
//
//  Created by toby on 7/9/24.
//

import ComposableArchitecture
import XCTest

@testable import TCA

@MainActor
final class CounterFeatureTests: XCTestCase {

    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            /// inout으로 State 를 넘기고, 내부적으로 값 비교를 하는듯
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}
