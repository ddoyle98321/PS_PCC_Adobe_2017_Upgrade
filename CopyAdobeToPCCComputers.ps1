# This is the file that contains the list of computers you want 
# to copy the folder and files to. Change this path IAW your folder structure.
$computers = gc "C:\temp\computers.txt"

# This is the directory you want to copy to the computer (IE. c:\folder_to_be_copied)
$source = "C:\temp\PCC Adobe Upgrade"

# On the desination computer, where do you want the folder to be copied?
$dest = "c$\windows\dwrcs\Uploads\PCC Adobe Upgrade"

foreach ($computer in $computers) {
    if (test-Connection -Cn $computer -quiet) {
        Copy-Item $source -Destination \\$computer\$dest -Recurse
    } else {
        "$computer is not online"
    }
}
