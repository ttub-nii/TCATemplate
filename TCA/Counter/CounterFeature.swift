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
    
    /// @Dependency 를 쓰면 keypath 로 EnvironmentValues 를 extension 한 defaultValue 에 전달되는 듯.
    /// DependencyKey 에 liveValue, previewValue, testValue 3가지 있음. 이제 $0.context 로 쓰면 될 듯.
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
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
                return .run { [count = state.count] send in
                    try await send(.factResponse(self.numberFact.fetch(count)))
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
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
