![VBBar-platform-osx](https://img.shields.io/badge/platform-OS%20X-lightgrey.svg)
![VBBar-code-shell](https://img.shields.io/badge/code-AppleScript-yellow.svg)
[![VBBar-depend-node](https://img.shields.io/badge/dependency-node%206.2.0-green.svg)](https://nodejs.org)
[![VBBar-depend-npm](https://img.shields.io/badge/dependency-npm%203.8.9-green.svg)](https://nodejs.org)
[![VBBar-depend-trans](https://img.shields.io/badge/dependency-trans%200.9.4-green.svg)](https://github.com/soimort/translate-shell)
[![VBBar-depend-wunderline](https://img.shields.io/badge/dependency-wunderline%204.3.1-ff69b4.svg)](https://github.com/wayneashleyberry/wunderline)
[![VBBar-license](http://img.shields.io/badge/license-MIT+-blue.svg)](https://github.com/JayBrown/Iri/blob/master/license.md)

# Iri
**Iri (pronounced "eye-ree"), short for "I've read it", is an AppleScript OS X Automator Service (workflow) for Apple Mail, with which the recipient of a message can send an automated "I've-read-it" reply to the original message's sender and its CC recipients**

![Iri-screengrab](https://github.com/JayBrown/Iri/blob/master/img/Iri_grab.png)

## Current status
Beta (pre-release)

## About
* Iri is called with a keyboard shortcut, and runs on a message you have selected in Apple Mail
* Iri automatically answers a message's sender and all its TO and CC recipients with a standard reply (Iri note) using the mail subject prefix "Vidi"
* The Iri note will state the date the message was received, the date it was read, and that you will respond asap.
* If the original message is in a local mailbox, Iri lets you choose the account from which to send the Iri note.
* Iri then adds a new task to either Apple Reminders or Wunderlist (depending on the version you choose) in the list "Iri", with a due date of one week, set to remind you in a day (Apple Reminders only)
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
* Download the [latest release](https://github.com/JayBrown/Iri/releases), expand the archive, choose your version, and double-click to install
* If you receive an error, open the file with Automator, and save/install from there
* Manually set a keyboard shortcut in your System Preferences `Keyboard > Shortcuts > Services | General > Iri`, e.g. ⌃⌥⌘I

## To-do
* Find a fix for the flashing message window (AppleScript `visible=false` bug?)
* Find a way to use AppleScript to extract only level 0 message content
* Use shell command instead of AppleScript to enter new Iri reminder in Apple Reminders, as soon as [rem](https://github.com/kykim/rem) is working again

## Why Iri?
* Some messages are too complex to answer in a brief amount of time, so it could be useful to let the sender know that you've read his message, and that you will reply as soon as you have the time.
* The sender then knows that he can call you back to talk about the issue on the phone, if it's important.