//
//  DateFormatterTests.swift
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

class DateFormatterTests: XCTestCase {
    func test_formatter() throws {
        let date = try XCTUnwrap(
            DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: .init(secondsFromGMT: 0),
            year: 2022,
            month: 4,
            day: 20,
            hour: 8,
            minute: 30,
            second: 45
            ).date
        )
        XCTAssertEqual(DateFormatter.payKitFormatter().string(from: date), "2022-04-20T08:30:45.000Z")
    }
}
