###############################################################################################################################################################################
#  Version    | Description                                                                                                     | Date                 | Author
#
#  1          | initial working version 										                                                | 07072022             | Deepak Khandelwal
#  2          | Added output display, performance enhancement by removing duplicate execution for Org roles 	                | 12072022             | Deepak Khandelwal
#  3          | Added CF command error handling                                                                                 | 20072022             | Deepak Khandelwal
#  4          | Added save username and password in encryped form                                                               | 08082022             | Deepak Khandelwal
#
#
#
#
###############################################################################################################################################################################


#------------ Global variables-----------
$Global:repoPath =(Get-Location).Path #"\\999FSL02.aldi999.loc\RedirectedFolders$\deepak\Downloads\final05072022" #

$Global:repoPath

$apiEndpoints =@(
                   "https://api.cf.eu20.hana.ondemand.com"
                   "https://api.cf.eu10.hana.ondemand.com"
                   "https://api.cf.us21.hana.ondemand.com"
                   "https://api.cf.ap20.hana.ondemand.com"
                   )

#-------Functions-----------------

function display-table {
   
    $filePath=  $Global:repoPath +"\ORG_SPACE.xml"                     # "C:\Users\deepa\Downloads\BTP_USER_MANAGEMENT\ORG_SPACE.xml"
    $ds = New-Object System.Data.DataSet
    $ds.Clear()
    $ds.ReadXml($filePath) 
    $global:dt=New-Object System.Data.DataTable
    $global:dt.Clear()
    $global:dt=$ds.Tables[0]
    $var_grdOutput.ItemsSource= $global:dt.DefaultView
    $var_grdOutput.IsReadOnly=$true
    $var_grdOutput.IsTextSearchEnabled=$true
   
}

function btp-login {
    param ($apiendpoint
    )
    try{
    cf logout
    $user =$var_txtUsername.Text
    $pass = $var_txtPassword.Password
    $chkauth=cf login -u $user -p $pass -a $apiendpoint
    if ("$chkauth" -like "*Authenticating... OK*") 
        {Write-Output "Login successful"
        }
    else{
        $errmsg="Login failed in " + $apiendpoint + "`nPlease check username and credentials" 
        display-notification -msg $errmsg
        }
   
    }
    catch{
    Write-Output "Login failed"
    }
}

function add-access {
    param (
           $o,
           $s,
           $u,
           $isdiff
    )
    $isdiff

    foreach($user in $u){
        #-----add user-------

            if($var_ckbOrgAuditor.IsChecked -and $isdiff){
                try{  
                      $badoutput = $( $result = &  cf set-org-role  $user  ""$o""  OrgAuditor ) 2>&1
                      #$result=cf set-org-role  $user  ""$o""  OrgAuditor
                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgAuditor","Added")
                      }
                      elseif ($badoutput -like "*already has role*"){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgAuditor","Already exist")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgAuditor","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgAuditor",[String]$badoutput)
                      }
                }
                catch{ 
                }
            }

            if($var_ckbOrgMgr.IsChecked -and $isdiff){
            Write-Output "executing cli orgmgr"
                try{   
                       $badoutput = $( $result = &  cf set-org-role  $user  ""$o""  OrgManager ) 2>&1
                       if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgManager","Added")
                      }
                      elseif ($badoutput -like "*already has role*"){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgManager","Already exist")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgManager","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgManager",[String]$badoutput)
                      }
                }
                catch{
                }
            }

            if($var_ckbSpaceAuditor.IsChecked){
                try{  $badoutput = $( $result = &  cf set-space-role  $user  ""$o"" $s SpaceAuditor ) 2>&1
                      
                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceAuditor","Added")
                      }
                      elseif ($badoutput -like "*already has role*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceAuditor","Already exist")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceAuditor","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceAuditor",[String]$badoutput)
                      }
                }
                catch{
                }
            }

            if($var_ckbSpaceDev.IsChecked){
                try{  
                      $badoutput = $( $result = &  cf set-space-role  $user  ""$o"" $s SpaceDeveloper ) 2>&1
                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceDeveloper","Added")
                      }
                      elseif ($badoutput -like "*already has role*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceDeveloper","Already exist")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceDeveloper","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceDeveloper",[String]$badoutput)
                      }
                }
                catch{
                }
            }

            if($var_ckbSpaceMgr.IsChecked){
                try{  

                      $badoutput = $( $result = &  cf set-space-role  $user  ""$o"" $s SpaceManager ) 2>&1
                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceManager","Added")
                      }
                      elseif ($badoutput -like "*already has role*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceManager","Already exist")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceManager","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceManager",[String]$badoutput)
                      }
                }
                catch{
                }
            }


    }
}

function remove-access {
    param (
           $o,
           $s,
           $u,
           $isdiff
    )

    foreach($user in $u){

        #------remove user----

            if($var_ckbOrgAuditor.IsChecked -and $isdiff){
                try{  $badoutput = $( $result = &  cf unset-org-role  $user  ""$o""  OrgAuditor ) 2>&1

                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgAuditor","Removed")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgAuditor","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgAuditor",[String]$badoutput)
                      }
                }
                catch{
                }
            }

            if($var_ckbOrgMgr.IsChecked -and $isdiff){
                try{  $badoutput = $( $result = &  cf unset-org-role  $user  ""$o""  OrgManager ) 2>&1
 
                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgManager","Removed")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgManager","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,"-","OrgManager",[String]$badoutput)
                      }
                }
                catch{
                }
            }

            if($var_ckbSpaceAuditor.IsChecked){
                try{  $badoutput = $( $result = &  cf unset-space-role  $user  ""$o"" $s SpaceAuditor ) 2>&1

                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceAuditor","Removed")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceAuditor","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceAuditor",[String]$badoutput)
                      }
                }
                catch{
                }
            }

            if($var_ckbSpaceDev.IsChecked){
                try{  $badoutput = $( $result = &  cf unset-space-role  $user  ""$o"" $s SpaceDeveloper ) 2>&1

                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceDeveloper","Removed")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceDeveloper","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceDeveloper",[String]$badoutput)
                      }
                }
                catch{
                }
            }

            if($var_ckbSpaceMgr.IsChecked){
                try{ $badoutput = $( $result = &  cf unset-space-role  $user  ""$o"" $s SpaceManager ) 2>&1

                      if($result -like "*OK*" -and [String]$badoutput -like ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceManager","Removed")
                      }
                      elseif($badoutput -like "*No user exists with the username*"){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceManager","No user exists with the username")
                      }
                      elseif([String]$badoutput -notlike ""){
                        $Global:resultTable.Rows.add($user,$o,$s,"SpaceManager",[String]$badoutput)
                      }
                }
                catch{
                }
            }

    }
    
}

function display-notification {
    param ($msg
    )
    Add-Type -AssemblyName PresentationFramework
    $xamlFile = $Global:repoPath +"\Window1.xaml"#"C:\Users\deepa\Downloads\BTP_USER_MANAGEMENT\BTP-UAM\BTP-UAM\Window1.xaml"
    $inputXAML=Get-Content -Path $xamlFile -Raw
    $inputXAML=$inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N","N" -replace '^<Win.*','<Window'
    [XML]$XAML=$inputXAML

    $reader= New-Object System.Xml.XmlNodeReader $XAML
    try{
        $displaywindow=[Windows.Markup.XamlReader]::Load($reader)
    }
    catch{
    Write-Host $_.Exception
    throw
    }

    $xaml.SelectNodes("//*[@Name]") | ForEach-Object {
        try{
            Set-Variable -Name "var_$($_.Name)" -Value $displaywindow.FindName($_.Name) -ErrorAction Stop
        }
        catch{
        throw
        }
    }
    #Get-Variable var_*
    $var_txtNotification.Text=$msg
    $var_btnClose.add_click({
        $displaywindow.Close()
        })

    $displaywindow.ShowDialog()
    #$displaywindow.Close()
}

function display-output-result {
    param ($resultInput
    )
    Add-Type -AssemblyName PresentationFramework
    $xamlFile = $Global:repoPath +"\Window2.xaml"#"C:\Users\deepa\Downloads\BTP_USER_MANAGEMENT\BTP-UAM\BTP-UAM\Window1.xaml"
    $inputXAML=Get-Content -Path $xamlFile -Raw
    $inputXAML=$inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N","N" -replace '^<Win.*','<Window'
    [XML]$XAML=$inputXAML

    $reader= New-Object System.Xml.XmlNodeReader $XAML
    try{
        $displaywindow=[Windows.Markup.XamlReader]::Load($reader)
    }
    catch{
    Write-Host $_.Exception
    throw
    }

    $xaml.SelectNodes("//*[@Name]") | ForEach-Object {
        try{
            Set-Variable -Name "var_$($_.Name)" -Value $displaywindow.FindName($_.Name) -ErrorAction Stop
        }
        catch{
        throw
        }
    }
    #Get-Variable var_*
    $var_grdExecutionResult.ItemsSource= $resultInput.DefaultView
    $var_grdExecutionResult.IsReadOnly=$true
    $var_grdExecutionResult.IsTextSearchEnabled=$true

    $displaywindow.ShowDialog()
    #$displaywindow.Close()
}

function check-prerequesits {
    [String]$errorMsg=""
    if ($var_txtUsername.Text -eq ""){
        $errorMsg += "Username is incorrect or empty please check!`n"
    }
    if ($var_txtPassword.Password -eq ""){
        $errorMsg += "Password is incorrect or empty please check!`n"
    }
    if ($var_txtUserList.Text -eq ""){
        $errorMsg += "Userlist is empty please check!`n"
    }
    if ($var_ckbOrgAuditor.IsChecked -eq $false -and $var_ckbOrgMgr.IsChecked -eq $false -and $var_ckbSpaceAuditor.IsChecked -eq $false -and $var_ckbSpaceDev.IsChecked -eq $false -and $var_ckbSpaceMgr.IsChecked -eq $false  ){
        $errorMsg += "Please select atleast one access role!`n"
    }
    if ($var_grdOutput.SelectedItems.Count -eq 0){
        $errorMsg += "Please select atleast one row from Org and Space list!`n"
    }


    return $errorMsg
}



#-------UI part ------------------

Add-Type -AssemblyName PresentationFramework

$xamlFile = $Global:repoPath +"\MainWindow.xaml" #"C:\Users\deepa\Downloads\BTP_USER_MANAGEMENT\BTP-UAM\BTP-UAM\MainWindow.xaml"
$inputXAML=Get-Content -Path $xamlFile -Raw
$inputXAML=$inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N","N" -replace '^<Win.*','<Window'
[XML]$XAML=$inputXAML

$reader= New-Object System.Xml.XmlNodeReader $XAML
try{
    $psform=[Windows.Markup.XamlReader]::Load($reader)
}
catch{
Write-Host $_.Exception
throw
}

$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    try{
        Set-Variable -Name "var_$($_.Name)" -Value $psform.FindName($_.Name) -ErrorAction Stop
    }
    catch{
    throw
    }
}

#--------load cred----------------
try{$credpath = "C:\temp\uam-cred\user.encrypted"
    $EncryptedData = Get-Content $credpath
    $SecureString1 = ConvertTo-SecureString $EncryptedData
    $var_txtUsername.Text = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString1))
    $credpath = "C:\temp\uam-cred\cred.encrypted"
    $EncryptedData = Get-Content $credpath
    $SecureString1 = ConvertTo-SecureString $EncryptedData
    $var_txtPassword.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString1))
        
    }
    catch{
 
    }


# --------Reload data button --------------
$var_btnReloadData.add_click({
        $filePath= $Global:repoPath +"\ORG_SPACE.xml" #"C:\Users\deepa\Downloads\BTP_USER_MANAGEMENT\ORG_SPACE.xml"
        Remove-Item $filePath
        $loginStatus=@()
        $columns =@(
                       "Region"
                       "OrgName"
                       "SpaceName"
                       "APIEndpoint"  
                       )
        
        $global:outputTable=New-Object System.Data.DataTable
        [void]$global:outputTable.Columns.AddRange($columns)
        $global:outputTable.Clear()

    foreach($apiendpoint in $apiEndpoints)
    {
       
        $user =$var_txtUsername.Text
        $pass =$var_txtPassword.Password
        $chkauth = cf login -u $user -p $pass -a $apiendpoint

        
        if ("$chkauth" -like "*Authenticating... OK*") 
        {
            $loginStatus += $apiendpoint + "- Login Successful" +"`n"

            #-------get org and space list-----------
            [System.Collections.ArrayList]$orgdata = @()
            $orgdata = cf orgs
            $orgdata.RemoveRange(0,3)

            for ($i=0;$i -lt ($orgdata.count); $i++  )
            {
                cf target -o $orgdata[$i]
                [System.Collections.ArrayList]$spacedata = @()
                $spacedata = cf spaces
                $spacedata.RemoveRange(0,3)
                for ($j=0;$j -lt ($spacedata.count); $j++  )
                {
                    $global:outputTable.Rows.add("-",$orgdata[$i],$spacedata[$j],$apiendpoint)
                }
            }

        }

        else
        {
         $loginStatus += $apiendpoint +"- Login Failed"+ "`n"
        }

        
    }

    $global:outputTable.TableName="mytable"
    $global:outputTable.WriteXml($Global:repoPath +"\ORG_SPACE.xml")
    display-table
    display-notification -msg $loginStatus
    
})

display-table


# --------filter --------------
$var_txtOrgName.Add_TextChanged({
    $filter="OrgName LIKE '%$($var_txtOrgName.Text)%'"
    $global:dt.DefaultView.RowFilter=$filter
  

})

$var_txtSpace.Add_TextChanged({
    $filter="SpaceName LIKE '%$($var_txtSpace.Text)%'"
    $global:dt.DefaultView.RowFilter=$filter
    
})

# --------Add access btn--------------
$var_btnAddAccess.add_click({

$errorMsg1=check-prerequesits
If($errorMsg1 -eq ""){
    $columns =@("User","Org","Space","Role","Status"  )    
    $Global:resultTable=New-Object System.Data.DataTable
    [void]$Global:resultTable.Columns.AddRange($columns)
    $Global:resultTable.Clear()
   
    $selectedRowItems=$var_grdOutput.SelectedItems
    $userlist=$var_txtUserList.Text
    $userlist = $userlist -replace ' ',''
    $userlistArray= $userlist -split"`r`n"
    
    for ($i=0;$i -lt ($selectedRowItems.Count); $i++  )
    {
        $api=$selectedRowItems.Item($i).APIEndpoint
        $org=$selectedRowItems.Item($i).OrgName
        $space=$selectedRowItems.Item($i).SpaceName

             if ($i -eq 0){
                $a="diffrent if"
                $a
                $orgIsDiffrent= $true
                btp-login -apiendpoint $api

            }
            elseif ($selectedRowItems.Item($i-1).APIEndpoint -eq $selectedRowItems.Item($i).APIEndpoint) {
                $a="same elseif"
                $a
                $selectedRowItems.Item($i).APIEndpoint
                if($selectedRowItems.Item($i-1).OrgName -eq $selectedRowItems.Item($i).OrgName){
                    $orgIsDiffrent= $false
                }
                else{
                    $orgIsDiffrent= $true
                }
            }
            else{
                $a="diffrent else"
                $a
                btp-login -apiendpoint $api
                $orgIsDiffrent= $true
            }      
        add-access -u $userlistArray -o $org -s $space -isdiff $orgIsDiffrent
    }

  
    display-output-result -resultInput $Global:resultTable
}
else{
    display-notification -msg $errorMsg1
}

})

# --------remove access btn--------------
$var_btnRemoveAccess.add_click({

$errorMsg1=check-prerequesits
If($errorMsg1 -eq ""){
    $columns =@("User","Org","Space","Role","Status"  )    
    $Global:resultTable=New-Object System.Data.DataTable
    [void]$Global:resultTable.Columns.AddRange($columns)
    $Global:resultTable.Clear()

    $selectedRowItems=$var_grdOutput.SelectedItems 
    $userlist=$var_txtUserList.Text
    $userlist = $userlist -replace ' ',''
    $userlistArray= $userlist -split"`r`n"
    
    for ($i=0;$i -lt ($selectedRowItems.Count); $i++  )
    {
        $api=$selectedRowItems.Item($i).APIEndpoint
        $org=$selectedRowItems.Item($i).OrgName
        $space=$selectedRowItems.Item($i).SpaceName

            if ($i -eq 0){
                $a="diffrent if"
                $a
                $orgIsDiffrent= $true
                btp-login -apiendpoint $api

            }
            elseif ($selectedRowItems.Item($i-1).APIEndpoint -eq $selectedRowItems.Item($i).APIEndpoint) {
                $a="same elseif"
                $a
                $selectedRowItems.Item($i).APIEndpoint
                if($selectedRowItems.Item($i-1).OrgName -eq $selectedRowItems.Item($i).OrgName){
                    $orgIsDiffrent= $false
                }
                else{
                    $orgIsDiffrent= $true
                }
            }
            else{
                $a="diffrent else"
                $a
                btp-login -apiendpoint $api
                $orgIsDiffrent= $true
            }    
            
        remove-access -u $userlistArray -o $org -s $space -isdiff $orgIsDiffrent
    }

   
    display-output-result -resultInput $Global:resultTable
}  
else{
    display-notification -msg $errorMsg1
}

})

$var_btnSave.add_click({

$path = "C:\temp\uam-cred"
If(!(test-path -PathType container $path))
{
      New-Item -ItemType Directory -Path $path
}
$path1= $path + "\user.encrypted"
$userSecureString=$var_txtUsername.Text | ConvertTo-SecureString -AsPlainText -Force
$EncryptedData = ConvertFrom-SecureString $userSecureString
$EncryptedData | Out-File -FilePath $path1
$path1= $path + "\cred.encrypted"
$passSecureString= $var_txtPassword.Password | ConvertTo-SecureString -AsPlainText -Force
$EncryptedData = ConvertFrom-SecureString $passSecureString
$EncryptedData | Out-File -FilePath $path1

})

$psform.ShowDialog()
$psform.Close()
#$loginwindow.Close()
#$displaywindow.Close()













