//
//  AppFeature.swift
//  TCA
//
//  Created by toby on 7/16/24.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
    }
    
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        /// scope가 없어도 compile 은 되고 runtime에서 동작 안하는 이유
        /// ReducerOf가 내부에서 각각을 Reducer 로 만들고 merge.
        /// runtime에서 keypath id 로 찾기 때문에 compile 은 되는듯.
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .tab1(.decrementButtonTapped):
                state.tab1.fact = "testtest"
                state.tab2.fact = "44444444"
            case .tab1(.incrementButtonTapped):
                break
            case .tab1(.toggleTimerButtonTapped):
                break
            case .tab1(.timerTick):
                break
            case .tab1(.factButtonTapped):
                break
            case .tab1(.factResponse(_)):
                break
            case .tab2(_):
                break
            }
            return .none
        }
    }
}
