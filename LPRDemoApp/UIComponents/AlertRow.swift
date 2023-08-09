//
//  AlertRow.swift
//  LPRDemoApp
//
//  Created by Anthony Harvey on 8/8/23.
//

import SwiftUI

struct AlertRow: View {
    @Binding var vehicleToShow: VehicleLocation?
    var alert: VehicleLocation
    private enum Constants {
        static let placeHolderSymbolName = "car.rear.fill"
        static let plate = "Plate"
        static let location = "Location"
        static let minAgo = "min ago"
        static let moreInfo = "More Info"
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let imageUrl = URL(string: alert.imageUrls.first ?? "") {
                    firstImage(imageUrl: imageUrl)
                }
                Spacer()
                plateAndAlertType
            }
            HStack {
                address
                Spacer()
                moreInfoButton
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.black.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension AlertRow {
    func firstImage(imageUrl: URL) -> some View {
        AsyncImage(url: imageUrl) { image in
            image.resizable()
                .frame(width: screenWidth / 3.5, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        } placeholder: {
            Image(systemName: Constants.placeHolderSymbolName)
                .frame(width: screenWidth / 3.5, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    var address: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Constants.location)
                    .font(.caption)
                Text("\(alert.alertTime.minutesAgo()) \(Constants.minAgo)")
                    .font(.caption)
            }
            Text("\(alert.streetNumber) \(alert.streetName)")
                .bold()
            Text("\(alert.town)")
                .bold()
        }
    }
    
    var moreInfoButton: some View {
        Button {
            vehicleToShow = alert
        } label: {
            Text(Constants.moreInfo)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.black))
        }
    }
    
    var plateAndAlertType: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(Constants.plate)
                .font(.caption)
            PlateIcon(plate: alert.plate)
            alert.alertType.capsuleView()
        }
    }
}

struct AlertRow_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            trimColor.edgesIgnoringSafeArea(.all)
            AlertRow(vehicleToShow: .constant(nil), alert: alertVehicles[3])
                .padding(20)
        }
    }
}
