//
//  ModuleModel.swift
//  MyTime
//
//  Created by Brian on 08/11/2019.
//

import UIKit

protocol EncodableToAppModel {
    associatedtype AppModel
    func toAppModel() -> AppModel?
}

protocol DecodableFromAppModel {
    associatedtype AppModel
    static func from(appModel: AppModel) -> Self?
}

typealias CodableForAppModel = EncodableToAppModel & DecodableFromAppModel
