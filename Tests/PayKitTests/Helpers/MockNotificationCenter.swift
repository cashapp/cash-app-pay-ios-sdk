//
//  MockNotificationCenter.swift
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
import UIKit

class MockNotificationCenter: NotificationCenter, @unchecked Sendable {
    var addObserverStub: ((Any, Selector, NSNotification.Name?, Any?) -> Void)

    init(addObserverStub: @escaping (Any, Selector, NSNotification.Name?, Any?) -> Void) {
        self.addObserverStub = addObserverStub
    }

    override func addObserver(
        _ observer: Any,
        selector aSelector: Selector,
        name aName: NSNotification.Name?,
        object anObject: Any?
    ) {
        addObserverStub(observer, aSelector, aName, anObject)
    }
}
