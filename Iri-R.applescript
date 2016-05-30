-- Iri
-- v1.5 beta
-- 2016-05
-- Version for Apple Reminders

on run {input, parameters}
	
	set dateCurrent to (current date)
	set theTimeZone to (do shell script "date +%Z")
	set theDeadline to (dateCurrent + (7 * days))
	set reminderDate to (dateCurrent + (1 * days))
	
	set userLibrary to path to library folder from user domain as string
	set prefsFolder to userLibrary & "Preferences:"
	set plistPath to prefsFolder & "local.lcars.Iri.plist"
	
	tell application "System Events"
		if exists file plistPath then
			tell property list file plistPath
				tell contents
					set previousRunDate to (value of property list item "PreviousRun")
					set value of property list item "PreviousRun" to dateCurrent
				end tell
			end tell
		else
			set plistData to "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict/>
</plist>"
			tell application "Finder"
				set plistFile to open for access plistPath with write permission
				set eof of plistFile to 0
				write plistData to plistFile starting at eof
				close access plistFile
			end tell
			tell property list file plistPath
				tell contents
					set value to {|PreviousRun|:dateCurrent}
				end tell
			end tell
			set previousRunDate to dateCurrent
		end if
	end tell
	
	tell application "Mail"
		set sentIriNotes to (messages of sent mailbox whose date sent ≥ previousRunDate and subject begins with "Vidi: ")
		repeat with sentIriNote in sentIriNotes
			delete sentIriNote
		end repeat
		set theSelection to selection
		set theMessage to item 1 of theSelection
		set theOriginalBody to the content of theMessage
		set theLanguage to (do shell script "export PATH=\"/usr/local/bin:$PATH\";/usr/local/bin/trans -no-ansi -show-original n -identify " & quoted form of theOriginalBody & " | awk '/Name/ {print $2}'")
		set dateReceived to (date received of theMessage)
		set reminderSubject to (subject of theMessage)
		set reminderURL to "message://%3c" & theMessage's message id & "%3e"
		set theAccount to (account of (mailbox of theMessage))
		if theAccount is equal to missing value then
			set senderList to {}
			set allAccounts to every account
			repeat with aAccount in allAccounts
				set allAddresses to email addresses of aAccount
				if (allAddresses is not equal to missing value) then
					repeat with aAddress in allAddresses
						set senderList to senderList & {(full name of aAccount & " <" & aAddress & ">") as string}
					end repeat
				end if
			end repeat
			set theResult to choose from list senderList with prompt "Which account would you like to send the Iri note from?" without multiple selections allowed
			if theResult is equal to false then
				return input
			end if
			set iriSender to item 1 of theResult
			set theAddress to (do shell script "echo " & quoted form of iriSender & " | awk -F'[<|>]' '{print $2}'")
		else if theAccount is not equal to missing value then
			set theAddress to (email addresses of theAccount) as string
			set iriSender to (full name of theAccount & " <" & theAddress & ">") as string
		end if
		set iriSubject to "Vidi: " & (subject of theMessage)
		if theLanguage is "English" then
			set bodyDeadline to "I have read your message and will reply as soon as possible."
			set bodyReceived to "Received: "
			set bodyRead to "Read: "
		else if theLanguage is "German" then
			set bodyDeadline to "Ich habe Ihre Nachricht gelesen und werde so schnell wie möglich antworten."
			set bodyReceived to "Erhalten: "
			set bodyRead to "Gelesen: "
		else if theLanguage is "Dutch" then
			set bodyDeadline to "Ik heb uw bericht gelezen en zal zo spoedig mogelijk antwoorden."
			set bodyReceived to "Ontvangen: "
			set bodyRead to "Gelezen: "
		else if theLanguage is "Italian" then
			set bodyDeadline to "Ho letto il tuo messaggio e risponderò appena possibile."
			set bodyReceived to "Ricevuto: "
			set bodyRead to "Letto: "
		else if theLanguage is "Spanish" then
			set bodyDeadline to "He leído su mensaje y le responderemos tan pronto como sea posible."
			set bodyReceived to "Recibido: "
			set bodyRead to "Leído: "
		else if theLanguage is "French" then
			set bodyDeadline to "J'ai lu votre message et vous répondra dans les plus brefs délais."
			set bodyReceived to "Reçu: "
			set bodyRead to "Lu: "
		else if theLanguage is "Latin" then
			set bodyDeadline to "Nuntium tuum legi rediboque quam primum."
			set bodyReceived to "Acceptum: "
			set bodyRead to "Visum: "
		else
			set bodyDeadline to "I have read your message and will reply as soon as possible."
			set bodyReceived to "Received: "
			set bodyRead to "Read: "
		end if
		set iriRecipient to (sender of theMessage)
		set originalTOs to address of to recipients of theMessage
		set originalCCs to address of cc recipients of theMessage
		set iriContent to bodyDeadline & return & bodyReceived & dateReceived & " " & theTimeZone & return & bodyRead & dateCurrent & " " & theTimeZone
		set iriMessage to make new outgoing message with properties {content:iriContent, sender:iriSender}
		tell iriMessage
			set visible to false
			set subject to iriSubject
			make new to recipient with properties {address:iriRecipient}
			repeat with i from 1 to (count originalTOs)
				set iriCC to item i of originalTOs
				if iriCC is equal to theAddress then set iriCC to ""
				make new cc recipient at end of cc recipients with properties {address:iriCC}
			end repeat
			repeat with i from 1 to (count originalCCs)
				set iriCC to item i of originalCCs
				if iriCC is equal to theAddress then set iriCC to ""
				make new cc recipient at end of cc recipients with properties {address:iriCC}
			end repeat
		end tell
		send iriMessage
		tell theMessage
			set flag index to 6
			set read status to false
		end tell
	end tell
	
	tell application "Reminders"
		if not (exists list "Iri") then
			make new list with properties {name:"Iri"}
		end if
		set reminderList to list "Iri"
		tell reminderList
			make new reminder with properties {name:reminderSubject, body:reminderURL, due date:theDeadline, remind me date:reminderDate}
		end tell
		quit
	end tell
	
	return input
end run