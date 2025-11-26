//
//  FSScheduleEditMaskView.swift
//  FSDaySchedule
//
//  Created by liaoyu on 2025/11/25.
//

import UIKit

protocol FSScheduleEditMaskProtocol {
    
    /// 根据触摸位置,获取编辑事件类型,
    /// - Parameter position: 该position需转换为EditMaskView的坐标系下
    func editEvenTypeWithTouchPosition(_ position: CGPoint?) -> FSScheduleEditableEvenType?
}

/// 编辑遮罩view,在创建计划和编辑计划时都复用此view
class FSScheduleEditMaskView: UIView {
    
    /// 圆点的直径
    private static var CircleDiameter: CGFloat {
        return 10
    }
    
    // MARK: - public
    var timeData: FSScheduleTimeInfo {
        get {
            return _timeData
        }
        set {
            if _timeData != newValue {
                _timeData = newValue
                shakeFeedback()
                updateBeginEndTime()
            }
        }
    }
    
    // MARK: - var
    
    private let feedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private var _timeData: FSScheduleTimeInfo = .zero
    
    private var beginTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = FSScheduleEditableView.blueColor
        return label
    }()
    
    private var endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = FSScheduleEditableView.blueColor
        return label
    }()
    
    /// 顶部热区View,当手指在这个view上拖动时,表示触发了更改起点时间的事件
    private let topHotView = UIView()
    /// 底部热区view,当手指在这个view上拖动时,表示触发了更改结束时间的事件
    private let bottomHotView = UIView()
    // MARK: - life cycle
    required init?(coder: NSCoder) {
        fatalError("no implement")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加起始,终止时间label
        addSubview(beginTimeLabel)
        addSubview(endTimeLabel)
        let beginTimeLabelLeft = FSDayScheduleBaseLineView.TimeLabelLeft - FSDayScheduleView.ItemSuperViewEdgeInsets.left
        beginTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(beginTimeLabelLeft)
            make.centerY.equalTo(self.snp.top)
        }
        
        endTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(beginTimeLabelLeft)
            make.centerY.equalTo(self.snp.bottom)
        }
        
        let hotViewHeight = FSDayScheduleView.OneHourHeight * FSDayScheduleView.MinPlanHourValue * 2
        let widthHeight = FSScheduleEditMaskView.CircleDiameter
        let leftOffset: CGFloat = 28
        let rightOffset: CGFloat = 33
        //添加左上角圆点view
        let leftTopCircle = circleView()
        leftTopCircle.layer.borderWidth = 1
        leftTopCircle.layer.borderColor = FSScheduleEditableView.blueColor.cgColor
        addSubview(leftTopCircle)
        leftTopCircle.snp.makeConstraints { (make) in
            make.left.equalTo(leftOffset)
            make.size.equalTo(CGSize(width: widthHeight, height: widthHeight))
            make.top.equalTo(-widthHeight * 0.5)
        }
        let hotXOffset: CGFloat = 10
        //添加顶部热区view
        addSubview(topHotView)
        topHotView.snp.makeConstraints { (make) in
            make.left.equalTo(hotXOffset)
            make.centerY.equalTo(topHotView.superview!.snp.top)
            make.size.equalTo(CGSize(width: rightOffset * 2, height: hotViewHeight))
        }
        //添加右下角圆点view
        let rightBottomCircle = circleView()
        rightBottomCircle.layer.borderWidth = 1
        rightBottomCircle.layer.borderColor = FSScheduleEditableView.blueColor.cgColor
        addSubview(rightBottomCircle)
        rightBottomCircle.snp.makeConstraints { (make) in
            make.right.equalTo(-rightOffset)
            make.size.equalTo(CGSize(width: widthHeight, height: widthHeight))
            make.bottom.equalTo(widthHeight * 0.5)
        }
        //添加底部热区view
        addSubview(bottomHotView)
        bottomHotView.snp.makeConstraints { (make) in
            make.right.equalTo(-hotXOffset)
            make.centerY.equalTo(bottomHotView.superview!.snp.bottom)
            make.size.equalTo(CGSize(width: rightOffset * 2, height: hotViewHeight))
        }
    }
    
    /// 创建圆点view
    /// - Returns: 圆点view
    private func circleView() -> UIView {
        let circle = UIView()
        circle.backgroundColor = .white
        circle.layer.borderColor = FSScheduleEditableView.blueColor.cgColor
        circle.layer.borderWidth = 0.5
        circle.layer.cornerRadius = FSScheduleEditMaskView.CircleDiameter * 0.5
        return circle
    }
}

extension FSScheduleEditMaskView {
    /// 更新开始结束时间文本
    private func updateBeginEndTime () {
        
        let beginHourValue = FSDayScheduleView.separateFloat(self.timeData.begin)
        self.beginTimeLabel.text = String.init(format: "%02d:%02d", Int(beginHourValue.integerValue), Int(beginHourValue.decimalValue * 60))
        
        let endHourValue = FSDayScheduleView.separateFloat(self.timeData.end)
        self.endTimeLabel.text = String.init(format: "%02d:%02d", Int(endHourValue.integerValue), Int(endHourValue.decimalValue * 60))
    }
}

extension FSScheduleEditMaskView: FSScheduleEditMaskProtocol {

    func editEvenTypeWithTouchPosition(_ position: CGPoint?) -> FSScheduleEditableEvenType? {
        guard let position = position else { return nil }
        
        if self.topHotView.frame.contains(position) {
            return .begin
        } else if self.bottomHotView.frame.contains(position) {
            return .end
        } else if self.frame.contains(position) {
            return .beginEnd
        } else {
            print("异常情况.触摸起点位置不在边界")
        }
        return nil
    }
    
    func containsPoint(_ point: CGPoint?) -> Bool {
        guard let point = point else {
            return false
        }
        if self.topHotView.frame.contains(point) {
            return true
        }
        if self.bottomHotView.frame.contains(point) {
            return true
        }
        if self.bounds.contains(point) {
            return true
        }
        return false
    }
}

extension FSScheduleEditMaskView {
    ///震动反馈
    func shakeFeedback() {
        feedbackGenerator.impactOccurred()
    }
}
