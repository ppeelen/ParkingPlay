//
//  CarPlaySceneDelegate.swift
//  ParkingPlay
//
//  Created by Paul Peelen on 2022-04-07.
//

import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    private var interfaceController: CPInterfaceController?

    // CarPlay connected
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
        self.interfaceController = interfaceController

        setInformationTemplate()
    }

    // Information template
    private func setInformationTemplate() {
        let items: [CPInformationItem] = [
            CPInformationItem(title: "Template type", detail: "Information Template (CPInformationTemplate)")
        ]

        let infoTemplate = CPInformationTemplate(title: "CarPlay at CocoaHeads", layout: .leading, items: items, actions: [])
        interfaceController?.setRootTemplate(infoTemplate, animated: true, completion: { success, error in
            debugPrint("Success: \(success)")

            if let error = error {
                debugPrint("Error: \(error)")
            }
        })
    }
}
