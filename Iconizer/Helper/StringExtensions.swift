//
// StringExtensions.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

extension String {

    /// The substring containing the characters between the supplied start and
    /// the supplied end strings. Excluding both.
    ///
    /// - Parameters:
    ///   - start: The starting point.
    ///   - end: The ending point.
    /// - Returns: The substring from the start to the end string or nil when either string weren't found.
    func substringFrom(start: String, to end: String) -> String? {
        // Return nil in case either the given start or end string doesn't exist.
        guard let startIndex = self.range(of: start), let endIndex = self.range(of: end) else {
            return nil
        }

        return String(self[startIndex.upperBound ..< endIndex.lowerBound])
    }
}


extension String {
    // MARK: 删除后缀的文件名
    
    /// 删除后缀的文件名
    var fileNameWithoutExtension: String {
        return ((self as NSString).lastPathComponent as NSString).deletingPathExtension
    }
    
    // MARK: 获得文件的扩展类型（不带'.'）
    
    /// 获得文件的扩展类型（不带'.'）
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    // MARK: 从路径中获得完整的文件名（带后缀）
    
    /// 从路径中获得完整的文件名（带后缀）
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    // MARK: 删除最后一个/后面的内容
    
    /// 删除最后一个/后面的内容 可以是整个文件名,可以是文件夹名
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    // MARK: 获得文件名（不带后缀）
    
    /// 获得文件名（不带后缀）
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    // MARK: 文件是否存在
    
    /// 文件是否存在
    var fileIsExists: Bool {
        if self.isEmpty == false {
            return FileManager.default.fileExists(atPath: self)
        }
        return false
    }
    
    /// 目录是否存在，非目录时，返回false
    var directoryIsExists: Bool {
        guard self.isEmpty == false else {
            return false
        }
        var isDirectory = ObjCBool(booleanLiteral: false)
        let isExists = FileManager.default.fileExists(atPath: self, isDirectory: &isDirectory)
        return isDirectory.boolValue && isExists
    }
    
    // MARK: 生成目录所有文件
    
    func filePathCreate() {
        if self.isEmpty == false,
            self.fileIsExists == false {
            do {
                try FileManager.default.createDirectory(atPath: self, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                debugPrint("创建目录失败 \(error.localizedDescription)")
            }
        }
    }
    
    func fileRemove() {
        guard self.isEmpty == false else {
            return
        }
        if self.fileIsExists || self.directoryIsExists {
            do {
                try FileManager.default.removeItem(atPath: self)
            } catch let error as NSError {
                debugPrint("文件删除失败 \(error.localizedDescription)")
            }
        }
    }
}
