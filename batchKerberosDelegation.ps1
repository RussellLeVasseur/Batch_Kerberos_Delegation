# This script will set Kerberos constrained delegation for Powershell second hop 
# and will enable Single Sign-On (SSO) for Windows Admin Center.

# Powershell will prompt you for credentials.
# This credential needs to have proper privileges to modify AD Objects.


# ==================== CONFIGURATIONS ====================

# Host name of Windows Admin Center
$wac = ""

# OUs to fetch objects from.
$OUs = @(
    "OU=test1,DC=contaso,DC=com",
    "OU=test2,DC=contaso,DC=com"
)

# ================== END CONFIGURATIONS ==================




# Get the identity object of WAC
$wo = Get-ADComputer -Identity $WAC

# Grab Credential
$cred = Get-Credential

foreach ($ou in $OUs){
    # Set the resource-based kerberos constrained delegation for each node
    $objects = (Get-ADComputer -filter * -SearchBase $ou).Name
    foreach ($object in $objects){
        $obj = Get-ADComputer -Identity $object
        Write-Output "Setting $object..."
        Set-ADComputer -Identity $obj -Credential $cred -PrincipalsAllowedToDelegateToAccount $wo
    }
}
