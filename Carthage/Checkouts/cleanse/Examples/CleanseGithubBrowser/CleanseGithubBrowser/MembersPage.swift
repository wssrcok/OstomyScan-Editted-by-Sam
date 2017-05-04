import Foundation
import UIKit
import Cleanse


/// A module that configures a tab page on the root view controller as well as on the settings page
struct MembersModule : Cleanse.Module {
    static func configure<B : Binder>(binder binder: B) {
        // Make MembersSettingsSplitViewController available for injection
        binder
            .bind()
            .to(factory: MembersViewController.init)

        // Make MembersSettingsSplitViewController available for injection
        binder
            .bind()
            .to(factory: MembersSettingsSplitViewController.init)


        // The settings for our MembersPage is a shared object that we mutate. Make it available as a singleton
        binder
            .bind()
            .asSingleton()
            .to(factory: MembersPageSettings.init)

        // Make the "UseGreenCell" table view cell available
        binder
            .bind()
            .to(factory: UseGreenCell.init)

        // Add "Members" as a tab bar item in our root view controller
        binder
            .bind(RootTabBarItem.self)
            .intoCollection()
            .to { (membersViewController: MembersViewController) -> RootTabBarItem in
                let navController = UINavigationController(rootViewController: membersViewController)
                return RootTabBarItem(viewController: navController, rank: 0)
        }

        // Add "Members Settings" into the settings page for our app
        binder
            .bind(SettingsItem.self)
            .intoCollection()
            .to {
                SettingsItem(
                    title: "Members",
                    viewControllerProvider: ($0 as Provider<MembersSettingsSplitViewController>),
                    rank: 0
                )
        }
    }
}

class MembersViewController : TableViewController {
    let memberService: GithubMembersService

    private var members = [GithubMember]()

    private var settings: MembersPageSettings

    init(
        memberService: GithubMembersService,
        githubOrganizationName: TaggedProvider<GithubOrganizationName>,
        settings: MembersPageSettings
    ) {
        self.memberService = memberService
        self.settings = settings

        super.init()

        self.title = "Members"
        self.navigationItem.title = "Members of \(githubOrganizationName.get())"

        self.tabBarItem.image = UIImage(
            named: "TabBarIcons/Members",
            inBundle: NSBundle(forClass: self.dynamicType),
            compatibleWithTraitCollection: nil
        )
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") ?? UITableViewCell(style: .Default, reuseIdentifier: "Cell")

        let member = members[indexPath.row]

        cell.textLabel?.text = member.login

        let textColor = settings.useGreen ? UIColor.greenColor() : .blackColor()
        cell.textLabel?.textColor = textColor

        cell.selectionStyle = .None
        
        return cell
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    func refresh() {
        memberService.list { [weak self] result in
            guard let `self` = self else {
                return
            }

            do {
                self.members = try result.get()
                self.tableView.reloadData()
            } catch let e  {
                NSLog("We got an error \(e) fetching Member. Doing nothing")
                return
            }
        }
    }
}

/// This is a singleton that controls how the members page is displayed
class MembersPageSettings {
    // If true, we will make the text green
    var useGreen = false
}

/// View controller that is used in the settings page
class MembersSettingsSplitViewController : TableViewController {
    private let cells: [UITableViewCell]

    init(useGreenCell: UseGreenCell) {

        self.cells = [useGreenCell]

        super.init()

        self.title = "Members Settings"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}

/// Cell that has a switch that toggles whether or not "useGreen" should be enabled
class UseGreenCell : UITableViewCell {
    let `switch` = UISwitch()
    let settings: MembersPageSettings

    init(settings: MembersPageSettings) {
        self.settings = settings

        super.init(style: .Default, reuseIdentifier: nil)

        `switch`.on = settings.useGreen

        `switch`.addTarget(self, action: #selector(valueChanged), forControlEvents: .TouchUpInside)

        textLabel?.text = "Use Green Cell Text"
        accessoryView = `switch`
        selectionStyle = .None
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func valueChanged() {
        self.settings.useGreen = `switch`.on
    }
}
