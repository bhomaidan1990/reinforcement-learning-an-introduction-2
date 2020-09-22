import TensorFlow
import OpenSpiel


/// Multi-armed Bandit game from Chapter 4 of *Sutton & Barto '18*.
///
/// - Note:
/// *"Consider the following learning problem. You are faced repeatedly with a choice among k
/// different options, or actions. After each choice you receive a numerical reward chosen from
/// a stationary probability distribution that depends on the action you selected. Objective is to
/// maximize the expected total reward over some time period, for example, over 1000 action
/// selections, or time steps."* - *Sutton & Barto '18*, page 22.
///  Some text a link to [Sutton & Barton 18].
///
/// [Sutton & Barto 18]: http://incompleteideas.net/book/the-book-2nd.html "RL "
///  Some text a link to [Sutton & Barton 18].
///
/// - Remark:
/// [Sutton & Barto 18](http://incompleteideas.net/book/the-book-2nd.html) -
/// Richard S. Sutton, Andrew G. Barto: **Reinforcement Learning, An Introduction**,
/// 2018, Second Edition, MIT Press
///
public class MultiArmedBandit: GameProtocol {
    public let playerCount = 1
    
    public let utilitySum: Double? = nil
    
    public static let info = GameInfo(
        shortName: "multi_armed_bandit",
        longName: "Multi-armed Bandit",
        dynamics: .sequential,
        chanceMode: .sampledStochastic,
        information: .perfect,
        utility: .generalSum,
        rewardModel: .terminal,
        maxPlayers: 1,
        minPlayers: 1,
        providesInformationStateString: false,
        providesInformationStateTensor: false
    )

    public typealias Action = Int
    
    /// A State represents a time during the game.
    public struct State: StateProtocol {
        public let game: MultiArmedBandit
        
        public var history: [Action] = []
        
        public var currentPlayer: Player = .player(0)

        public var legalActionsMask: [Bool] { Array(repeating: true, count: game.armCount) }

        public func utility(for player: Player) -> Double {
            return -1.0
        }
        
        public func informationStateTensor(for player: Player) -> [Double] {
            return []
        }

        public func informationStateString(for player: Player) -> String {
            return ""
        }
        
        init(_ game: MultiArmedBandit) {
            self.game = game
        }
        
        public let isTerminal = false
        
        public mutating func apply(_ action: MultiArmedBandit.Action) {
            precondition( (0..<game.armCount).contains(action) )
            history.append(action)
        }
    }

    public var minUtility = -Double.infinity
    public var maxUtility = +Double.infinity
    
    public let armCount: Int
    public lazy var allActions: [Action] = { Array(0..<armCount) }()
    
    public var informationStateTensorShape = [1]
    
    public let maxGameLength = Int.max
    
    public var initialState: State { State(self) }
    
    public init(armCount: Int = 10) {
        self.armCount = armCount
    }
}


extension MultiArmedBandit.State: CustomStringConvertible {
    public var description: String {"MultiArmedBandit: [armCount: \(game.armCount)]" }
}


extension GameInfo {
    /// Workaround for missing public memberwise initializer.
    init(shortName: String, longName: String, dynamics: GameInfo.Dynamics,
         chanceMode: GameInfo.ChanceMode, information: GameInfo.Information,
         utility: GameInfo.Utility, rewardModel: GameInfo.RewardModel,
         maxPlayers: Int, minPlayers: Int,
         providesInformationStateString: Bool, providesInformationStateTensor: Bool) {
        self.init(shortName: shortName, longName: longName, dynamics: dynamics,
                  chanceMode: chanceMode, information: information,
                  utility: utility, rewardModel: rewardModel,
                  maxPlayers: maxPlayers, minPlayers: minPlayers,
                  providesInformationStateString: providesInformationStateString,
                  providesInformationStateTensor: providesInformationStateTensor
        )
    }
}
