import XCTest
import TensorFlow
import OpenSpiel
import MultiArmedBandit


final class MultiArmedBanditTests: XCTestCase {

    func testRandomActions() {
        let bandit = MultiArmedBandit(armCount: 10)
        print(bandit)
    }
    
    func testStationary() {
        let stationaryBandit = MultiArmedBandit(stationary: true)
        //stationaryBandit.initialState.armRewardPlot.show()
        print(stationaryBandit)


        let nonStationaryBandit = MultiArmedBandit(stationary: false)
        //nonStationaryBandit.initialState.armRewardPlot.show()
        print(nonStationaryBandit)
    }
    
    func testRandomSeedRepeatability() {
        let bandit = MultiArmedBandit(stationary: false)
        let fixedActions = (0...100).map { _ in bandit.allActions.randomElement()! }
        let fixedSeed = randomSeedForTensorFlow()

        var state0 = bandit.initialState
        var utilities0 = [Double]()
        withRandomSeedForTensorFlow(fixedSeed) {
            state0 = bandit.initialState

            for fixedAction in fixedActions {
                let utility = state0.utility(for: .player(0))
                utilities0.append(utility)
                
                state0 = state0.applying(fixedAction)
            }
        }
        
        var state1 = bandit.initialState
        var utilities1 = [Double]()
        withRandomSeedForTensorFlow(fixedSeed) {
            state1 = bandit.initialState

            for fixedAction in fixedActions {
                let utility = state1.utility(for: .player(0))
                utilities1.append(utility)
                
                state1 = state1.applying(fixedAction)
            }
        }
        
        XCTAssertEqual(utilities0, utilities1)
        XCTAssertEqual(state0, state1)
    }
}
