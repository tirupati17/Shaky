//
//  ContentView.swift
//  ShakyExampleSwiftUI
//
//  Created by Tirupati Balan on 27/03/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingFeedbackForm = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .background(ShakyViewRepresentable(showingFeedbackForm: $showingFeedbackForm, shakeThreshold: 1.0))
        .sheet(isPresented: $showingFeedbackForm) {
            // Present the feedback form view here
        }
    }
}

struct ShakyViewRepresentable: UIViewRepresentable {
    @Binding var showingFeedbackForm: Bool
    var shakeThreshold: Double
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let viewController = UIHostingController(rootView: self)
        viewController.view = view
        
        if let parentViewController = context.coordinator.parentViewController {
            parentViewController.addChild(viewController)
            parentViewController.view.addSubview(view)
            viewController.didMove(toParent: parentViewController)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ShakyDelegate {
        var parent: ShakyViewRepresentable
        let shakeToFeedback: ShakeToFeedback
        
        init(_ parent: ShakyViewRepresentable) {
            self.parent = parent
            self.shakeToFeedback = ShakeToFeedback(shakeThreshold: parent.shakeThreshold)
            super.init()
            shakeToFeedback.delegate = self
            shakeToFeedback.start()
        }
        
        func shakyDidDetectShake() {
            DispatchQueue.main.async {
                self.parent.showingFeedbackForm = true
            }
        }
        
        func shakyDidEndEditing(_ feedback: ShakyFeedback) {
            // Implement this method as required by the ShakyDelegate protocol
        }
        
        var parentViewController: UIViewController? {
            UIApplication.shared.windows.first?.rootViewController
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
