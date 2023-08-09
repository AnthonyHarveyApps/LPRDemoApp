//
//  CVSLocation.swift
//  LPRDemoApp
//
//  Created by Anthony Harvey on 8/8/23.
//

import SwiftUI

enum AlertType: String, Codable {
    case amberAlert = "AMBER_ALERT"
    case stolen = "STOLEN"
    case localHotList = "HOT LIST"
    case warrant = "WARRANT"
    
    func color() -> Color {
        switch self {
        case .amberAlert:
            return .yellow
        case .stolen:
            return .red
        case .localHotList:
            return .green
        case .warrant:
            return .blue
        }
    }
    
    func capsuleView(large: Bool = false) -> some View {
        Text(self.rawValue)
            .foregroundColor(.black)
            .font(large ? .callout : .caption)
            .padding(large ? 8: 5)
            .background(Capsule().stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(.black))
            .background(Capsule().foregroundColor(self.color()))
            .minimumScaleFactor(0.75)
    }
}

struct VehicleLocation: Codable, Hashable, Identifiable {
    var id: Int
    var streetNumber: Int
    var streetName: String
    var lat: Double
    var long: Double
    var town: String
    
    var contactNumber: String
    var alertType: AlertType
    var contactAgency: String
    
    var plate: String
    var make: String
    var model: String
    var color: String
    var alertTime: Date
    
    var imageUrls: [String]
    
    func distanceFrom(lat: Double, Long: Double) -> Double {
        let square =  abs(self.lat - lat) * abs(self.lat - lat) + abs(self.long - long) * abs(self.long - long)
        return sqrt(square)
    }
}
