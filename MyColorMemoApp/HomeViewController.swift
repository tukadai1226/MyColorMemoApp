//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by 大塚大樹 on 2025/01/22.
//

import Foundation
import UIKit // UIに関するクラスが格納されたモジュール
// UIViewController:UIKitのクラス
class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    // MemoDataModelの宣言
    var memoDataList: [MemoDataModel] = []
    
    override func viewDidLoad() {
        // このの画面が表示される際に呼び出されるメソッド
        // 画面の表示・非表示に応じて実行されるメソッドをライフサイクルと呼ぶ
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        setMemoData()
    }
    
    func setMemoData() {
        for i in 1...5 {
            let memoDataModel = MemoDataModel(text: "このメモは\(i)番目のメモです。", recordDate: Date())
            memoDataList.append(memoDataModel)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    // リストの数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // memoDataListの要素の数を取り出して指定する
        return memoDataList.count
    }
    // リストの中身を定義
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // indexPath.row→UItableViewに表示されるCellの(0から始まる)通り番号が順番に渡される
        let memoDataModel: MemoDataModel = memoDataList[indexPath.row]
        cell.textLabel?.text = memoDataModel.text
        return cell
    }
}
