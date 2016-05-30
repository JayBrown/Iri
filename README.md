# Iri
**Iri (pronounced "eye-ree"), short for "I've read it", is an AppleScript OS X Automator Service (workflow) for Apple Mail that the recipient of a message can call to send an automated "I've-read-it" message to the message sender and the CC recipients**

## Current status
Beta (upload later)

## About
* Iri is called with a keyboard shortcut, and runs on a message the user has selected in Apple Mail
* Iri automatically answers a message's sender and all its TO and CC recipients with a standard reply (Iri note) using the mail subject prefix "Vidi"
* The Iri note will state the date the message was received, the date it was read, and that you will reply asap.
* If the original message is in a local mailbox, Iri lets you choose the account from which to send the Iri note.
* Iri then adds a new reminder to Apple Reminders in the list "Iri", set to remind you in a day, with a due date of one week.
* There will also be an option with Wunderlist support (alternate release).
* Iri writes the run date into a preferences file, and upon next launch it removes all sent Iri notes from your sent mailbox since that date (inclusive).
* Iri currently detects and answers messages written in English, German, Spanish, Italian, French, Dutch, and Latin; in all other cases the Iri note will be in English.

## Prerequisites
Make sure you have `/usr/local/bin` in your `PATH`

### Homebrew installations
Install using [Homebrew](http://brew.sh) with `brew install <software-name>` (or with a similar manager) 
* [node](https://nodejs.org) [optional]
* [translate-shell](https://github.com/soimort/translate-shell)

### Node.js installations [optional]
* [wunderline](https://github.com/wayneashleyberry/wunderline): `npm install -g wunderline`

Installing `wunderline` is only necessary, if you want to use Iri with [Wunderlist](https://www.wunderlist.com).

After installing `wunderline` you need to authorize the software by [creating a new app with Client ID and Access Token](https://developer.wunderlist.com/apps/new). Afterwards you only need to run `wunderline auth` in your shell.

## Installation
* Download the OS X Service, expand, and double-click to install
* If you receive an error, open the file with Automator, and save/install from there
* Manually set a keyboard shortcut in your System Preferences `Keyboard > Shortcuts > Services | General > Iri`, e.g. ⌃⌥⌘I

## To-do
* Find a fix for the flashing message window (AppleScript `visible=false` bug?)
* Find a way to use AppleScript to extract only level 0 message content
* Use shell command instead of AppleScript to enter new Iri reminder in Apple Reminders, as soon as [rem](https://github.com/kykim/rem) is working again

## Why Iri?
* Some messages are too complex to answer in a brief amount of time, so it could be useful to let the sender know that you've read his message, and that you will reply as soon as you have the time.
* The sender then knows that he can call you back to talk about the issue on the phone, if it's important.