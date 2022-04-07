//
//  CarPlaySceneDelegate.swift
//  ParkingPlay
//
//  Created by Paul Peelen on 2022-04-07.
//

import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    private var interfaceController: CPInterfaceController?
    private lazy var fetcher = PlaceFetcher()
    private var places: [Place] = []

    // CarPlay connected
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
        self.interfaceController = interfaceController

        loadContent()
    }

    /// 1. Information template - This will show how to set a template as root view
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

    /// 2. Async loading - Load the content for the CarPlay app and display somehting when done
    private func loadContent() {
        setInformationTemplate(title: "Loading pins...", subTitle: "The pins are being loaded, please wait...")

        Task.init {
            do {
                self.places = try await fetcher.fetchPins()
                setTabScreen()
            } catch {
                setInformationTemplate(title: "Whoops!", subTitle: "Could not load the pins, when safe please check the app on your device.")
            }
        }
    }

    /// Setup the tabbar for CarPlay
    private func setTabScreen() {
        let templates = [
            getPoiTemplate(),
            getListTemplate()
        ]

        setRootTemplate(template: CPTabBarTemplate(templates: templates), animated: true)
    }

    /// Setting the Points Of Interest template with the pins
    /// - Returns: The Points of Interest template with the pins on the map
    private func getPoiTemplate() -> CPPointOfInterestTemplate {
        let pins: [CPPointOfInterest] = places.map { place in
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: place.location))
            let poi = CPPointOfInterest(location: mapItem,
                                     title: place.name,
                                     subtitle: place.subtitle,
                                     summary: place.summary,
                                     detailTitle: place.name,
                                     detailSubtitle: place.subtitle,
                                     detailSummary: place.summary,
                                     pinImage: nil)
            poi.primaryButton = CPTextButton(title: "Details", textStyle: .normal, handler: { [weak self] button in
                self?.setInformationTemplate(title: place.name, subTitle: place.summary, animationType: .push)
            })

            return poi
        }

        let template = CPPointOfInterestTemplate(title: "Pins", pointsOfInterest: pins, selectedIndex: 0)
        template.tabTitle = "Pins"
        template.tabImage = UIImage(systemName: "mappin.square")

        return template
    }

    /// Getting a list template with all the items
    /// - Returns: The list template
    private func getListTemplate() -> CPListTemplate {
        let items: [CPListItem] = places.map { place in
            let item = CPListItem(text: place.name, detailText: place.subtitle, image: nil, accessoryImage: nil, accessoryType: .none)
            item.handler = { [weak self] _, completion in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.setInformationTemplate(title: place.name, subTitle: place.summary, animationType: .push, completion: completion)
                }
            }

            return item
        }
        let section = CPListSection(items: items)

        let template = CPListTemplate(title: "Closest areas", sections: [section])
        template.tabTitle = "List"
        template.tabImage = UIImage(systemName: "list.bullet.rectangle")

        return template
    }

    /// Setting the information template with a title and possible subtitle
    /// - Parameters:
    ///   - title: The title for the page
    ///   - subTitle: The description for the page, optional
    private func setInformationTemplate(title: String, subTitle: String? = nil, animationType: AnimationType = .root, completion: (() -> Void)? = nil) {
        let subItems: [CPInformationItem]

        if let subTitle = subTitle {
            subItems = [CPInformationItem(title: nil, detail: subTitle)]
        } else {
            subItems = []
        }
        let template = CPInformationTemplate(title: title, layout: .leading, items: subItems, actions: [])

        switch animationType {
        case .push:
            pushTemplate(template: template, animated: true, completion: completion)
        case .root:
            setRootTemplate(template: template, animated: true, completion: completion)
        }
    }

    /// Setting the root template
    private func setRootTemplate(template: CPTemplate, animated: Bool, completion: (() -> Void)? = nil) {
        interfaceController?.setRootTemplate(template, animated: true, completion: { success, error in
            debugPrint("Setting root template: \(success ? "With success" : "No success"). Error: \(error?.localizedDescription ?? "none")")
            completion?()
        })
    }

    private func pushTemplate(template: CPTemplate, animated: Bool, completion: (() -> Void)? = nil) {
        interfaceController?.pushTemplate(template, animated: animated, completion: { success, error in
            debugPrint("Pushing template: \(success ? "With success" : "No success"). Error: \(error?.localizedDescription ?? "none")")
            completion?()
        })
    }
}

private enum AnimationType {
    case push
    case root
}
