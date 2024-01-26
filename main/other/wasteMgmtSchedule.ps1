# Draft

#the number of days before the next time they visit 
$days = 14
#tells us when we want to stop
$currentYear = $(get-date).year
#when the first pick up is scheduled

##--Trash
$startdate = (Get-Date -Year $currentYear -Month 1 -Day 23)


# updates as we loop through collecting the list of days through out the year
$date = ($startdate).AddDays($days)
$service="Trash Only"



#$service="Recycling"

$h = "Holiday"
$holidays = @(
    [pscustomobject]@{Date="01/16/2023"; Service="$h"},
    [pscustomobject]@{Date="02/20/2023"; Service="$h"}
    [pscustomobject]@{Date="05/29/2023"; Service="$h"},
     [pscustomobject]@{Date="06/19/2023"; Service="$h"},
     [pscustomobject]@{Date="07/04/2023"; Service="$h"},
     [pscustomobject]@{Date="09/04/2023"; Service="$h"},
     [pscustomobject]@{Date="10/09/2023"; Service="$h"},
     [pscustomobject]@{Date="11/11/2023"; Service="$h"},
     [pscustomobject]@{Date="11/23/2023"; Service="$h"},
     [pscustomobject]@{Date="12/24/2023"; Service="$h"}
)

#add the first day

#TODO: Append category for holidays to data array of observed as a warning
#TODO: Add logic to skip dates that fall on the holiday dates

$data += @(
    [pscustomobject]@{Date=($startdate.ToString("MM/dd/yyyy")) ; Service="$service"}
)

# Step 1. First service date listing
DO
{       
    #Show each date as we loop 
    # TODO: Eventually clean this up, change service type to parameter and dynamically loop through each list
   
    # If($date.ToString("MM/dd/yyyy") -ne $holidays.Date){
    $data +=  @(
        [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="$service"}
    )
    $date = $($date).AddDays($days)
    # move on to the next date 
    

}While($date.year -eq $currentYear)

#Step 2. Add next service dates 
# refresh values until we move this into function
$service="Trash and Yard Waste"
$startdate = (Get-Date -Year $currentYear -Month 1 -Day 24)
$date = ($startdate).AddDays($days) 
$data += @(
    [pscustomobject]@{Date=($startdate.ToString("MM/dd/yyyy")) ; Service="$service"}
)

DO
{       
    $data +=  @(
        [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="$service"}
    )
    $date = $($date).AddDays($days)

}While($date.year -eq $currentYear)



#Step 3. Add next service dates 
# refresh values until we move this into function
$service="Recycling"
$startdate = (Get-Date -Year $currentYear -Month 1 -Day 20)
$date = ($startdate).AddDays($days) 
$data += @(
    [pscustomobject]@{Date=($startdate.ToString("MM/dd/yyyy")) ; Service="$service"}
)

DO
{       
    $data +=  @(
        [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service=($_.Service)}
    )
    $date = $($date).AddDays($days)

}While($date.year -eq $currentYear)



$final = @()

$data | Foreach-Object {
    if($_.Date -notin $holidays.Date)
    {
        $final +=[pscustomobject]@{Date=($_.Date) ; Service=($_.Service)}
    }
}
$final += $holidays



# Will clean up later just being lazy and keeping this here to copy paste 
# [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="Recycle"}
# [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="Trash"}
# [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="Trash and Yard Waste"}

#Sort List and review the results
$final = $($final | Sort-Object -Property Date) 

$final | Out-File "output.txt"



$data = $null
$holidays = $null
$final = $null