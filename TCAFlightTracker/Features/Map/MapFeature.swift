import ComposableArchitecture

@Reducer
struct MapFeature {
    @ObservableState
    struct State: Equatable {
        // ...
    }
    
    enum Action {
        case centerViewTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .centerViewTapped:
                return .none
            }
        }
    }
}
