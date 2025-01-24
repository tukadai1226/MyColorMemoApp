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
        
        // テーブルビューに表示する内容のUITableViewDataSourceプロトコルに記載されている内容を読み込む
        tableView.dataSource = self
        // テーブルビューにUITableViewDelegateプロトコルに記載された内容を読み込む
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        setMemoData()
        // ホーム画面のヘッダーに+(メモ追加ボタン)を配置し、ボタンタップで詳細画面に遷移するメソッド
        setNavigationBarButton()
    }
    
    func setMemoData() {
        for i in 1...5 {
            let memoDataModel = MemoDataModel(text: "このメモは\(i)番目のメモです。", recordDate: Date())
            memoDataList.append(memoDataModel)
        }
    }
    
    // 新しいメモを追加する
    // ホーム画面のヘッダーに+(メモ追加ボタン)を配置し、ボタンタップで詳細画面に遷移するメソッド
    // セレクタークラスに指定されたメソッドには@objcを先頭に記載する。(セレクタークラスに指定したメソッドがobjective-c言語で実行されるため)
    @objc func tapAddoButton() {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        // メモ詳細画面のViewControllerを取得して画面遷移させる。
        let memoDetailViewController = storyboad.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    func setNavigationBarButton() {
        // セレクタークラス(ヘッダーに表示するボタンをタップした際の処理を指定するクラス)をインスタンス化する
        // セレクターは#selectorと記載するルールがある。引数で指定したメソッドを呼び出す
        let buttonActionSelector: Selector = #selector(tapAddoButton)
        // UIBarButtonItemクラスをインスタンス化している
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        navigationItem.rightBarButtonItem = rightBarButton
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        // indexPath.row→UItableViewに表示されるCellの(0から始まる)通り番号が順番に渡される
        let memoDataModel: MemoDataModel = memoDataList[indexPath.row]
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    // UIViewのセルがタップされた際にタップされたセルのインデックス番号が渡されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index番号は\(indexPath.row)番です")
        // main.storyboadをインスタンス化してコード上でストーリーボードを使えるようにする
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        // instantiateViewControllerメソッドを使用して遷移先のMemoDetailViewControllerをインスタンス化する
        let memoDetailViewController = storyboad.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        // 画面遷移する際にデータも渡す処理
        let memoData = memoDataList[indexPath.row]
        memoDetailViewController.configure(memo: memoData)
        // セルの選択状態を解除する(解除するセルを渡す)
        tableView.deselectRow(at: indexPath, animated: true)
        // ナビゲーションコントローラーのpushViewControllerメソッドを使用し画面遷移を定義する。
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
}
