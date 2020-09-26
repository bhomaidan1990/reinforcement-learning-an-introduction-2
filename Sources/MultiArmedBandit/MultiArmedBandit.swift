import TensorFlow
import OpenSpiel


/// Multi-armed Bandit Testbed according to *Sutton & Barto '18*, chapter 2.
///
/// *"Consider the following learning problem. You are faced repeatedly with a choice among k*
/// *different options, or actions. After each choice you receive a numerical reward chosen from*
/// *a stationary probability distribution that depends on the action you selected. Objective is to*
/// *maximize the expected total reward over some time period."* - *Sutton & Barto '18*, page 25.
///
/// - Remark:
/// [Sutton & Barto '18](http://incompleteideas.net/book/the-book-2nd.html) -
/// Richard S. Sutton, Andrew G. Barto: **Reinforcement Learning, An Introduction**,
/// Second Edition, MIT Press, Cambridge, MA
///
public class MultiArmedBandit: GameProtocol {
    /// Represents a state in a game. Each game type has an associated state type.
    public struct State: StateProtocol {
        /// The corresponding game instance.
        public let game: MultiArmedBandit

        /// The current player.
        public let currentPlayer: Player = .player(0)

        /// Is this a terminal state? (i.e. has the game ended?)
        public let isTerminal = false

        /// All actions that are legal for the current player in this state.
        public var legalActions: [Action] { game.allActions }

        /// An array of the same length as `game.allActions` representing which of those
        /// actions are legal for the current player in this state. Not valid in chance nodes.
        public var legalActionsMask: [Bool] {
            Array(repeating: true, count: game.armCount)
        }

        /// The list of actions leading to the state.
        public var history: [Action] = []
        
        /// The total reward ("utility" or "return") for `player` in the current state.
        /// For games that only have a final reward, it should be 0 for all
        /// non-terminal states and the terminal utility for the final state.
        public func utility(for player: Player) -> Double {
            return sampledReward
        }

        /// For imperfect information games. Returns an identifier for the current
        /// information state for the specified player.
        /// Different ground states can yield the same information state for a player
        /// when the only part of the state that differs is not observable by that
        /// player (e.g. opponents' cards in Poker.)
        ///
        /// Games that do not have imperfect information do not need to implement
        /// these methods, but most algorithms intended for imperfect information
        /// games will work on perfect information games provided the informationState
        /// is returned in a form they support. For example, informationState
        /// could simply return history for a perfect information game.
        ///
        /// The `informationState` must be returned at terminal states, since this is
        /// required in some applications (e.g. final observation in an RL
        /// environment).
        ///
        /// Not valid in chance states.
        public func informationStateString(for player: Player) -> String {
            return ""
        }
        
        /// Vector form, useful for neural-net function approximation approaches.
        /// The size of the vector must match Game.informationStateTensorShape
        /// with values in lexicographic order. E.g. for 2x4x3, order would be:
        /// (0,0,0), (0,0,1), (0,0,2), (0,1,0), ... , (1,3,2).
        ///
        /// There are currently no use-case for calling this function with
        /// `Player.chance`. Thus, games are expected to raise an error in that case.
        public func informationStateTensor(for player: Player) -> [Double] {
            return []
        }
        
        private var sampledReward: Double

        init(_ game: MultiArmedBandit) {
            self.game = game
            self.sampledReward = 0.0
        }
        
        /// games. This function encodes the logic of the game rules. Returns true
        /// on success. In simultaneous games, returns false (`applyActions` should be
        /// used in that case.)
        ///
        /// In the case of chance nodes, the behavior of this function depends on
        /// `GameInfo.chanceMode`. If `.explicitStochastic`, then the outcome should be
        /// directly applied. If `.sampledStochastic`, then a dummy outcome is passed and
        /// the sampling of an outcome should be done in this function and then applied.
        public mutating func apply(_ action: MultiArmedBandit.Action) {
            precondition((0..<game.armCount).contains(action))

            history.append(action)
            sampledReward = Tensor(
                randomNormal: [1],
                mean: game.armRewards[action],
                standardDeviation: MultiArmedBandit.rewardSampleStandardDeviation
            ).scalarized()
        }
    }

    /// Action representing which bandit arm is pulled.
    public typealias Action = Int

    /// The initial state for the game.
    public var initialState: State { State(self) }

    /// Static information on the game type.
    public static let info = GameInfo(
        shortName: "multi_armed_bandit",
        longName: "Multi-armed Bandit",
        dynamics: .sequential,
        chanceMode: .sampledStochastic,
        information: .perfect,
        utility: .generalSum,
        rewardModel: .rewards,
        maxPlayers: 1,
        minPlayers: 1,
        providesInformationStateString: false,
        providesInformationStateTensor: false
    )
    
    /// The number of players in this instantiation of the game.
    /// Does not include the chance-player.
    public let playerCount = 1

    /// All distinct actions possible in the game for any non-chance player. This
    /// is not the same as the legal actions in any particular state as distinct
    /// actions are independent of the context (state), and often independent of
    /// the player as well. So, for instance in Tic-Tac-Toe there are 9 of these, one
    /// for each square. In games where pieces move, like e.g. Breakthrough, then
    /// there would be 64*6*2, since from an 8x8 board a single piece could only ever
    /// move to at most 6 places, and it can be a regular move or a capture move.
    /// Note: chance node outcomes are not included in this count.
    /// For example, this corresponds to the actions represented by each output
    /// neuron of the policy net head learning which move to play.
    public lazy var allActions: [Action] = { Array(0..<armCount) }()

    /// Utility range. These functions define the lower and upper bounds on the
    /// values returned by `State.return`. This range should be as tight as possible;
    /// the intention is to give some information to algorithms that require it,
    /// and so their performance may suffer if the range is not tight. Loss/win/draw
    /// outcomes are common among games and should use the standard values of {-1,0,1}.
    public var minUtility = -Double.infinity
    public var maxUtility = +Double.infinity
    
    /// The total utility for all players. Should return `0.0` if the game is zero-sum.
    ///
    /// Note: not all games are zero-sum (e.g. cooperative games), as a result, this is an
    /// optional value.
    public let utilitySum: Double? = nil
    
    /// Describes the structure of the information state representation in a
    /// tensor-like format. This is especially useful for experiments involving
    /// reinforcement learning and neural networks.
    /// Note: the actual information is returned in a 1-D vector by
    /// `ImperfectInformationState.informationStateTensor` -
    /// see the documentation of that function for details of the data layout.
    public let informationStateTensorShape = [1]

    /// Maximum length of any one game (in terms of number of decision nodes
    /// visited in the game tree). For a simultaneous action game, this is the
    /// maximum number of joint decisions. In a turn-based game, this is the
    /// maximum number of individual decisions summed over all players. Outcomes
    /// of chance nodes are not included in this length.
    public let maxGameLength = Int.max
    
    private let armRewards: Tensor<Double>
    private var armCount: Int { armRewards.scalarCount }
    
    static private let rewardMean = Tensor(0.0)
    static private let rewardStandardDeviation = Tensor(1.0)
    static private let rewardSampleStandardDeviation = Tensor(1.0)

    public init(armCount: Int = 10) {
        self.armRewards = Tensor(
            randomNormal: TensorShape([armCount]),
            mean: Self.rewardMean,
            standardDeviation: Self.rewardStandardDeviation
        )
    }
}


extension MultiArmedBandit: CustomStringConvertible {
    public var description: String {
        "MultiArmedBandit(rewards: \(armRewards))"
    }
}

extension MultiArmedBandit.State: CustomStringConvertible {
    public var description: String {
        let meanReward = history.last != nil ? game.armRewards[history.last!].scalarized() : 0.0
        return "MultiArmedBandit.State(sampledReward: \(sampledReward), meanReward: \(meanReward))"
    }
}
