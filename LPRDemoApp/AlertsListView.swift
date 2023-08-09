//
//  AlertsListView.swift
//  LPRDemoApp
//
//  Created by Anthony Harvey on 8/8/23.
//

import SwiftUI
import MapKit

struct AlertsListView: View {
    @StateObject var locationManager = LocationManager()
    @State private var showLocationUnavailable: Bool = false
    @State private var selectedID = 1
    @State private var searchTextForMap: String = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CENTER_LAT, longitude: CENTER_LONG), span: MKCoordinateSpan(latitudeDelta: 0.14, longitudeDelta: 0.14))
    @State private var vehicleToShow: VehicleLocation? = nil
    
    private enum Constants {
        static let centerButtonSymbolName = "record.circle.fill"
        static let zoomInButtonSymbolName = "plus.circle"
        static let zoomOutButtonSymbolName = "minus.circle"
        static let alertsInArea = "alerts in area"
        static let moreInfo = "More Info"
    }
    
    var body: some View {
        ZStack {
            trimColor.edgesIgnoringSafeArea(.all)
            VStack {
                appNameText
                    .frame(height: 40)
                ZStack {
                    map
                    mapButtonOverlay
                }.frame(height: UIScreen.height * 0.28)
                ScrollView(showsIndicators: false) {
                    alertList
                }
            }
        }
        .onAppear {
            locationManager.requestAuth()
            locationManager.startUpdatingLocation()
            getLocationForMap()
        }
        .fullScreenCover(item: $vehicleToShow) { vehicleToShow in
            MoreInfoView(vehicleLocation: vehicleToShow)
        }
    }
    
    func getLocationForMap() {
        locationManager.requestAuth()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            DispatchQueue.main.async {
                region.center.longitude = locationManager.location?.longitude ?? CENTER_LONG
                region.center.latitude = locationManager.location?.latitude ?? CENTER_LAT
            }
        } else {
            showLocationUnavailable = true
        }
    }
}

extension AlertsListView {
    var appNameText: some View {
        Text(appName.uppercased())
            .foregroundColor(.white)
            .bold()
            .padding()
    }
    
    var mapButtonOverlay: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button {
                    withAnimation {
                        region.center.longitude = locationManager.location?.longitude ?? CENTER_LONG
                        region.center.latitude = locationManager.location?.latitude ?? CENTER_LAT
                    }
                } label: {
                    Image(systemName: Constants.centerButtonSymbolName)
                }
                Spacer()
                Button {
                    withAnimation {
                        region.span.latitudeDelta -= 0.08
                        region.span.longitudeDelta -= 0.08
                    }
                } label: {
                    Image(systemName: Constants.zoomInButtonSymbolName)
                }
                Spacer()
                Button {
                    withAnimation {
                        region.span.latitudeDelta += 0.08
                        region.span.longitudeDelta += 0.08
                    }
                } label: {
                    Image(systemName: Constants.zoomOutButtonSymbolName)
                }
                Spacer()
            }
            .font(.system(size: 40))
            .foregroundColor(.white)
            .padding(.trailing)
        }
    }
    
    var alertCountText: some View {
        Text("\(alertVehicles.count) \(Constants.alertsInArea)")
            .foregroundColor(.white)
            .font(.callout)
            .padding(.leading)
    }
    
    var map: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none, annotationItems: alertVehicles.indices) { spotIndex in
            MapAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: alertVehicles[spotIndex].lat, longitude: alertVehicles[spotIndex].long),
                content: {
                    if selectedID == spotIndex + 1 {
                        PlateIcon(plate: alertVehicles[spotIndex].plate)
                            .glow()
                    } else {
                        PlateIcon(plate: alertVehicles[spotIndex].plate)
                            .onTapGesture {
                                selectedID = spotIndex + 1
                                withAnimation {
                                    region.center = CLLocationCoordinate2D(latitude: alertVehicles[spotIndex].lat, longitude: alertVehicles[spotIndex].long)
                                }
                            }
                    }
                }
            )
        }
        .colorScheme(.dark)
    }
    
    var alertList: some View {
        VStack(alignment: .center) {
            alertCountText
            ForEach(alertVehicles.indices) { spotIndex in
                AlertRow(vehicleToShow: $vehicleToShow, alert: alertVehicles[spotIndex])
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 3).foregroundColor(selectedID == spotIndex + 1 ? .red : .white.opacity(0.5)))
                    .frame(width: screenWidth - 40)
                    .onTapGesture {
                        selectedID = spotIndex + 1
                        withAnimation {
                            region.center = CLLocationCoordinate2D(latitude: alertVehicles[spotIndex].lat, longitude: alertVehicles[spotIndex].long)
                        }
                    }
            }.onChange(of: locationManager.locationUpdates, perform: { newValue in
                alertVehicles.sort {
                    $0.distanceFrom(lat: locationManager.location?.latitude ?? CENTER_LAT, Long: locationManager.location?.longitude ?? CENTER_LONG) < $1.distanceFrom(lat: locationManager.location?.latitude ?? CENTER_LAT, Long: locationManager.location?.longitude ?? CENTER_LONG)
                }
            })
        }
    }
}

struct AlertsListView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsListView()
    }
}
