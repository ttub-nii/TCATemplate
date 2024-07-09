//
//  CounterView.swift
//  TCA
//
//  Created by toby on 6/18/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    
    /// view 를 업데이트하려면 action 을 실행해야 함.
    /// reducer 를 실행해주는 녀석.
    let store: StoreOf<CounterFeature>
//    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            
            Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
                store.send(.toggleTimerButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            
            Button("Fact") {
                store.send(.factButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            
            if store.isLoading {
              ProgressView()
            } else if let fact = store.fact {
              Text(fact)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
//            CounterFeature()
            /// store 가 body 를 실행시키는 호출부를 갖고 있기 때문에 Feature 를 주석처리해도 preview 에서 볼 수 있게 되는 것
        }
    )
}
