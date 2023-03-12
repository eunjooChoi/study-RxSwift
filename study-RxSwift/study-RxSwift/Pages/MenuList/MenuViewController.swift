//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle

    let cellId = "MenuItemTableViewCell"
    let viewModel = MenuListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 이렇게 해놓으면 menuObservable이 바뀌면 자동으로 tableViewCell의 내용이 바뀜 (UITableViewDataSource 필요 없음)
        viewModel.menuObservable
            .bind(to: tableView.rx.items(cellIdentifier: "MenuItemTableViewCell", cellType: MenuItemTableViewCell.self)) { index, item, cell in
                // index: IndexPathRow, item: menu[n] 아이템 (cellForRowAt 메서드를 여기서 처리하는군..!)
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
            }
            .disposed(by: disposeBag)
        
        // 처음 한 번만 subscribe 하면 값이 바뀔 때마다 totalPrice와 itemCount 값이 변경됨
        viewModel.itemsCount
            .map { "\($0)" }
            .observe(on: MainScheduler.instance)    // main thread에서 text를 갱신
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .map { $0.currencyKR() }
            .observe(on: MainScheduler.instance)
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
        
        /*
         .subscribe(onNext: {
             self.itemCountLabel.text = $0
         }) 와 bind는 같은 동작을 함. 근데 bind는 rxcocoa에 들은 것. bind는 순환 참조 신경 안써도 됨.
         */
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        // 담아둔 item을 모두 제거
        viewModel.clearAllItemSelections()
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
        
        viewModel.menuObservable.onNext([
            Menu(name: "김말이", price: 9, count: 2)
        ])
        //performSegue(withIdentifier: "OrderViewController", sender: nil)
    }
}
