
# Connect to SQL Server
$server = "WONDERBREND"
$database = "Mini_Project_DotsS"

# Load the SQL Server module
Import-Module SqlServer

# Request client ID & Verify the number entered is in fact a number
$clientID= Read-Host "Enter client ID Number"

if ($null -eq ($clientID -as [int])) {

    Write-Output "Invalid Client Number"

}

    else {

#Once verified, start with the Query to get the results from the database

try {
    $job_status=@"
SELECT Customers.CustomerName AS "Name", Customers.CustomerID AS "Customer ID", PrintJobs.fileName AS "File Name",
PrintJobs.jobID AS "Job ID", 
PrintJobs.workflowStage AS "Workflow Stage", PrintJobs.Status AS "Status", 
PrintJobs.ProblemDescription AS "Description" 
FROM PrintJobs 
LEFT JOIN Customers ON Printjobs.CustomerID=Customers.CustomerID WHERE $clientID=Customers.CustomerID;
"@
# Execute the query
 $results = Invoke-Sqlcmd `
     -ServerInstance $server `
     -Database $database `
     -Query $job_status `
    -TrustServerCertificate


if($clientID -eq $results."Customer ID")
{

 Write-Output $results."Customer ID", $results.Name
 Write-Output $results."Job ID", $results."File Name", $results"Workflow Stage", 
 Write-Output $results.Status, $results.PrintJobs.Description
}

else {
    Write-Output "No client with that number"
}
    
}
catch {
    Write-Output "Something failed, contact the IT appartmente with error code"
}
    }


# Display the results
$results | Format-Table -AutoSize