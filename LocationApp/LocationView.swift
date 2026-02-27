//
//  LocationView.swift
//  LocationApp
//
//  Created by Ari Everett on 2/23/26.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @State var location: Location
    
    var body: some View {
        Text(location.name)
        Text(location.coordinate.latitude.formatted())
        Map(position: $location.position)
    }
}

#Preview {
    LocationView(location: .example())
}
