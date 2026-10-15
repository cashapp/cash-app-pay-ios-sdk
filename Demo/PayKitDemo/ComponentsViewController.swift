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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.row {
        case 0: cell = CashAppDemoCell(title: "Pay with", view: CashAppPayButton(label: .payWith, onClickHandler: {}))
        case 1: cell = CashAppDemoCell(
            title: "Cash out with",
            view: CashAppPayButton(label: .cashOutWith, onClickHandler: {})
        )
        case 2: cell = CashAppDemoCell(
            title: "Checkout with override (White)",
            view: CashAppPayButton(label: .checkoutWith, style: .white, onClickHandler: {})
        )
        case 3:
            let smallButton = CashAppPayButton(label: .payWith, style: .white, size: .small, onClickHandler: {})
            smallButton.isEnabled = false
            cell = CashAppDemoCell(title: "Small Disabled (White)", view: smallButton)
        case 4: cell = CashAppDemoCell(
            title: "Monochrome Black",
            view: CashAppPayButton(label: .payWith, style: .monochromeBlack, onClickHandler: {})
        )
        case 5: cell = CashAppDemoCell(
            title: "Monochrome White",
            view: CashAppPayButton(label: .payWith, style: .monochromeWhite, onClickHandler: {})
        )
        case 6: cell = CashAppDemoCell(
            title: "Green",
            view: CashAppPayButton(label: .payWith, style: .green, onClickHandler: {})
        )
        case 7: cell = CashAppDemoCell(
            title: "Buy with override",
            view: CashAppPayButton(label: .buyWith, onClickHandler: {})
        )
        case 8: cell = CashAppDemoCell(
            title: "Small Payment Method",
            view: CashAppPaymentMethod(size: .small, cashTag: "$jack")
        )
        case 9: cell = CashAppDemoCell(
            title: "Large Payment Method",
            view: CashAppPaymentMethod(size: .large, cashTag: "$jack"),
            fillsWidth: true
        )
        case 10: cell = CashAppDemoCell(
            title: "Small Payment Method",
            view: CashAppPaymentMethod(size: .small, cashTag: "$jack", usePolychromeAsset: true)
        )
        case 11: cell = CashAppDemoCell(
            title: "Large Payment Method",
            view: CashAppPaymentMethod(size: .large, cashTag: "$jack", usePolychromeAsset: true),
            fillsWidth: true
        )
        default:
            cell = UITableViewCell()
        }
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
        12
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
