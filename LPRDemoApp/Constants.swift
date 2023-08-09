//
//  Constants.swift
//  LPRDemoApp
//
//  Created by Anthony Harvey on 8/8/23.
//

import SwiftUI

var alertVehicles = [  // <-- Dummy Data
    VehicleLocation(id: 1, streetNumber: 633, streetName: "Amherst Street", lat: 42.8039879, long: -71.5410741, town: "Nashua", contactNumber: "603-888-8888", alertType: .amberAlert, contactAgency: "NH DOS", plate: "JJE 908", make: "Acura", model: "Integra", color: "white", alertTime: Date(timeIntervalSinceNow: -300), imageUrls: ["https://images.pexels.com/photos/9661493/pexels-photo-9661493.jpeg?auto=compress&cs=tinysrgb&w=1600", "https://images.pexels.com/photos/88630/pexels-photo-88630.jpeg?auto=compress&cs=tinysrgb&w=1600", "https://images.pexels.com/photos/88628/pexels-photo-88628.jpeg?auto=compress&cs=tinysrgb&w=1600"]),
    
    VehicleLocation(id: 2, streetNumber: 456, streetName: "Daniel Webster Hwy", lat: 42.8637490, long: -71.4939293, town: "Merrimack", contactNumber: "603-777-7777", alertType: .stolen, contactAgency: "FBI", plate: "EDL-770", make: "Nissan", model: "350z", color: "orange", alertTime: Date(timeIntervalSinceNow: -1200), imageUrls: ["https://images.pexels.com/photos/13627430/pexels-photo-13627430.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", "https://images.pexels.com/photos/13627467/pexels-photo-13627467.jpeg?auto=compress&cs=tinysrgb&w=1600", "https://images.pexels.com/photos/13627458/pexels-photo-13627458.jpeg?auto=compress&cs=tinysrgb&w=1600"]),
    
    VehicleLocation(id: 3, streetNumber: 242, streetName: "Main Street", lat: 42.7577094, long: -71.4633427, town: "Nashua", contactNumber: "619-444-4444", alertType: .localHotList, contactAgency: "San Diego Police", plate: "5RF-OPL", make: "BMW", model: "5 Series", color: "black", alertTime: Date(timeIntervalSinceNow: -1700), imageUrls: ["https://images.pexels.com/photos/13627421/pexels-photo-13627421.jpeg?auto=compress&cs=tinysrgb&w=1600", "https://images.pexels.com/photos/8192682/pexels-photo-8192682.jpeg?auto=compress&cs=tinysrgb&w=1600"]),
    
    VehicleLocation(id: 4, streetNumber: 46, streetName: "Morgan Road", lat: 42.7794043, long: -71.4447919, town: "Hudson", contactNumber: "619-444-4444", alertType: .warrant, contactAgency: "San Diego Police", plate: "8AWW822", make: "Dodge", model: "Charger", color: "white", alertTime: Date(timeIntervalSinceNow: -1800), imageUrls: ["https://images.pexels.com/photos/12186465/pexels-photo-12186465.jpeg?auto=compress&cs=tinysrgb&w=1600", "https://images.pexels.com/photos/12101050/pexels-photo-12101050.jpeg?auto=compress&cs=tinysrgb&w=1600"])
]

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenSize = UIScreen.main.bounds.size


let appName = "LPR Example App"
let trimColor = Color("TrimColor")

let CENTER_LAT = 42.7595788
let CENTER_LONG = -71.4919089

extension UIScreen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}

extension Int: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return self
    }
}

extension Date {
    func minutesAgo() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute], from: self, to: now)
        return components.minute ?? 0
    }
}

extension View {
    func glow(color: Color = .red.opacity(0.5), radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
}
