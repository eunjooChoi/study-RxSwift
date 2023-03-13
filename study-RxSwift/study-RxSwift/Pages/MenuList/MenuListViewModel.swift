//
//  MenuListViewModel.swift
//  study-RxSwift
//
//  Created by 최은주 on 2023/03/11.
//

import Foundation
import RxSwift

// 모든 데이터 로직 처리는 뷰모델에서!
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
        // APIService를 통해 받은 data를 [MenuItem]으로 가공 하고 최종적으로는 실제 ViewModel에서 사용하는 데이터 타입인 Menu로 변환함.
        // 수행은 한 번만 하면 되므로 take 사용
        _ = APIService().fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Respose: Decodable {
                    let menus: [MenuItem]
                }
                
                let response = try! JSONDecoder().decode(Respose.self, from: data)
                
                return response.menus
            }
            .map { menuItems -> [Menu] in
                var menus: [Menu] = []
                
                menuItems.enumerated().forEach { (idx, item) in
                    let menu =  Menu.fromMenuItems(id: idx, item: item)
                    menus.append(menu)
                }
                
                return menus
            }
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func order() {
        
    }
    
    func clearAllItemSelections() {
        _ = menuObservable.map { menu in
                let newMenu = menu
                return newMenu.map {
                    Menu(id: $0.id,name: $0.name, price: $0.price, count: 0)
                }
            }
            .take(1)        // 한 번만 수행할거야
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func changeCount(item: Menu, increace: Int) {
        _ = menuObservable.map { menu in
                let newMenu = menu
                return newMenu.map {
                    // increase를 받아 더하거나 빼서 값을 갱신
                    // max($0.count + increase, 0)으로도 간단하게 확인 가능..
                    guard $0.id == item.id else {
                        return Menu(id: $0.id, name: $0.name, price: $0.price, count: $0.count)
                    }
                    
                    guard $0.count + increace >= 0 else {
                        return Menu(id: $0.id, name: $0.name, price: $0.price, count: $0.count)
                    }
                    
                    return Menu(id: $0.id, name: $0.name, price: $0.price, count: $0.count + increace)
                }
            }
            .take(1)        // 한 번만 수행할거야
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
}
