import OpenSpiel


func playRandom<T: GameProtocol>(game: T, for steps: Int) -> T.State {
    var state = game.initialState
    
    for _ in 0..<steps {
        assert(!state.legalActions.isEmpty)
        let randomAction = state.legalActions.randomElement()!
        state = state.applying(randomAction)
    }
    
    return state
}

let bandit = MultiArmedBandit()
print(bandit)

let lastState = playRandom(game: bandit, for: 100)
print(lastState)
print(lastState.history)
