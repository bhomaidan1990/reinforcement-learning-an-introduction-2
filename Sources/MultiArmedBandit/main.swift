import TensorFlow
import OpenSpiel



func play<Policy: StochasticPolicy>(_ game: Policy.Game, actingWith policy: Policy,
                                    for steps: Int) -> Policy.Game.State {
    var currentState = game.initialState
    
    for _ in 0..<steps {
        assert(!currentState.legalActions.isEmpty)
        
        let actionProbabilities = policy.actionProbabilities(forState: currentState)
        assert(!actionProbabilities.isEmpty)

        let sampledAction = actionProbabilities.sample()!
        currentState = currentState.applying(sampledAction)
    }
    
    return currentState
}

let bandit = MultiArmedBandit()
print(bandit)

let policy = UniformRandomPolicy<MultiArmedBandit>(bandit)
print(policy)

let lastState = play(bandit, actingWith: policy, for: 100)
print(lastState)
print(lastState.history)


extension Dictionary where Value == Double {
    
    func sample() -> Key? {
        precondition(!self.isEmpty)
        
        let probabilitiesSum = values.reduce(0.0, +)
        let random = Tensor(randomUniform: [1], lowerBound: Tensor(0.0),
                            upperBound: Tensor(probabilitiesSum)).scalarized()
        
        var sampledAction = nil as Key?
        var accumulatedProbability = 0.0
        for (action, probability) in self {
            sampledAction = action
            accumulatedProbability += probability
            if random < accumulatedProbability { break }
        }
        
        return sampledAction
    }
}
