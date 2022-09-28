//
//  RetryPolicyTests.swift
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@testable import PayKit
import XCTest

class RetryPolicyTests: XCTestCase {
    func test_exponential_lockout() {
        XCTAssertEqual(RetryPolicy.exponential(delay: 5, attempt: 0, maximumNumberOfAttempts: 5).lockout, 0)
        XCTAssertEqual(RetryPolicy.exponential(delay: 5, attempt: 1, maximumNumberOfAttempts: 5).lockout, 5)
        XCTAssertEqual(RetryPolicy.exponential(delay: 5, attempt: 2, maximumNumberOfAttempts: 5).lockout, 15)
        XCTAssertEqual(RetryPolicy.exponential(delay: 5, attempt: 3, maximumNumberOfAttempts: 5).lockout, 35)
        XCTAssertEqual(RetryPolicy.exponential(delay: 5, attempt: 4, maximumNumberOfAttempts: 5).lockout, 75)
    }

    func test_exponential_default_values() {
        XCTAssertEqual(
            RetryPolicy.exponential(maximumNumberOfAttempts: 5),
                .exponential(delay: 2, attempt: 0, maximumNumberOfAttempts: 5)
        )
    }

    func test_decrement_exponential_lockout() {
        let policy = RetryPolicy.exponential(delay: 5, attempt: 0, maximumNumberOfAttempts: 3)
        let firstAttempt = policy.decrement()
        XCTAssertEqual(firstAttempt, RetryPolicy.exponential(delay: 5, attempt: 1, maximumNumberOfAttempts: 3))
        let secondAttempt = firstAttempt?.decrement()
        XCTAssertEqual(secondAttempt, RetryPolicy.exponential(delay: 5, attempt: 2, maximumNumberOfAttempts: 3))
        XCTAssertNil(secondAttempt?.decrement())
    }
}
