//
//  AppointmentsViewController.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 23/05/21.
//

import UIKit

class AppointmentsViewController: UIViewController{
    
    private static let CELL_IDENTIFIER = "appointmentCell"
    
    var slots: Slots?
    var filter: AppointmnetFilter?
    private var filteredCenters: [Center] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filteredCenters = AppointmentProcessor.processSlots(slots: slots, filter: filter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.isHidden = self.filteredCenters.isEmpty
    }
    
}

extension AppointmentsViewController: UITableViewDelegate{
    
}

extension AppointmentsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCenters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentsViewController.CELL_IDENTIFIER)!
        
        let center =  filteredCenters[indexPath.row]
        
        (cell.viewWithTag(100) as! UILabel).text = center.name ?? "NA"
        
        (cell.viewWithTag(101) as! UILabel).text = center.address ?? "NA"
        
        (cell.viewWithTag(102) as! UILabel).text = String(center.sessions?.count ?? 0)
        
        if let vaccines = center.sessions?.map({$0.vaccine ?? ""}){
            (cell.viewWithTag(103) as! UILabel).text = Set(vaccines).joined(separator: ",")
        }
        else{
            (cell.viewWithTag(103) as! UILabel).text = "NA"
        }
            
        return cell
    }
    
}
