import XCTest

import BanditTests
import GaunerTests
import UtilitiesTests

var tests = [XCTestCaseEntry]()
tests += BanditTests.__allTests()
tests += GaunerTests.__allTests()
tests += UtilitiesTests.__allTests()

XCTMain(tests)
