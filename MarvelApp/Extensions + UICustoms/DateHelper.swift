//
//  DateHelper.swift
//  SupportI

import Foundation

class DateHelper {
    /** Wednesday, May 30, 2018
     EEEE, MMM d, yyyy
     05/30/2018
     MM/dd/yyyy
     05-30-2018 12:14
     MM-dd-yyyy HH:mm
     May 30, 12:14 PM
     MMM d, h:mm a
     May 2018
     MMMM yyyy
     May 30, 2018
     MMM d, yyyy
     Wed, 30 May 2018 12:14:27 +0000
     E, d MMM yyyy HH:mm:ss Z
     2018-05-30T12:14:27+0000
     yyyy-MM-dd'T'HH:mm:ssZ
     30.05.18
     dd.MM.yy
     **/
    enum DateType: String {
        case hourly = "hh"
        case hourly24 = "HH"
        case hourlyM = "hh:mm"
        case hourly24M = "HH:mm"
        case year = "yyyy"
        case full = "yyyy-MM-dd HH:mm:ss"
        case monthString = "MMM"
        case month = "MM"
        case day = "dd"
        //case withZone = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
    }
    enum DateLocale: String {
        case english = "en_US_POSIX"
        case arabic = "ar_EG"
    }
    static var currentLocal: DateLocale?
    static var locale: String {
        get {
            if currentLocal != nil {
                return currentLocal?.rawValue ?? DateLocale.english.rawValue
            } else {
                return DateLocale.english.rawValue
            }
        }
    }
    
    
    func currentFullFormat() -> String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateOrginial = dateFormatter.string(from: date)
        return dateOrginial
    }
    func currentDateFullFormat() -> Date? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateOrginial = dateFormatter.date(from: "2023-04-05")
        return dateOrginial
    }
    func currentDate() -> String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateOrginial = dateFormatter.string(from: date)
        return dateOrginial
    }
    static func getDateFromTimestamp(unixtimeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "ar_DZ")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm a"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    /// start with date yyyy-mm-dd hh:mm:ii
    ///
    /// - Parameter original: string date
    /// - Returns: return Date Object
    func originalDate(original: String, oldFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = oldFormat
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600 * 2)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        //dateFormatter.locale = Locale(identifier: locale()) // set locale to reliable US_POSIX
        let dateOrginial = dateFormatter.date(from: original)
        return dateOrginial
    }
    func locale() -> String {
        return DateHelper.locale
    }
    func date(date: String?, format: String, oldFormat: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        let removedDate = removeDots(date: date)
        guard let dateUse = removedDate else { return nil }
        let dateD = originalDate(original: dateUse, oldFormat: oldFormat)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600 * 2)
        dateFormatter.locale = Locale(identifier: locale()) // set locale to reliable US_POSIX
        if dateD != nil {
            let dateString = dateFormatter.string(from: dateD!)
            return dateString
        } else {
            return nil
        }
    }
    private func removeDots(date: String?) -> String? {
        guard var date = date else {
            return nil
        }
        date = date.components(separatedBy: ".").first ?? ""
//        date = date.cut(charSplit: "T", charWith: " ")
        return date
    }
    
    func dateFormate(date: String?, format: String, oldFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        guard let dateUse = date else {return nil}
        //let dateD = originalDate(original: dateUse, oldFormat: oldFormat)
        let dateStringFormate = self.date(date: dateUse, format: format, oldFormat: oldFormat)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600 * 2)
        dateFormatter.locale = Locale(identifier: locale()) // set locale to reliable US_POSIX
        if dateStringFormate != nil {
            let dateString = dateFormatter.date(from: dateStringFormate!)
            return dateString
        } else {
            return nil
        }
    }
    func date(date: Date?, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600 * 2)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
 // set locale to reliable US_POSIX
        if date != nil {
            let dateString = dateFormatter.string(from: date!)
            return dateString
        } else {
            return nil
        }
    }
    func convertToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func convertToHoursMinutesSeconds (firstTimeStamp: Int, secondTimeStamp: Int) -> (Int, Int, Int) {
        let seconds = firstTimeStamp - secondTimeStamp
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
