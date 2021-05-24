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
        
        processSlots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.isHidden = self.filteredCenters.isEmpty
    }
    
    private func processSlots(){
        
        if let centers = self.slots?.centers, !centers.isEmpty{
            
            centers.forEach { center in
                if let sessions = center.sessions?.filter({ session in
                    if let ageLimit = filter?.getAgeLimit(), let dosage = filter?.getDosage(){
                        return (session.minAgeLimit ?? 0) == (ageLimit == .Eighteen ? 18 : 45) && (dosage == .First_Dose ? ((session.availableCapacityDose1 ?? 0) > 0) : ((session.availableCapacityDose2 ?? 0) > 0))
                    }
                    return true
                }), !sessions.isEmpty{
                    var filteredCenter = center
                    filteredCenter.sessions = sessions
                    filteredCenters.append(filteredCenter)
                }
            }
        }
    }
}

/*
 
 

 
 */

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
