//
//  ComponentsViewController.swift
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
import PayKitUI
import UIKit

class ComponentsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Components"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .lightGray
    }

    private struct Row {
        let title: String
        var fillsWidth = false
        /// Builds a new view for each cell, since a view can only be in one cell at a time.
        let makeView: () -> UIView
    }

    private let rows: [Row] = [
        Row(title: "Cash App (Default)") { CashAppPayButton(onClickHandler: {}) },
        Row(title: "Pay with") { CashAppPayButton(label: .pay, onClickHandler: {}) },
        Row(title: "Cash out with") { CashAppPayButton(label: .cashOut, onClickHandler: {}) },
        Row(title: "Continue with") { CashAppPayButton(label: .continue, onClickHandler: {}) },
        Row(title: "Checkout with (White)") { CashAppPayButton(label: .checkout, style: .white, onClickHandler: {}) },
        Row(title: "Buy with") { CashAppPayButton(label: .buy, onClickHandler: {}) },
        Row(title: "Small Disabled (White)") {
            let smallButton = CashAppPayButton(style: .white, size: .small, onClickHandler: {})
            smallButton.isEnabled = false
            return smallButton
        },
        Row(title: "Monochrome Black") { CashAppPayButton(style: .monochromeBlack, onClickHandler: {}) },
        Row(title: "Monochrome White") { CashAppPayButton(style: .monochromeWhite, onClickHandler: {}) },
        Row(title: "Cash App (Green)") { CashAppPayButton(style: .green, onClickHandler: {}) },
        Row(title: "Pay with (Green)") { CashAppPayButton(label: .pay, style: .green, onClickHandler: {}) },
        Row(title: "Buy with (Green)") { CashAppPayButton(label: .buy, style: .green, onClickHandler: {}) },
        Row(title: "Cash out with (Green)") { CashAppPayButton(label: .cashOut, style: .green, onClickHandler: {}) },
        Row(title: "Checkout with (Green)") { CashAppPayButton(label: .checkout, style: .green, onClickHandler: {}) },
        Row(title: "Continue with (Green)") { CashAppPayButton(label: .continue, style: .green, onClickHandler: {}) },
        Row(title: "Small Payment Method") { CashAppPaymentMethod(size: .small, cashTag: "$jack") },
        Row(title: "Large Payment Method", fillsWidth: true) { CashAppPaymentMethod(size: .large, cashTag: "$jack") },
        Row(title: "Small Payment Method") {
            CashAppPaymentMethod(size: .small, cashTag: "$jack", usePolychromeAsset: true)
        },
        Row(title: "Large Payment Method", fillsWidth: true) {
            CashAppPaymentMethod(size: .large, cashTag: "$jack", usePolychromeAsset: true)
        },
    ]

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = CashAppDemoCell(title: row.title, view: row.makeView(), fillsWidth: row.fillsWidth)
        cell.overrideUserInterfaceStyle = (indexPath.section == 0) ? .light : .dark
        cell.backgroundColor = .lightGray
        cell.selectionStyle = .none
        return cell
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        (section == 0) ? "Light Mode" : "Dark Mode"
    }
}

// MARK: - View Building

extension ComponentsViewController {
    final class CashAppDemoCell: UITableViewCell {
        /// - Parameter fillsWidth: Stretch `view` to the cell's width, as the large payment method does in an app.
        init(title: String, view: UIView, fillsWidth: Bool = false) {
            super.init(style: .default, reuseIdentifier: nil)
            let titleLabel = UILabel()
            titleLabel.font = .boldSystemFont(ofSize: 18)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = title

            let stack = UIStackView(arrangedSubviews: [view])
            stack.axis = .vertical
            stack.distribution = .fillProportionally
            stack.alignment = fillsWidth ? .fill : .center
            stack.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(titleLabel)
            contentView.addSubview(stack)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            ])
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
