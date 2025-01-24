//
//  MemoDetailViewController.swift
//  MyColorMemoApp
//
//  Created by 大塚大樹 on 2025/01/24.
//

import UIKit
import RealmSwift

class MemoDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var memoData = MemoDataModel()
    
    // 日付のフォーマットを変換
    //コンピュティッドプロパティで値を値を保持するのではなく、プロパティが呼び出されたときに内部で計算を行い、その結果を返す
    //毎回呼び出すたびに新しいDateFormatterインスタンスが作られる

    var dateFormat: DateFormatter {
        // DateFormatterクラスをインスタンス化
        let dateFormatter = DateFormatter()
        //DateFormatterクラスのdateFormatプロパティに文字列を代入することでフォーマットを指定
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayData()
        setDoneButton()
        
        // UITextViewのデリゲートを設定
        textView.delegate = self
    }
    
    // MemoDetailViewControllerにメモデータを渡すメソッド
    func configure(memo: MemoDataModel) {
        memoData.text = memo.text
        memoData.recordDate = memo.recordDate
        print("データは\(memoData.text)と\(memoData.recordDate)です")
    }
    
    // メモ詳細を表示するメソッド
    func displayData() {
        textView.text = memoData.text
        // UIViewControllerクラスが持つ機能にnavigationItemがある
        // コンピュティッドプロパティでrecordDateというDate型の値を、指定されたフォーマット（ここでは"yyyy年MM月dd日"）に基づいて文字列に変換する
        navigationItem.title = dateFormat.string(from: memoData.recordDate)
    }
    
    // キーボードを消す処理
    @objc func tapDoneButton() {
        // 現在表示されているキーボードを閉じる
        view.endEditing(true)
    }
    // 入力文章の一括削除
    @objc func clearButton() {
        textView.text = ""
    }
    
    // キーボードに閉じるボタンを追加するためのメソッド
    func setDoneButton() {
        // UIToolbarクラス(キーボード上部にボタンを配置するためのツールバークラス)をインスタンス化する
        // view.frame.size.width:画面の幅に合わせてツールバーを表示
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        // 左側にクリアボタン(カスタム)
        let clearButton = UIBarButtonItem(title: "クリア", style: .plain, target: self, action: #selector(clearButton))
        // ボタン間のスペース
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 右側のDoneボタン(iOS標準)
        // キーボードを閉じるためのボタンを作成
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        // 作成したボタンをツールバーのプロパティに代入
        // ツールバーには複数のUIコンポーネントを格納できるので、配列形式で代入する
        toolBar.items = [clearButton , flexibleSpace, commitButton]
        //作成したツールバーをUITextViewクラスのinputAccessoryViewに代入することでキーボード上に表示できる
        textView.inputAccessoryView = toolBar
    }
    
    // メモを保存するメソッド
    func saveData(with text: String) {
        // Realmを呼び出す
        let realm = try! Realm()
        // 書き込み開始
        try! realm.write {
            memoData.text = text
            memoData.recordDate = Date()
            realm.add(memoData)
        }
        print("text: \(memoData.text), recordDate: \(memoData.recordDate)")
    }
}
// UITextViewDelegateはUIViewのテキストが変更される度に保存する
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let updatedText = textView.text ?? ""
        saveData(with: updatedText)
    }
    
}
