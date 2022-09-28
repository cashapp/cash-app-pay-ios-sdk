//
//  RetryPolicy.swift
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

import Foundation

enum RetryPolicy: Equatable {
    case exponential(delay: TimeInterval = 2, attempt: Int = 0, maximumNumberOfAttempts: Int)

    /// The delay before the request can be retried.
    var lockout: TimeInterval {
        switch self {
        case .exponential(delay: let interval, attempt: let attempt, maximumNumberOfAttempts: _):
            return RetryPolicy.exponentialBackoffCalculation(interval: interval, retryNumber: attempt)
        }
    }

    /// Returns  the retry policy for the next attempt or nil if the policy indiciates it should not run again.
    func decrement() -> RetryPolicy? {
        switch self {
        case .exponential(delay: let delay, attempt: let attempt, maximumNumberOfAttempts: let maximumNumberOfAttempts):
            let attempts = attempt + 1
            guard attempts < maximumNumberOfAttempts else { return nil }
            return .exponential(delay: delay, attempt: attempts, maximumNumberOfAttempts: maximumNumberOfAttempts)
        }
    }
}

// MARK: - Calculations

private extension RetryPolicy {
    /// Calculation based on https://en.wikipedia.org/wiki/Exponential_backoff#Expected_backoff
    private static func exponentialBackoffCalculation(interval: TimeInterval, retryNumber: Int) -> TimeInterval {
        interval * (pow(2, Double(retryNumber)) - 1)
    }
}
