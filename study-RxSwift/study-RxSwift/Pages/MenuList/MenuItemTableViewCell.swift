//
//  MenuItemTableViewCell.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 07/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var price: UILabel!
    
    // 클로저로 count 값을 조절하고, vc에 cell bind 내부에서 viewModel의 데이터를 변경할 수 있도록 함
    var onChange: ((Int) -> Void)?

    @IBAction func onIncreaseCount() {
        onChange?(1)
    }

    @IBAction func onDecreaseCount() {
        onChange?(-1)
    }
}
