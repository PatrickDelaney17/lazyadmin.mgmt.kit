# Draft

#the number of days before the next time they visit 
$days = 14
#tells us when we want to stop
$currentYear = $(get-date).year
#when the first pick up is scheduled
$startdate = (Get-Date -Year $currentYear -Month 1 -Day 9)
# updates as we loop through collecting the list of days through out the year
$date = ($startdate).AddDays($days)

#add the first day

#TODO: Append category for holidays to data array of observed as a warning
#TODO: Add logic to skip dates that fall on the holiday dates
#TODO: solve for odd ball dates due to holiday schedule

#TODO: ADD If not null or try += from the start
$data += @(
    [pscustomobject]@{Date=($startdate.ToString("MM/dd/yyyy")) ; Service="Trash"}
)


DO
{   
    #Show each date as we loop 
   # ($date.ToString("MM/dd/yyyy"))
     # TODO: Eventually clean this up, change service type to parameter and dynamically loop through each list
    $data +=  @(
        [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="Trash"}
    )
    # move on to the next date 
    $date = $($date).AddDays($days)

}While($date.year -eq $currentYear)

# Will clean up later just being lazy and keeping this here to copy paste 
# [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="Recycle"}
# [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="Trash"}
# [pscustomobject]@{Date=($date.ToString("MM/dd/yyyy")) ; Service="Trash and Yard Waste"}


#Sort List and review the results
$data | Sort-Object -Property Date 



