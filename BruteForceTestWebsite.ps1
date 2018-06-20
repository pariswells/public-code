
$list = Get-Content codes.txt

foreach ($line in $list)
{
	$line = 'https://websiteurl'+$line+'.html'
		  
	# First we create the request.
	$HTTP_Request = [System.Net.WebRequest]::Create($line)

	# We then get a response from the site.
	$error.clear()
  # Try the website
	try { $HTTP_Response = $HTTP_Request.GetResponse()}
  # If fail do nothing
	catch {}
  # if not error
	if (!$error) {
	# We then get the HTTP code as an integer.
	$HTTP_Status = [int]$HTTP_Response.StatusCode
	If ($HTTP_Status -eq 200) {
  #tell me the working URL
		Write-Host $line
	}

	# Finally, we clean up the http request by closing it.
	$HTTP_Response.Close()

	}
}
