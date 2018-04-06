//
//  ViewController.swift
//  HowManyDays
//
//  Created by BJ Brooks  on 7/15/17.
//  Copyright © 2017 brookswebpro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectionTextField: UITextField!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitPressed(_ sender: Any) {
        //TODAYS DATE
        let todaysDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: todaysDate)
        let yearNow = components.year
        let monthNow = components.month
        let dayNow = components.day
        
        submitButton.alpha = 0
        
        switch month {
            case "January":
                monthNum = 1
            case "February":
                monthNum = 2
            case "March":
                monthNum = 3
            case "April":
                monthNum = 4
            case "May":
                monthNum = 5
            case "June":
                monthNum = 6
            case "July":
                monthNum = 7
            case "August":
                monthNum = 8
            case "September":
                monthNum = 9
            case "October":
                monthNum = 10
            case "November":
                monthNum = 11
            case "December":
                monthNum = 12
            default:
                print ("Error in month processing")
        }
        howManyDays (monthNow: monthNow!, dayNow: dayNow!, yearNow: yearNow!)
    }
    
    @IBAction func startOver(_ sender: Any) {
        resetApp()
        startOverButton.alpha = 0
        selectionTextField.alpha = 1
        dateLabel.text = ""
    }

    var date = ""
    let months = ["January",
                  "February",
                  "March",
                  "April",
                  "May",
                  "June",
                  "July",
                  "August",
                  "September",
                  "October",
                  "November",
                  "December"]
    var days = [Int]()
    var yearView: UIView?
    var month = ""
    var monthNum = 0
    var day = 0
    var year = 0
    var selectedMonth: String?
    var selectedDay: Int?
    var isMonthSubmitted = false
    var isDaySubmitted = false
    
    func addDaysToMonth (numToAdd: Int) {
        for i in 1...numToAdd {
            days.append(29+i)
        }
    }
    
    func createPicker () {
        if (!isMonthSubmitted) {
            let monthPicker = UIPickerView()
            monthPicker.delegate = self
            selectionTextField.inputView = monthPicker
        } else {
            let dayPicker = UIPickerView()
            dayPicker.delegate = self
            selectionTextField.inputView = dayPicker
        }
    }
    
    func createToolbar () {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(ViewController.doneButtonPressed))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        selectionTextField.inputAccessoryView = toolbar
    }
    
    func doneButtonPressed() {
        if (selectionTextField.text != "") {
            view.endEditing(true)
            if (!isMonthSubmitted) {                //submit MONTH
                let testString = String(selectedMonth!)
                if let testString2 = testString {
                    month = testString2
                    switch testString2 {
                        case "January", "March", "May", "July", "August", "October", "December":
                            addDaysToMonth(numToAdd: 2)
                        case "April", "June", "September", "November":
                            addDaysToMonth(numToAdd: 1)
                        default:
                            break
                    }
                    date += testString2
                    dateLabel.text = "You entered: " + date
                }
                isMonthSubmitted = true
                createPicker()
                createToolbar()
                selectionTextField.placeholder = "Click to Select a Day"
            } else if (!isDaySubmitted) {            //MONTH submitted, submit DAY
                let testDay = Int(selectionTextField.text!)
                if let daytry = testDay {
                    day = daytry
                    date += " " + "\(selectedDay!)"
                    dateLabel.text = "You entered: " + date
                    selectionTextField.inputView = yearView
                    selectionTextField.keyboardType = UIKeyboardType.numberPad
                    isDaySubmitted = true
                    selectionTextField.placeholder = "Click to Enter Year"
                }
            } else {                                //MONTH & DAY submitted, submit YEAR
                let testNum = Int(selectionTextField.text!)
                if let yeartry = testNum {
                    year = yeartry
                    if (year <= 1000000) {
                        if (((month == "February" && day == 29) && (((year-2000)%4 != 0) || ((year-2000)%100 == 0) && ((year-2000)%400 != 0)))) {
                            dateLabel.text = "\(year) is not a leap year. Try again..."
                            resetApp()
                        } else {
                            date += ", " + "\(year)"
                            dateLabel.text = "You entered: " + date
                            selectionTextField.alpha = 0
                            submitButton.alpha = 1
                        }
                    } else {
                        dateLabel.text = "Enter a number between 0 and 1,000,000"
                    }
                } else {
                    dateLabel.text = "Enter a number between 0 and 1,000,000"
                }
            }
        } else {
            if (!isMonthSubmitted) {
                dateLabel.text = "Select a month from the list below"
            } else if (!isDaySubmitted) {
                dateLabel.text = "Select a day from the list below"
            } else {
                dateLabel.text = "Enter in a year"
            }
        }
        selectionTextField.text = ""
    }
    
    func howManyDays (monthNow: Int, dayNow: Int, yearNow: Int) {
        var dayIsFuture = false
        var totalDiff = 0
        var leapDays = 0
        var yearDiff = 0
        var monthDiff = 0
        var dayDiff = 0
        var adjustDays = 0
        var adjustMonth = 0
        
        if (year > yearNow) {//YEAR GREATER
            dayIsFuture = true
            yearDiff = year - yearNow - 1
            if (yearDiff >= 2) {
                leapDays = calculateLeapDays (earlyYear: (yearNow + 1), futureYear: (year - 1))
            } else if (yearDiff == 1) {
                if ((yearNow + 1)%4 == 0) {
                    leapDays += 1
                    if ((yearNow + 1) % 100 == 0) && ((yearNow + 1) % 400 != 0) {
                        leapDays -= 1
                    }
                }
            }
            if (monthNum > monthNow) {
                yearDiff += 1
                monthDiff = monthNum - monthNow - 1
                if (day >= dayNow) {
                    monthDiff += 1
                    dayDiff = day - dayNow
                    adjustMonth = monthNow
                    while (adjustMonth < monthNum) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                } else {
                    dayDiff = 30 - dayNow + day
                    dayDiff += adjustDaysOfMonth(month: monthNow, year: yearNow)
                    adjustMonth = monthNow + 1
                    while (adjustMonth < monthNow) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                }
            } else if (monthNum < monthNow) {
                // START BACK HERE
                monthDiff = 12 - monthNow + monthNum - 1
                if (day >= dayNow) {
                    monthDiff += 1
                    dayDiff = day - dayNow
                    adjustMonth = monthNow
                    while (adjustMonth <= 12) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                    adjustMonth = 1
                    while (adjustMonth < monthNum) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                } else {
                    dayDiff = 30 - dayNow + day
                    dayDiff += adjustDaysOfMonth(month: monthNow, year: yearNow)
                    adjustMonth = monthNow + 1
                    while (adjustMonth <= 12) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                    adjustMonth = 1
                    while (adjustMonth < monthNum) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                }
            } else {
                if (day >= dayNow) {
                    monthDiff = 0
                    yearDiff += 1
                    dayDiff = day - dayNow
                } else {
                    monthDiff = 12 - monthNow + monthNum - 1 // monthDiff = 11
                    dayDiff = 30 - dayNow + day
                    dayDiff += adjustDaysOfMonth(month: monthNow, year: yearNow)
                    adjustMonth = monthNow + 1
                    while (adjustMonth <= 12) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                    adjustMonth = 1
                    while (adjustMonth < monthNum) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                }
            }
        } else if (year < yearNow) {
            dayIsFuture = false
            yearDiff = yearNow - year - 1
            if (yearDiff >= 2) {
                leapDays = calculateLeapDays (earlyYear: (year + 1), futureYear: (yearNow - 1))
            } else if (yearDiff == 1){
                if ((year + 1) % 4 == 0){
                    leapDays += 1
                    if ((year + 1) % 100 == 0) && ((year + 1) % 400 != 0) {
                        leapDays -= 1
                    }
                }
            }
            if (monthNow > monthNum) {
                yearDiff += 1
                monthDiff = monthNow - monthNum - 1
                if (dayNow >= day) {
                    monthDiff += 1
                    dayDiff = dayNow - day
                    adjustMonth = monthNum
                    while (adjustMonth < monthNow) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                } else {
                    dayDiff = 30 - day + dayNow
                    dayDiff += adjustDaysOfMonth(month: monthNum, year: year)
                    adjustMonth = monthNum + 1
                    while (adjustMonth < monthNow) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                }
            } else if (monthNow < monthNum) { //YEARNOW GREATER
                monthDiff = 12 - monthNum + monthNow - 1
                if (dayNow >= day) {
                    monthDiff += 1
                    dayDiff = dayNow - day
                    adjustMonth = monthNum /////
                    while (adjustMonth <= 12) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                    adjustMonth = 1
                    while (adjustMonth < monthNow) {
                        adjustDays += adjustDaysOfMonth(month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                } else {
                    dayDiff = 30 - day + dayNow
                    dayDiff += adjustDaysOfMonth(month: monthNum, year: year)
                    adjustMonth = monthNum + 1
                    while (adjustMonth <= 12 ) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                    adjustMonth = 1
                    while (adjustMonth < monthNow) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                }
            } else { //YEAR NOW GREATER, MONTHS EQUAL
                if (dayNow >= day) {
                    monthDiff = 0
                    yearDiff += 1
                    dayDiff = dayNow - day
                } else {
                    monthDiff = 12 - monthNum + monthNow - 1 // monthDiff = 11
                    dayDiff = 30 - day + dayNow
                    dayDiff += adjustDaysOfMonth(month: monthNum, year: year)
                    adjustMonth = monthNum + 1
                    while (adjustMonth <= 12) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                    adjustMonth = 1
                    while (adjustMonth < monthNow) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                }
            }
        } else { //same year
            if (monthNum > monthNow) {
                dayIsFuture = true
                monthDiff = monthNum - monthNow - 1
                if (day >= dayNow) {
                    monthDiff += 1
                    dayDiff = day - dayNow
                    adjustMonth = monthNow
                    while (adjustMonth < monthNum) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                } else {
                    dayDiff = 30 - dayNow + day
                    dayDiff += adjustDaysOfMonth(month: monthNow, year: yearNow)
                    adjustMonth = monthNow + 1
                    while (adjustMonth < monthNum) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: yearNow)
                        adjustMonth += 1
                    }
                }
            } else if (monthNum < monthNow) {
                dayIsFuture = false
                monthDiff = monthNow - monthNum - 1
                if (dayNow >= day) {
                    monthDiff += 1
                    dayDiff = dayNow - day
                    adjustMonth = monthNum
                    while (adjustMonth < monthNow) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                } else {
                    dayDiff = 30 - day + dayNow
                    dayDiff += adjustDaysOfMonth(month: monthNum, year: year)
                    adjustMonth = monthNum + 1
                    while (adjustMonth < monthNow) {
                        adjustDays += adjustDaysOfMonth (month: adjustMonth, year: year)
                        adjustMonth += 1
                    }
                }
            } else { //same year, same month
                if (day > dayNow) {
                    dayIsFuture = true
                    dayDiff = day - dayNow
                } else if (day < dayNow) {
                    dayIsFuture = false
                    dayDiff = dayNow - day
                } else {
                    dayIsFuture = false
                }
            }
        }
        if (dayIsFuture) {
            print ("Day is Future")
        }
        totalDiff = (yearDiff * 365) + (monthDiff * 30) + dayDiff + leapDays + adjustDays
        
        var message = date
        if (dayIsFuture) {
            message += " is "
        } else {
            message += " was "
        }
        print("LeapDays: \(leapDays). AD: \(adjustDays)")
        message += convertToNSString(number: yearDiff) + " year(s), "
        message += "\(monthDiff) month(s), and "
        message += "\(dayDiff) day(s)"
        if (dayIsFuture) {
            message += " from now"
        } else {
            message += " ago"
        }
        message += ", which is a TOTAL of " + convertToNSString(number: totalDiff) + " day(s)"
        dateLabel.text = (message)
        startOverButton.alpha = 1
    }
    
    func convertToNSString (number:Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = ","
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let numberNS = NSNumber(value: number)
        let numberNSString = numberFormatter.string(from: numberNS)
        
        return numberNSString!
    }
    
    func calculateLeapDays (earlyYear: Int, futureYear: Int) -> Int {
        var leapDays = 0
        var counter = 0
        var leapYear = 0
        var extraLeapDays = 0
        
        if ((futureYear - earlyYear) < 4) {
            counter = earlyYear
            while (counter <= futureYear) {
                if (counter % 4 == 0) {
                    leapDays += 1
                    if (counter % 100 == 0) && (counter % 400 != 0) {
                        leapDays -= 1
                    }
                }
                counter += 1
            }
        } else {
            for i in 1...4 {
                if ((earlyYear + i - 1) % 4 == 0) {
                    leapDays += 1
                    if ((earlyYear + i - 1) % 100 == 0) && ((earlyYear + i - 1) % 400 != 0) {
                        leapDays -= 1
                    }
                    leapYear = earlyYear + i - 1
                    print ("Leap Year is \(leapYear)")
                }
            }
            
            leapDays += (futureYear - leapYear) / 4
            extraLeapDays += leapDays/100
            leapDays -= leapDays/25
            leapDays += extraLeapDays
        }
        return leapDays
    }
    
    func getDaysOfMonth (month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            return 28
        default:
            print ("Error processing month!")
            return 0
        }
    }
    
    func addDaysOfMonths (earlyMonth: Int, futureMonth: Int) -> Int {
        var totalDays = 0
        var month1 = earlyMonth
        
        if (month1 < futureMonth) {
            while ((month1 + 1)  < futureMonth) {
                totalDays += getDaysOfMonth (month: month1 + 1)
                month1 += 1
            }
            
        } else if (futureMonth < month1) {
            while ((month1 + 1) <= 12) {
                totalDays += getDaysOfMonth (month: month1 + 1)
                month1 += 1
            }
            month1 = 0
            while ((month1 + 1) <= futureMonth) {
                totalDays += getDaysOfMonth (month: month1 + 1)
                month1 += 1
            }
        }
        return totalDays
    }

    func adjustDaysOfMonth (month: Int, year: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 1
        case 4, 6, 9, 11:
            return 0
        case 2:
            if (year % 4 == 0) {
                return -1
            } else {
                return -2
            }
        default:
            return 0
        }
    }
 
    func resetApp () {
        selectionTextField.placeholder = "Click to Select a Month"
        date = ""
        month = ""
        day = 0
        year = 0
        selectedMonth = ""
        selectedDay = 0
        isMonthSubmitted = false
        isDaySubmitted = false
        
        if days.count > 29 {
            let tempNum = days.count
            for i in 1...(tempNum - 29) {
                days.remove(at: tempNum-i)
            }
        }
        submitButton.alpha = 0
        createPicker()
        createToolbar()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        startOverButton.alpha = 0
        for i in 1...29 {
            days.append(i)
        }
        submitButton.alpha = 0
        createPicker()
        createToolbar()
        
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
         
        startOverButton.layer.cornerRadius = 5
        startOverButton.clipsToBounds = true
        
    }
    
    func numberOfComponents (in pickerView:UIPickerView) -> Int {
        return 1
    }
    
    func pickerView (_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (!isMonthSubmitted) {
            return months.count
        } else {
            return days.count
        }
    }
    
    func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (!isMonthSubmitted) {
            return months[row]
        } else {
            return "\(days[row])"
        }
    }
    
    func pickerView (_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (!isMonthSubmitted) {
            selectedMonth = months[row]
            selectionTextField.text = selectedMonth
        } else {
            selectedDay = days[row]
            selectionTextField.text = "\(selectedDay!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

