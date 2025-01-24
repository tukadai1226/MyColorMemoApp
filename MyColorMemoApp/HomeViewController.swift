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
    // ユーザデフォルトのデータにアクセルするための文字列のキー(アプリ内で一意である必要がある)
    let themeColorTypeKey = "themeColorTypeKey"
    
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
        // ナビゲーションにイメージ画像ボタンを追加
        setLeftNavigationBarButton()
        // ユーザーデフォルトに保存されているテーマカラーを反映
        // .integer(forKey:): 指定したキー(themeColorTypeKey)に関連付けられて保存されている整数値を取得
        let themeColorTypeInt = UserDefaults.standard.integer(forKey: themeColorTypeKey)
        // MyColerType は列挙型であり、rawValue を使って列挙型の値を初期化
        // 例えば、themeColorTypeInt が 1 の場合、MyColerType.orange が返される
        let themeColorType = MyColerType(rawValue: themeColorTypeInt) ?? .default
        // 初期のイメージ画像の色を黒にする
        setThemeColor(type: themeColorType)
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
    // ナビゲーションバーに画像を追加
    func setLeftNavigationBarButton() {
        let buttonActionSelector: Selector = #selector(didTapColerSettingButton)
        // ボタンを追加
        // ボタンをインスタンス化しイメージ画像引数で渡し初期化する
        let leftButtonImage = UIImage(named: "colorSttingIcon.png")
        let leftButton = UIBarButtonItem(image: leftButtonImage, style: .plain, target: self, action: buttonActionSelector)
        navigationItem.leftBarButtonItem = leftButton
    }
    // イメージ画像ボタンタップ後の処理
    @objc func didTapColerSettingButton() {
        let defaultAction = UIAlertAction(title: "デフォルト", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .default)
        })
        let orangeAction = UIAlertAction(title: "オレンジ", style: .default, handler: {_ -> Void in
            self.setThemeColor(type: .orange)
            
        })
        let redAction = UIAlertAction(title: "レッド", style: .default, handler: {_ -> Void in
            self.setThemeColor(type: .red)
        })
        let blueAction = UIAlertAction(title: "ブルー", style: .default, handler: {_ -> Void in
            self.setThemeColor(type: .blue)
        })
        let greenAction = UIAlertAction(title: "グリーン", style: .default, handler: {_ -> Void in
            self.setThemeColor(type: .green)
        })
        let pinkAction = UIAlertAction(title: "ピンク", style: .default, handler: {_ -> Void in
            self.setThemeColor(type: .pink)
        })
        let purpleAction = UIAlertAction(title: "パープル", style: .default, handler: {_ -> Void in
            self.setThemeColor(type: .purple)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        // アラートコントローラーの上に表示される文字
        let alert = UIAlertController(title: "テーマカラーを選択して下さい", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(redAction)
        alert.addAction(blueAction)
        alert.addAction(greenAction)
        alert.addAction(pinkAction)
        alert.addAction(purpleAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // UIナビゲーションバーの配色を変更するメソッド
    func setThemeColor(type: MyColerType) {
        // navigationControllerクラスのnavigationBar.barTintColorに色を代入する
        // navigationControllerがnilでないか確認
        guard let navigationBar = navigationController?.navigationBar else {
            print("NavigationControllerが存在しません")
            return
        }
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = type.color
            // 指定されたナビゲーションの色がデフォルトかどうかを判別する
            let isDefault = type == .default
            // 指定された色がデフォルトだった場合は黒、デフォルト以外は白を代入する
            let tintColor: UIColor = isDefault ? .black : .white
            // ボタンの色を代入する
            navigationController?.navigationBar.tintColor = tintColor
            // ナビゲーションバーのタイトルの色もイメージカラーと同じ色にする
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor] // Dictionary型[Key: Value]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            print("color:\(type)")
        } else {
            // iOS 14以前の場合
            navigationBar.barTintColor = type.color
            print("color:\(type)")
            // 指定されたナビゲーションの色がデフォルトかどうかを判別する
            let isDefault = type == .default
            // 指定された色がデフォルトだった場合は黒、デフォルト以外は白を代入する
            let tintColor: UIColor = isDefault ? .black : .white
            // ボタンの色を代入する
            navigationController?.navigationBar.tintColor = tintColor
            // ナビゲーションバーのタイトルの色もイメージカラーと同じ色にする
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor] // Dictionary型[Key: Value]
        }
        // ユーザーデフォルトにイメージカラーを保存
        saveThemeColor(type:type)
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
    // ユーザーデフォルトにデータを保存する(standardメソッドを使用する)
    func saveThemeColor(type: MyColerType) {
        UserDefaults.standard.set(type.rawValue, forKey: themeColorTypeKey) // type:保存する値 forkey:データにアクセルするための文字列のキー
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
