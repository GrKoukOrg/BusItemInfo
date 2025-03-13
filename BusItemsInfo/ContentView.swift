//
//  ContentView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 10/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
           NavigationView {
               NavigationLink(destination: ScannerView()) {
                   Text("Go to Scanner")
                       .padding()
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(8)
               }
               .navigationTitle("Home")
           }
       }
}
