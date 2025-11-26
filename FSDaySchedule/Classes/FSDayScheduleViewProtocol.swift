//
//  FSDayScheduleViewProtocol.swift
//  FSDaySchedule
//
//  Created by liaoyu on 2025/11/25.
//

import Foundation

public protocol FSDayScheduleViewItemRepresentable {
    var id: Int { get }
    var sId: String { get }
    var name: String { get }
    var isOverDay: Bool { get }
    var timeInfo: FSScheduleTimeInfo { get }
}

public protocol FSDayScheduleViewDelegate: AnyObject {
    ///新建日程
    func dayScheduleView(_ dayScheduleView: FSDayScheduleView, createNewItemWith timeInfo: FSScheduleTimeInfo)
    ///点击某个日程
    func dayScheduleView(_ dayScheduleView: FSDayScheduleView, didSelectItem item: FSDayScheduleViewItemRepresentable)
    ///编辑已有日程,timeInfo是编辑后的时间
    func dayScheduleView(_ dayScheduleView: FSDayScheduleView, editItem item: FSDayScheduleViewItemRepresentable, timeInfo: FSScheduleTimeInfo)
}

@objc public protocol FSDayScheduleViewDelegateObjc {
    /**新建日程*/
    @objc optional func dayScheduleView(startStr:String,endStr:String)
    /**点击某个日程*/
    @objc optional func dayScheduleView(_ dayScheduleView:FSDayScheduleView,didSelectItem model:ScheduleObjcModel)
    /**编辑某个日程*/
    @objc optional func dayScheduleView(_ dayScheduleView:FSDayScheduleView,editItem model:ScheduleObjcModel)
    /**将要编辑某个日程*/
    @objc optional func dayScheduleView(_ dayScheduleView:FSDayScheduleView,willEditItem model:ScheduleObjcModel)
}

internal protocol FSDayScheduleItemViewActionProtocl {
    typealias TapAction = ((FSDayScheduleViewItemRepresentable) -> Void)
    typealias WillEditAction = ((FSDayScheduleViewItemRepresentable) -> Void)
    ///itemView动作回调,目前仅支持点击事件
    var itemViewAction: TapAction? { get set }
}
