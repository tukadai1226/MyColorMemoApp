//
//  MyColerType.swift
//  MyColorMemoApp
//
//  Created by 大塚大樹 on 2025/01/25.
//

import Foundation
import UIKit

enum MyColerType: Int {
    // defaultは予約語(ifやclassなど)で重複しないように``で囲む
    case `default`  // #ffffff
    case orange     // #f8c165
    case red        // #d24141
    case blue       // #4187fa
    case pink       // #f064b9
    case green      // #50aa41
    case purple     // #965ad2
    
    var color: UIColor {
        switch self {  // colorプロパティが呼び出されると、現在のMyColorTypeの値がselfとして渡される。例えば、MyColorType.orange.colorが呼ばれた場合、selfは.orangeを指す。
        case .default: return .white
        case .orange: return UIColor.rgba(red: 248, green: 193, blue: 101, alpha: 1)
        case.red: return UIColor.rgba(red: 210, green: 65, blue: 65, alpha: 1)
        case .blue: return UIColor.rgba(red: 65, green: 135, blue: 250, alpha: 1)
        case .pink: return UIColor.rgba(red: 240, green: 100, blue: 185, alpha: 1)
        case .green: return UIColor.rgba(red: 80, green: 170, blue: 65, alpha: 1)
        case .purple: return UIColor.rgba(red: 150, green: 90, blue: 210, alpha: 1)
        }
    }
}
// UIClorとはUIコンポーネントに配色するクラス
extension UIColor {
    // RGBAをカラーコードに変換する
    static func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}
