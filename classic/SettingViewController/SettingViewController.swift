//
//  SettingViewController.swift
//  classic
//
//  Created by kaichan on 2018/05/19.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    var TableTitle = [["Account", "Account"],
                      ["Schedule", "Schedule Edit", "Schedule Share"]
    ]
    var TableSubtitle = [["", ""],
                         ["", "", ""]
    ]
    var TableAccessVC = [["LogInViewController"],
                         ["SetScheduleViewController", "ShareScheduleViewController"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // メールアドレスをロード
        let keychain = Keychain(service: config.KeychainService)
        do {
            let mail = try keychain.get("mail") ?? ""
            TableSubtitle[0][1] = mail
        } catch {
            NSLog("メールアドレスのロードに失敗")
        }
        
        settingTableView.delegate   = self
        settingTableView.dataSource = self
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableTitle[section].count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        cell.textLabel?.text = TableTitle[indexPath.section][indexPath.row + 1]
        cell.detailTextLabel?.text = TableSubtitle[indexPath.section][indexPath.row + 1]
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator // 「>」ボタンを設定
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableTitle[section][0]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        present(to: TableAccessVC[indexPath.section][indexPath.row])
    }
    
    private func present(to identifier: String) {
        let story = UIStoryboard(name: identifier, bundle: nil)
        let next = story.instantiateViewController(withIdentifier: identifier)
        self.present(next, animated: true, completion: nil)
    }
}
