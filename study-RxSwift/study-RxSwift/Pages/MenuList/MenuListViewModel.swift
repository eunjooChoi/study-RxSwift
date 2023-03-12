//
//  MenuListViewModel.swift
//  study-RxSwift
//
//  Created by 최은주 on 2023/03/11.
//

import Foundation
import RxSwift

class MenuListViewModel {
    // Subject: Observable 밖에서 값을 변경할 수 있음. 밖에서 onNext 호출 가능한
    // PublishSubject를 사용하면 init하는 순간에 onNext로 데이터를 뱉는데, 이 때는 아직 tableView가 설정이 안된 상태라 데이터를 받을 수 없으므로 여기서는 BehaviorSubject를 사용해 구독하는 순간 가지고 있던 menu 배열을 emit할 수 있도록 한다.
    var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemsCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    // observable의 메뉴가 바뀔 때마다 totalPrice가 자동으로 바뀜
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        let menu: [Menu] = [Menu(name: "떡볶이", price: 3000, count: 0),
                            Menu(name: "떡볶이", price: 3000, count: 0),
                            Menu(name: "떡볶이", price: 3000, count: 0),
                            Menu(name: "떡볶이", price: 3000, count: 0)]
        
        menuObservable.onNext(menu)
    }
    
    func clearAllItemSelections() {
        _ = menuObservable.map { menu in
                let newMenu = menu
                return newMenu.map {
                    Menu(name: $0.name, price: $0.price, count: 0)
                }
            }
            .take(1)        // 한 번만 수행할거야
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
}
