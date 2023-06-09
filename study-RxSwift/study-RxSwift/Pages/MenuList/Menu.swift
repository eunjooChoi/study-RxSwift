//
//  Menu.swift
//  study-RxSwift
//
//  Created by 최은주 on 2023/03/11.
//

import Foundation

// Model: View를 위한 Model (View를 표현하기 위한 모델 - ViewModel)
struct Menu {
    let id: Int
    let name: String
    let price: Int
    let count: Int
}

extension Menu {
    static func fromMenuItems(id: Int, item: MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
}
