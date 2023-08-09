//
//  PlateIcon.swift
//  LPRDemoApp
//
//  Created by Anthony Harvey on 8/8/23.
//

import SwiftUI

struct PlateIcon: View {
    var plate: String
    var large: Bool = false
    var body: some View {
        Text(plate)
            .font(large ? .title : .callout)
            .bold()
            .padding(large ? 12 : 4)
            .foregroundColor(.black)
            .background(RoundedRectangle(cornerRadius: large ? 12 : 4).stroke(style: StrokeStyle(lineWidth: large ? 4 : 2)).foregroundColor(.black))
            .background(RoundedRectangle(cornerRadius: large ? 12 : 4).foregroundColor(.white))
    }
}

struct PlateIcon_Previews: PreviewProvider {
    static var previews: some View {
        PlateIcon(plate: "123 678")
    }
}
