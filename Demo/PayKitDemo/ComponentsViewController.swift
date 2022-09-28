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
        case 0: cell = CashAppDemoCell(title: "Small Button", view: CashAppPayButton(size: .small, onClickHandler: {}))
        case 1: cell = CashAppDemoCell(title: "Large Button", view: CashAppPayButton(size: .large, onClickHandler: {}))
        case 2: cell = CashAppDemoCell(
            title: "Small Payment Method",
            view: CashAppPaymentMethod(size: .small, cashTag: "$jack")
        )
        case 3: cell = CashAppDemoCell(
            title: "Large Payment Method",
            view: CashAppPaymentMethod(size: .large, cashTag: "$jack")
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
        4
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        (section == 0) ? "Light Mode" : "Dark Mode"
    }
}

// MARK: - View Building

extension ComponentsViewController {
    final class CashAppDemoCell: UITableViewCell {
        init(title: String, view: UIView) {
            super.init(style: .default, reuseIdentifier: nil)
            let titleLabel = UILabel()
            titleLabel.font = .boldSystemFont(ofSize: 18)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = title

            let stack = UIStackView(arrangedSubviews: [view])
            stack.axis = .vertical
            stack.distribution = .fillProportionally
            stack.alignment = .center
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
