//
//  PageTitleView.swift
//  DYZB
//
//  Created by shizhi on 17/2/23.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

// MARK:- 定义协议
protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView : PageTitleView, selectedIndex: Int)
}

// MARK:- 定义常量
let kButtomLineH: CGFloat = 2.0
private let kSelectedColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)

class PageTitleView: UIView {
   weak var delegate: PageTitleViewDelegate?
   private var currentIndex: Int = 0
   private var titles: [String]
   private lazy var titleLabels: [UILabel] = [UILabel]()
   private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orangeColor()
        return scrollLine
    }()
    
     // MARK:- 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Mark: UI设置
extension PageTitleView {
    private func setUpUI() {
        addSubview(scrollView)
//      scrollView.frame = bounds
        
        setUpLables()
        setUpBottomLines()
    }
    
    private func setUpLables() {
        
                // 0.确定label的一些frame的值
            let labelW : CGFloat = frame.width / CGFloat(titles.count)
            let labelH : CGFloat = frame.height - kButtomLineH
            let labelY : CGFloat = 0
            
            for (index, title) in titles.enumerate() {
                // 1.创建UILabel
                let label = UILabel()
                
                // 2.设置Label的属性
                label.text = title
                label.tag = index
                label.font = UIFont.systemFontOfSize(16.0)
                label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
                label.textAlignment = .Center
                
                // 3.设置label的frame
                let labelX : CGFloat = labelW * CGFloat(index)
                label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
                
                // 4.将label添加到scrollView中
                scrollView.addSubview(label)
                titleLabels.append(label)
                
                // 5.给Label添加手势
                label.userInteractionEnabled = true
                let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
                label.addGestureRecognizer(tapGes)
            }
            
            
        

    }
    
    private func setUpBottomLines() {
        
        //1添加bottomlines
        let bottomlines = UIView()
        bottomlines.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
        bottomlines.backgroundColor = UIColor.lightGrayColor()
        addSubview(bottomlines)
        
        // 2添加scrollLine
        // 获取第一个titlelabel
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
            
        
        //设置scrollline的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kButtomLineH, width: firstLabel.frame.width, height: firstLabel.frame.height)
        
    }
    
        
    }


// MARK:- 监听Label的点击
extension PageTitleView {
    
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        
        //获取当前label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        //如果是重复点击同一label
        if currentLabel.tag == currentIndex { return }
        
        //获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        //改变颜色
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        
        //滑块动画
        
        UIView.animateWithDuration(0.15) {
            self.scrollLine.frame.origin.x = self.scrollLine.frame.width * CGFloat(currentLabel.tag)
        }
        
        
        // 4.保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        // 5.通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
  }
}

// MARK:- 对外暴露的方法
extension PageTitleView {
    func changeLabel(progress: CGFloat) {
        
        var sourceLabelIndex = Int(floor(progress))
        let ratio = progress - CGFloat(sourceLabelIndex)
        
        //获取sourceLabel和targetLabel
        let sourceLabel = titleLabels[sourceLabelIndex]
        
        if sourceLabelIndex >= 3{
            sourceLabelIndex = 3
        }
        
        print("sourceLabelIndex = \(sourceLabelIndex)")
        var targetIndex = sourceLabelIndex + 1
        if targetIndex >= 3{
            targetIndex = 3
        }
        print("targetIndex = \(targetIndex)")
        let targetLabel = titleLabels[targetIndex]
        
        //滑块的逻辑
        let moveTotalX = sourceLabel.frame.width
        let moveX = moveTotalX * ratio
        
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3.Label颜色的渐变
        // 3.1.取出变化的范围
        let colorDelta = (kSelectedColor.0 - kNormalColor.0, kSelectedColor.1 - kNormalColor.1, kSelectedColor.2 - kNormalColor.2)
        
        if sourceLabelIndex != targetIndex {
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * ratio, g: kSelectedColor.1 - colorDelta.1 * ratio, b: kSelectedColor.2 - colorDelta.2 * ratio)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * ratio, g: kNormalColor.1 + colorDelta.1 * ratio, b: kNormalColor.2 + colorDelta.2 * ratio)
        }
        
        // 4.记录最新的index
        currentIndex = sourceLabelIndex
    }
}



