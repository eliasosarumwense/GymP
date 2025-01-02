//
//  TabBarCircle.swift
//  GymP
//
//  Created by Elias Osarumwense on 09.08.24.
//

import SwiftUI

struct TabBarCircle: View {
    @Binding var show: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: show ? 16 : 40)
            .frame(width: show ? 125 : 50, height: show ? 260 : 50)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(20)
            .onTapGesture {
                withAnimation(.snappy) {
                    show.toggle()
                }
            }
    }
}


