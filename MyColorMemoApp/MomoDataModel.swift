//
//  MomoDataModel.swift
//  MyColorMemoApp
//
//  Created by 大塚大樹 on 2025/01/24.
//

import Foundation
import RealmSwift  // RealmSwiftをインポートする

// Realmを使用するにはObjectを継承する必要がある
class MemoDataModel: Object {
    // データの固有識別子が必要になるのでidプロパティを追加する
    @objc dynamic var id: String = UUID().uuidString // UUIDは参照する度に一意のIDを付与する
    // Realmではプロパティに@objcと dynamicを記載する必要がある
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
