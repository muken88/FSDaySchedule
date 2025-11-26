//
//  FSScheduleEditableView.swift
//  FSDaySchedule
//
//  Created by liaoyu on 2025/11/25.
//

import UIKit
/**
    编辑事件类型
 - edit: 更改已有日程的时间
 - add: 新增日程
 */
enum FSScheduleEditableType {
    ///更改已有日程的时间
    case edit
    ///新增日程
    case add
}

/**
    编辑日程时间类型
 - begin: 更改开始时间
 - end: 更改结束时间
 - beginEnd: 更改开始和结束时间
 */
enum FSScheduleEditableEvenType {
    ///更改开始时间
    case begin
    ///更改结束时间
    case end
    ///更改开始和结束时间
    case beginEnd
}

/// 单击FSDayScheduleView时,出现的创建计划view,或者长按某个计划时出现的可编辑View,可上下拖动,可修改开始时间和结束时间
class FSScheduleEditableView: UIView {
    static var TintColor: UIColor {
        return UIColor(red: 226/255, green: 237/255, blue: 253/255, alpha: 1)
    }
    
    static var blueColor: UIColor {
        return UIColor(red: 62/255, green: 136/255, blue: 243/255, alpha: 1)
    }
    
    // MARK: - public
    ///点击事件,进入创建事件页面
    var tapAction: (() -> Void)?
    let editType: FSScheduleEditableType
    var editEvenType: FSScheduleEditableEvenType?
    var editView = FSScheduleEditMaskView()
    ///关联日程View,只有editType是.edit类型时才有值
    weak var associateItemView: FSDayScheduleItemView?
    
    // MARK: - private
    private var titleLabelInset: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    //容器view
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = FSScheduleEditableView.TintColor
        view.layer.masksToBounds = true
        view.layer.borderColor = FSScheduleEditableView.blueColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    ///标题label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = FSScheduleEditableView.blueColor
        label.numberOfLines = 0
        
        let arr = UserDefaults.standard.object(forKey: "AppleLanguages") as! Array<String>;
        if arr.first == "en" {
            label.text = "New Schedule"
        } else {
            label.text = "再次点击创建日程"
        }
        return label
    }()
    
    // MARK: - life cycle
    required init?(coder: NSCoder) {
        fatalError("no implement")
    }
    
    init(type: FSScheduleEditableType, associateItemView: FSDayScheduleItemView? = nil) {
        self.editType = type
        self.associateItemView = associateItemView
        if type == .edit {
            assert(associateItemView != nil, "为编辑类型时,关联日程view不能为空")
        }
        super.init(frame: .zero)
        commonInit()
    }
    
    private override init(frame: CGRect) {
        self.editType = .add
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        if editType == .add {
            containerView.addSubview(titleLabel)
            titleLabel.textAlignment = .center
            titleLabel.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(20)
                make.center.equalTo(containerView)
//                make.left.equalTo(titleLabelInset.left)
//                make.top.equalTo(titleLabelInset.top)
//                make.right.equalTo(titleLabelInset.right)
//                make.bottom.lessThanOrEqualTo(-titleLabelInset.bottom)
            }
        }
        
        //添加编辑view
        editView.layer.cornerRadius = containerView.layer.cornerRadius
        addSubview(editView)
        editView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        if editType == .add {
            //添加点击手势
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(onGestureAction(_:)))
            addGestureRecognizer(tapGest)
        }
    }
    
    @objc func onGestureAction(_ sender: UIGestureRecognizer) {
        guard sender.state == .ended else { return }
        self.tapAction?()
    }
    
}

// MARK: - public func
extension FSScheduleEditableView {
    
    var timeData: FSScheduleTimeInfo {
        return editView.timeData
    }
    
    var editMaskView: FSScheduleEditMaskView {
        return editView
    }
    
    func becomeEditStatus(timeData: FSScheduleTimeInfo) {
        self.isHidden = false
        
        //重设高度和位置
        self.top = timeData.begin.verticalPosition
        self.height = timeData.length.verticalPosition
        updateViewData(timeData)
    }
    
    func resignEditStatus() {
//        self.associateItemView?.resignEditStatus()
        self.removeFromSuperview()
    }
    
    func updateViewData(_ data: FSScheduleTimeInfo) {
        editView.timeData = data
        
    }
}
