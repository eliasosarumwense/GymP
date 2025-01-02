//
//  Test3.swift
//  GymP
//
//  Created by Elias Osarumwense on 03.07.24.
//

import SwiftUI

struct Test3: View {

      var body: some View {
                  VStack {
                      HStack (spacing: 1){
                          Image(systemName: "trash.fill")
                              .foregroundColor(.red)
                          Text("Exercise deleted!")
                              .customFont(.bold, 12)
                      }
                      //.offset(x: -30)
                      //.padding(.trailing, 20)
                      //.frame(maxWidth: .infinity)
                      .background(Color.black.opacity(0.8))
                      .cornerRadius(10)
                      .shadow(radius: 10)
                      .transition(.move(edge: .top).combined(with: .opacity))
                      .animation(.easeInOut, value: UUID())
                  }
              }
          }

#Preview {
    Test3()
}
