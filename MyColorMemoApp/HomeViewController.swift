//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by 大塚大樹 on 2025/01/22.
//

import Foundation
import UIKit // UIに関するクラスが格納されたモジュール
import RealmSwift
// UIViewController:UIKitのクラス
class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    // MemoDataModelの宣言
    var memoDataList: [MemoDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // このの画面が表示される際に呼び出されるメソッド
        // 画面の表示・非表示に応じて実行されるメソッドをライフサイクルと呼ぶ
        
        // テーブルビューに表示する内容のUITableViewDataSourceプロトコルに記載されている内容を読み込む
        tableView.dataSource = self
        // テーブルビューにUITableViewDelegateプロトコルに記載された内容を読み込む
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        // ホーム画面のヘッダーに+(メモ追加ボタン)を配置し、ボタンタップで詳細画面に遷移するメソッド
        setNavigationBarButton()
    }
    
    // 画面が表示されるたびに毎回データを取得するようにviewWillApperにsetMemoDataメソッドを追記
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMemoData()
        // UITableViewの表示更新をするtableView.reloadDataを追記
        tableView.reloadData()
    }
    // Realmからメモデータを取得する
    func setMemoData() {
        // Realmをインスタンス化
        let realm = try! Realm()
        // インスタンス化したRealmから全件取得
        let result = realm.objects(MemoDataModel.self)//realm.objects()メソッドは、取得したいデータの型を引数として要求します。MemoDataModel.selfを渡すことで、「MemoDataModel型のデータを取得する」という指示をRealmに与えています。
        // 取得結果を配列としてメモデータリストに代入する
        memoDataList = Array(result)
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
 // UITableViewDataSourceはテーブルビューにデータを提供するプロトコル
extension HomeViewController: UITableViewDataSource {
    // テーブルビューに表示する行数（セルの数）を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 配列に格納されているデータの数だけ、セルが表示される(memoDataListの要素の数を取り出して指定する)
        return memoDataList.count
    }
    // cellForRowAt: 各行（セル）に表示するデータを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle,                // style: .subtitle:セルのスタイルを指定（メインのテキストと詳細テキストを表示）
                                   reuseIdentifier: "cell")         // reuseIdentifier: "cell":セルを再利用するための識別子を指定
        // indexPath.row→UItableViewに表示されるCellの(0から始まる)通り番号が順番に渡される
        let memoDataModel: MemoDataModel = memoDataList[indexPath.row]
        cell.textLabel?.text = memoDataModel.text                   // textLabel:メインのテキスト（メモの内容）を表示
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"  // detailTextLabel:サブテキスト（メモの作成日時）を表示
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
    // UITableViewのセルが横スワイプされた際に実行されるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // データの削除処理を実行
        let targetMemo = memoDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetMemo)
        }
        // 上記の削除だけではRealmの削除は完了してもこのクラスのプロパティにデータが残ったままなので表示されたままになってしまうので削除する
        // memoDataListの配列から削除
        memoDataList.remove(at: indexPath.row)
        // deleteRows(at:with:):テーブルビューから、削除対象のセルを取り除く
        tableView.deleteRows(at: [indexPath], with: .automatic)  // with: .automatic:セルの削除時に、適切なアニメーション（スライドアウトなど）を適用
    }
}
