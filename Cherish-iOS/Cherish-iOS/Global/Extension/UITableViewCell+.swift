//
//  UITableViewCell+.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/11/09.
//
import UIKit

extension UITableViewCell {
    //MARK: - cell 내에서 자신의 index 파악하기
    func getTableCellIndexPath() -> Int {
        var indexPath = 0
        
        guard let superView = self.superview as? UITableView else {
            return -1
        }
        indexPath = superView.indexPath(for: self)!.row

        return indexPath
    }
}
