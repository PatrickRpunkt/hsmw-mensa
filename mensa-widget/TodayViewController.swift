//
//  TodayViewController.swift
//  mensa-widget
//
//  Created by Patrick Reichelt on 29/11/14.
//  Copyright (c) 2014 Patrick Reichelt. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding, NCWidgetListViewDelegate, HSMWServiceDelegate {
    
    @IBOutlet var listViewController: NCWidgetListViewController!
    var searchController: NCWidgetSearchViewController?
    var serviceClient = HSMWServiceClient()
    // MARK: - NSViewController

    override var nibName: String? {
        return "TodayViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.serviceClient.delegate = self
        // Set up the widget list view controller.
        // The contents property should contain an object for each row in the list.
    }

    override func dismissViewController(viewController: NSViewController) {
        super.dismissViewController(viewController)

        // The search controller has been dismissed and is no longer needed.
        if viewController == self.searchController {
            self.searchController = nil
        }
    }

    // MARK: - NCWidgetProviding

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Refresh the widget's contents in preparation for a snapshot.
        // Call the completion handler block after the widget's contents have been
        // refreshed. Pass NCUpdateResultNoData to indicate that nothing has changed
        // or NCUpdateResultNewData to indicate that there is new data since the
        // last invocation of this method.
        self.serviceClient.handler = completionHandler
        serviceClient.executeRequest()
    }

    func widgetMarginInsetsForProposedMarginInsets(var defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        // Override the left margin so that the list view is flush with the edge.
        defaultMarginInset.left = 0
        return defaultMarginInset
    }
    

    var widgetAllowsEditing: Bool {
        // Return true to indicate that the widget supports editing of content and
        // that the list view should be allowed to enter an edit mode.
        return false
    }

    func widgetDidBeginEditing() {
        // The user has clicked the edit button.
        // Put the list view into editing mode.
        self.listViewController.editing = false
    }

    func widgetDidEndEditing() {
        // The user has clicked the Done button, begun editing another widget,
        // or the Notification Center has been closed.
        // Take the list view out of editing mode.
        self.listViewController.editing = false
    }

    // MARK: - NCWidgetListViewDelegate

    func widgetList(list: NCWidgetListViewController!, viewControllerForRow row: Int) -> NSViewController! {
        // Return a new view controller subclass for displaying an item of widget
        // content. The NCWidgetListViewController will set the representedObject
        // of this view controller to one of the objects in its contents array.
        var controller =  ListRowViewController()
        controller.representedObject = self.listViewController.contents[row]
        return controller
    }

    func widgetList(list: NCWidgetListViewController!, shouldReorderRow row: Int) -> Bool {
        // Return true to allow the item to be reordered in the list by the user.
        return false
    }

    func widgetList(list: NCWidgetListViewController!, didReorderRow row: Int, toRow newIndex: Int) {
        // The user has reordered an item in the list.
    }

    func widgetList(list: NCWidgetListViewController!, shouldRemoveRow row: Int) -> Bool {
        // Return true to allow the item to be removed from the list by the user.
        return false
    }

    func widgetList(list: NCWidgetListViewController!, didRemoveRow row: Int) {
        // The user has removed an item from the list.
    }

    // MARK: - HSMW Service

    func fetchWeekDataCompleted(week: [DishModel]) {
        self.listViewController.contents = week.first?.menus
    }
}
