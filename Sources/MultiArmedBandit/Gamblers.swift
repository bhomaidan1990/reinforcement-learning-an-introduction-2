import Foundation
import TensorFlow
import OpenSpiel


/// Simple Bandit algorithm with true reward averaging per Chapter 2.4
struct AveragingGambler: StochasticPolicy {
    typealias Game = MultiArmedBandit
    
    /// Instance of the Multi-armed Bandit game being played
    private let game: Game

    /// Action exploration rate.
    private var ε: Double
    
    /// Number of times a state has been visited
    private var N: [Game.Action: Int]
    
    /// Estimated action value
    private var Q: [Game.Action: Double]
    
    init(_ game: Game, ε: Double = 0.01) {
        self.game = game
        self.ε = ε

        let initialN = Array(repeating: 0, count: game.allActions.count)
        N = Dictionary(uniqueKeysWithValues: zip(game.allActions, initialN))

        let initialQ = Tensor(randomUniform: TensorShape([game.allActions.count]),
                              lowerBound: Tensor(0.0),
                              upperBound: Tensor(1e-5)).scalars
        Q = Dictionary(uniqueKeysWithValues: zip(game.allActions, initialQ))
    }
    
    func actionProbabilities(forState state: Game.State) -> [Game.Action : Double] {
        let randomIndex = Tensor(randomUniform: [1],
                                 lowerBound: Tensor(0),
                                 upperBound: Tensor(Int64(state.legalActions.count))).scalarized()
        let randomAction = state.legalActions[Int(randomIndex)]

        let maxQ = Q.max { $0.value > $1.value }
        let maxQAction = maxQ!.key

        return [randomAction: ε, maxQAction: 1 - ε]
    }
    
    mutating func update(with action: Game.Action, reward: Double) {
        N[action] = N[action]! + 1
        Q[action] = (reward - Q[action]!) / Double(N[action]!)
    }
}
