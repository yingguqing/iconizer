//
//  SBBox.swift
//  CocoaPodsAssistant
//
//  Created by sycf_ios on 2017/3/22.
//  Copyright © 2017年 shibiao. All rights reserved.
//

import Cocoa
// SBBox代理
protocol SBBoxDelegate: NSObjectProtocol {
    /// 获取拖拽进box里文件的文件夹路径和文件名
    ///
    /// - Parameters:
    ///   - path: 文件夹路径
    ///   - name: 文件名
    func sbBoxGetFile(for paths: [String])
}

class SBBox: NSBox {
    private static var defaultFileExtension = [String]()
    private static var defaultMaxFileNum = 999
    open weak var delegate: SBBoxDelegate?
    var fileExtension: [String]?
    var maxFileNum: Int? // 同时拖进的文件数
    var _finishDo: (([String]) -> Void)?
    var finishDo: (([String]) -> Void)? {
        get {
            return _finishDo
        }
        set {
            _finishDo = newValue
            reRegisert()
        }
    }
    
    required override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.layer?.backgroundColor = .clear
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.layer?.backgroundColor = .clear
    }
    
    /// 设置全局默认文件后缀和最大拖入文件数
    ///
    /// - Parameters:
    ///   - fileExtension: 文件后缀
    ///   - maxFileNum: 最大文件数
    static func setDefault(fileExtension: [String], maxFileNum: Int? = nil) {
        defaultFileExtension = fileExtension
        if let maxFileNum = maxFileNum {
            defaultMaxFileNum = maxFileNum
        }
    }
    
    /// 重新注册文件后缀和最大文件数
    func reRegisert() {
        if fileExtension == nil {
            fileExtension = SBBox.defaultFileExtension
        }
        if maxFileNum == nil || maxFileNum! <= 0 {
            maxFileNum = SBBox.defaultMaxFileNum
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // 注册所有文件类型
        registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: String(kUTTypeFileURL))])
    }
    
    // MARK: drag文件进入
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.copy
    }
    
    // MARK: drag文件的操作
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let pboardArray = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? Array<String> {
            let filePaths = filterFormatBy(array: pboardArray, fileExtension: fileExtension ?? SBBox.defaultFileExtension)
            let count = filePaths.count
            if count > 0, count <= (maxFileNum ?? SBBox.defaultMaxFileNum) {
                DispatchQueue.global().async { [unowned self] in // 启异步线程是为了防止卡死
                    if let delegate = self.delegate {
                        delegate.sbBoxGetFile(for: filePaths)
                    } else if let todo = self.finishDo {
                        todo(filePaths)
                    }
                }
            }
        }
        return true
    }
    
    /**
     过滤拖拽文件进box的路径
     
     @param array 拖拽进的文件路径（可能同时拖拽多个文件）
     @return 返回文件所在文件夹路径
     */
    func filterFormatBy(array: Array<String>, fileExtension: [String]) -> [String] {
        var paths: [String] = [String]()
        for path in array {
            let pathExtension = path.pathExtension
            if fileExtension.count == 0 || fileExtension.contains(pathExtension) {
                paths.append(path)
            }
        }
        return paths
    }
}
