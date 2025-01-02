//
//  TrainingDetailedInfoView.swift
//  GymP
//
//  Created by Elias Osarumwense on 17.08.24.
//

import SwiftUI

struct TrainingDetailedInfoView: View {
    var animationNamespace: Namespace.ID // The namespace passed from the previous view for the matched geometry effect

    var body: some View {
        VStack {
            Text("Detailed Description")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .matchedGeometryEffect(id: "heroText2", in: animationNamespace) // Destination for hero animation
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TrainingDetailedInfoView_Previews: PreviewProvider {
    @Namespace static var animationNamespace
    
    static var previews: some View {
        TrainingDetailedInfoView(animationNamespace: animationNamespace)
    }
}

