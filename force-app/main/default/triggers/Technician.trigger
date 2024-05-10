trigger TechnicianUpdate on Technician (after update) {
  
    // List to store technicians with updated status for bulk update
    List<Technician> techniciansToUpdate = new List<Technician>();
    
    for (Technician tech : Trigger.new) {
      
      // Check if Status field has been updated
      if (Trigger.isFieldChanged('Status__c')) {
        
        // Update Utilization based on Status
        if (tech.Status__c == 'Available') {
          tech.Utilization__c = 0; // Set Utilization to 0 for available technicians
        } else if (tech.Status__c == 'Busy') {
          // Calculate Utilization based on workload (example using a custom field)
          tech.Utilization__c = Math.ceil((tech.TotalAssignedHours__c / tech.AvailableHours__c) * 100);
          
          // Enforce maximum utilization for busy technicians (optional)
          if (tech.Utilization__c > 80) { // Adjust threshold as needed
            tech.Utilization__c = 80;
            tech.addError('Utilization cannot exceed 80% for busy technicians.');
          }
        }
        
        // Add technician to update list
        techniciansToUpdate.add(tech);
      }
    }
    
    // Update records in bulk for efficiency
    if (!techniciansToUpdate.isEmpty()) {
      update techniciansToUpdate;
    }
  }
  