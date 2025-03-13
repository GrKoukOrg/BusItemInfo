//
//  ScannerView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 13/3/25.
//

// ScannerView.swift
// ScannerView.swift
// ScannerView.swift
import SwiftUI
import VisionKit

struct ScannerView: View {
    @EnvironmentObject var vm: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", .fullStreetAddress)
    ]
    
    @State private var recognizedItems: [RecognizedItem] = []
    
    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        case .cameraNotAvailable:
            Text("Your device doesn't have a camera")
        case .scannerNotAvailable:
            Text("Your device doesn't have support for scanning")
        case .cameraAccessNotGranted:
            Text("Please provide camera access in settings")
        case .notDetermined:
            Text("Requesting camera access")
        }
    }
    
    private var mainView: some View {
        ZStack {
            DataScannerView(
                recognizedItems: Binding(
                    get: { recognizedItems },
                    set: { newItems in
                        recognizedItems = newItems
                        if let item = newItems.first {
                            vm.scannedResult = item.payloadStringValue ?? item.transcript
                            dismiss()
                        }
                    }
                ),
                recognizedDataType: vm.recognizedDataType
            )
            .background { Color.gray.opacity(0.3) }
            .ignoresSafeArea()
            .id(vm.dataScannerViewId)
            
            VStack {
                Spacer()
                bottomContainerView
                    .background(.ultraThinMaterial)
                    .frame(height: UIScreen.main.bounds.height * 0.25)
            }
        }
        .onChange(of: vm.scanType) { // Updated syntax
                    vm.scannedResult = nil
                    recognizedItems = []
                }
                .onChange(of: vm.textContentType) { // Updated syntax
                    vm.scannedResult = nil
                    recognizedItems = []
                }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }
                .pickerStyle(.segmented)
            }
            .padding(.top)
            
            if vm.scanType == .text {
                Picker("Text content type", selection: $vm.textContentType) {
                    ForEach(textContentTypes, id: \.self.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Text(vm.headerText).padding(.top)
        }
        .padding(.horizontal)
    }
    
    private var bottomContainerView: some View {
        VStack {
            headerView
            if let result = vm.scannedResult {
                Text(result)
                    .padding()
            }
        }
    }
}

extension RecognizedItem {
    var payloadStringValue: String? {
        if case .barcode(let barcode) = self {
            return barcode.payloadStringValue
        }
        return nil
    }
    
    var transcript: String {
        if case .text(let text) = self {
            return text.transcript
        }
        return ""
    }
}
