//
//  File.swift
//  VersionCheck
//
//  Created by David on 10/14/25.
//

import Foundation

import SwiftUI

struct AppUpdateView: View {
    var appInfo: VersionCheckManager.ReturnResult
    var forceUpdate: Bool
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack(spacing: 15){
            Image("upgrade")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            
            VStack(spacing:8){
                Text("App Update Available")
                    .font(.title.bold())
                
                Text("There is an app update available from\nversion **\(appInfo.currentVersion)** to version **\(appInfo.availableVersion)**!")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.horizontal,20)
            .padding(.top, 15)
            .padding(.bottom, 5)
            
            VStack(spacing: 8){
                if let appURL = URL(string: appInfo.appURL){
                    Button{
                        openURL(appURL)
                        if !forceUpdate {
                            dismiss()
                        }
                    } label: {
                        Text("Update App")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,4)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
                
                if !forceUpdate {
                    Button{
                        dismiss()
                    } label: {
                        Text("No Thanks!")
                            .fontWeight(.medium)
                            .padding(.vertical,5)
                            .contentShape(.rect)
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .padding(20)
        .padding(.bottom, isiOS26 ? 10 : 0)
        .presentationDetents([.height(450)])
        .interactiveDismissDisabled(forceUpdate)
        .presentationBackground(.background)
        .ignoresSafeArea(.all, edges: isiOS26 ? .all : [])
    }
    
    var isiOS26: Bool {
        if #available(iOS 26, *){
            return true
        }
        return false
    }
}

public extension View {
    func appUpdateSheet(forceUpdate: Bool = false) -> some View {
        modifier(AppUpdateSheetModifier(forceUpdate: forceUpdate))
    }
}

private struct AppUpdateSheetModifier: ViewModifier {
    @State private var updateInfo: VersionCheckManager.ReturnResult?
    var forceUpdate: Bool

    func body(content: Content) -> some View {
        content
            .sheet(item: $updateInfo) {
                AppUpdateView(appInfo: $0, forceUpdate: forceUpdate)
            }
            .task {
                if let result = await VersionCheckManager.shared.checkIfAppUpdateAvailable() {
                    updateInfo = result
                }
            }
    }
}
