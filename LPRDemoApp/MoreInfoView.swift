//
//  MoreInfoView.swift
//  LPRDemoApp
//
//  Created by Anthony Harvey on 8/8/23.
//

import SwiftUI
import MapKit

struct MoreInfoView: View {
    let vehicleLocation: VehicleLocation
    @Environment(\.presentationMode) var presentationMode
    private enum Constants {
        static let placeHolderSymbolName = "car.rear.fill"
        static let exitButtonSymbolName = "xmark.circle.fill"
        static let mapButtonSymbolName = "map"
        static let location = "Location"
        static let minAgo = "min ago"
        static let go = "Go"
        static let contact = "Contact"
    }
    @State private var imageUrlToShow: URL? = nil
    var body: some View {
        ZStack {
            trimColor.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 10) {
                alertTypeAndExit
                plateAndDescription
                Spacer()
                locationAndGoButton
                Spacer()
                imageScroller
                Spacer()
                contact
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            if let imageUrlToShow {
                fullScreenImage(imageUrl: imageUrlToShow)
            }
        }
    }
    
    func startPhoneCall(phoneNumber: String) {
        let phone = "tel://"
        let phoneNumberformatted = phone + phoneNumber
        guard let url = URL(string: phoneNumberformatted) else { return }
        UIApplication.shared.open(url)
    }
}

extension MoreInfoView {
    func fullScreenImage(imageUrl: URL) -> some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: screenWidth, height: screenHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } placeholder: {
                Image(systemName: Constants.placeHolderSymbolName)
                    .scaledToFit()
                    .frame(width: screenWidth, height: screenHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .onTapGesture {
            imageUrlToShow = nil
        }
    }
    
    var contact: some View {
        HStack {
            Text(Constants.contact)
            Text(vehicleLocation.contactAgency)
            Spacer()
            Text(vehicleLocation.contactNumber).foregroundColor(.blue)
                .onTapGesture {
                    startPhoneCall(phoneNumber: vehicleLocation.contactNumber)
                }
        }
    }
    
    var alertTypeAndExit: some View {
        HStack {
            vehicleLocation.alertType.capsuleView(large: true)
            Spacer()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: Constants.exitButtonSymbolName)
                    .font(.title)
                    .foregroundColor(.gray)
            })
        }
    }
    
    var plateAndDescription: some View {
        HStack {
            PlateIcon(plate: vehicleLocation.plate, large: true)
            Spacer()
            VStack(alignment: .leading) {
                Text(vehicleLocation.color)
                HStack {
                    Text(vehicleLocation.make)
                    Text(vehicleLocation.model)
                }
            }.bold()
        }
    }
    
    var imageScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vehicleLocation.imageUrls, id: \.self) { imageURL in
                    if let imageUrl = URL(string: imageURL) {
                        AsyncImage(url: imageUrl) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: screenWidth / 2.3, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        } placeholder: {
                            Image(systemName: Constants.placeHolderSymbolName)
                                .scaledToFill()
                                .frame(width: screenWidth / 2.5, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .onTapGesture {
                            imageUrlToShow = imageUrl
                        }
                    }
                }
            }
        }
    }
    
    
    var locationAndGoButton: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(Constants.location)
                        .font(.caption)
                    Text("\(vehicleLocation.alertTime.minutesAgo()) \(Constants.minAgo)")
                        .font(.caption)
                }
                Text("\(vehicleLocation.streetNumber) \(vehicleLocation.streetName)")
                    .bold()
                Text("\(vehicleLocation.town)")
                    .bold()
                
            }
            Spacer()
            Button(action: {
                var mapItem: MKMapItem
                mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: vehicleLocation.lat, longitude: vehicleLocation.long)))
                mapItem.name = vehicleLocation.plate
                
                MKMapItem.openMaps(with: [mapItem], launchOptions: [:])
            }, label: {
                VStack {
                    Image(systemName: Constants.mapButtonSymbolName)
                    Text(Constants.go)
                }
                .foregroundColor(.black)
                .padding()
                .background(RoundedRectangle(cornerRadius: 14).foregroundColor(.white.opacity(0.9)))
            })
        }
    }
}

struct MoreInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoView(vehicleLocation: alertVehicles.first!)
    }
}
