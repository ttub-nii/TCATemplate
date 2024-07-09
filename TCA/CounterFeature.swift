//
//  CounterFeature.swift
//  TCA
//
//  Created by toby on 6/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
/// Reducer 를 합성해서 사용 가능

struct CounterFeature { /// 보통 Reducer를 confirm하는 객체를 Feature 네이밍을 사용함
  @ObservableState
    
    struct State: Equatable { /// Teststore 을 위해서는 assertions을 위해 equatable 채택 해야됨
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case toggleTimerButtonTapped
        case timerTick
        case factButtonTapped
        case factResponse(String)
    }
    
    enum CancelID {
        case timer
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
//                let (data, _) = try await URLSession.shared
//                    .data(from: URL(string: "http://numbersapi.com/\(state.count)")!)
//                // 🛑 'async' call in a function that does not support concurrency
//                // 🛑 Errors thrown from here are not handled
//                
//                state.fact = String(decoding: data, as: UTF8.self)
//                state.isLoading = false
                return .run { [count = state.count] send in
                    // ✅ Do async work in here, and send actions back into the system.
//                    let (data, _) = try await URLSession.shared
//                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
//                    let fact = String(decoding: data, as: UTF8.self)
//                    state.fact = fact
//                    // 🛑 Mutable capture of 'inout' parameter 'state' is not allowed in concurrently-executing code
                    Task(priority: .background) {
                        await send(.factResponse("123"))
                    }
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        while true { /// long-living effect
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }.cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
                        
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
            }
        }
    }
}

/// body 를 실행하는 부분이 Reducer에는 없음. Reducer는 단지 설계도.
/// Store 에다가 run 하는 구조.
/// View에서는 Store만 바라보고.
