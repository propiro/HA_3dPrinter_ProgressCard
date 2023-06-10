clearListener()
if (tempval != -1 ) do 
(
	tempval = -1
	str = tempval as string
 $Text001.text = str
	)
fn incraseText =
(

tempvalstr = $Text001.text as integer
print tempvalstr
tempval = int tempvalstr
tempval = tempval + 1
if (tempval > 100) do (tempval = -1)
str = tempval as string
 $Text001.text = str 

	
	
)

callbacks.removeScripts id:#textTime --check for a callback of the same name and remove if exists

callbacks.addScript #preRenderEval incraseText id:#textTime --  set text to current frame and call a evaluation before render