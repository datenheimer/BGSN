﻿/*
	This example is designed to show how to use the default Neutron template
	page. Because it uses the default template, it is also the simplest example
	to use and tweak as a beginner.
	
	It is also designed to show how you would apply your own theming to the
	template without having to modify it directly, by applying CSS styling to
	the built-in template title bar elements.
*/

#NoEnv
SetBatchLines, -1
CoordMode, Mouse, Screen

; Include the Neutron library
#Include ./Neutron.ahk

html =
( ; html
	<div class="content">
		<h1>BGSNoob</h1><p>Developed by Puhfy and YouAreHired</p>

		<p>
			Neutron provides a powerful set of tools for build HTML-based user interfaces
			with AutoHotkey. It leverages the Trident engine, known for its use in Internet
			Explorer, because of its deep integration with the Microsoft Windows operating
			system and its wide availability across systems.
		</p>
		<p>
			This example is designed to show how to use the default Neutron template page.
			Because it uses the default template, it is also the simplest example to use
			and tweak as a beginner.
		</p>
		<p>
			It is also designed to show how you would apply your own theming to the
			template without having to modify it directly, by applying CSS styling to
			the built-in template title bar elements.
		</p>

		<h2>Example Button</h2>
		<button onclick="ahk.Clicked(event)">Click Me!</button>

		<h2>Example Form</h2>
		<form onsubmit="ahk.Submitted(event)">
			<label for="firstName">First Name:</label>
			<input type="text" id="firstName" placeholder="John" required>
			<br>
			<label for="lastName">Last Name:</label>
			<input type="text" id="lastName" placeholder="Smith" required>
			<br>
			<button type="submit">Submit</button>
		</form>

		<h2>Example Dynamic Content</h2>
		<p>
			Your mouse is at <span id="ahk_x">0</span>, <span id="ahk_y">0</span>.
		</p>
	</div>
)

css =
( ; css
	/* Make the title bar dark with light text */
	header {
		background: #333;
		color: white;
	}

	/* Make the content area dark with light text */
	.main {
		background: #444;
		color: white;
	}

	.content {
		scrollbar-color: rebeccapurple green;
		scrollbar-width: thin;
	}

	/* Make input boxes follow the dark theme */
	input {
		margin: 0.25em;
		padding: 0.5em;
		border: none;
		background: #333;
		color: white;
		border-radius: 0.25em;
	}
	:-ms-input-placeholder {
		color: silver;
	}
	button {
		background: slategray;
		border: none;
		color: white;
		padding: 0.25em 0.5em;
		border-radius: 0.25em;
	}
)

js =
( ; js
	// Write some JavaScript here
)

title = Neutron Template Example


neutron := new NeutronWindow(html, css, js, title)

; Use the Gui method to set a custom label prefix for GUI events. This code is
; equivalent to the line `Gui, name:+LabelNeutron` for a normal GUI.
neutron.Gui("+LabelNeutron")

; Show the GUI, with an initial size of 640 x 480. Unlike with a normal GUI
; this size includes the title bar area, so the "client" area will be slightly
; shorter vertically than if you were to make this GUI the normal way.
neutron.Show("w1280 h780")


SetTimer, DynamicContent, 100

return

NeutronClose:
ExitApp
return


Clicked(neutron, event)
{
	; event.target will contain the HTML Element that fired the event.
	; Show a message box with its inner text.
	MsgBox, % "You clicked: " event.target.innerText
}

Submitted(neutron, event)
{
	; Some events have a default action that needs to be prevented. A form will
	; redirect the page by default, but we want to handle the form data ourself.
	event.preventDefault()
	
	; Dismiss the GUI
	neutron.hide()
	
	; Use the GetFormData helper to get an associative array of the form data
	formData := neutron.GetFormData(event.target)
	MsgBox, % "Hello " formData.firstName " " formData.lastName "!"
	
	; Re-show the GUI
	neutron.Show()
}

DynamicContent()
{
	; This function isn't called by Neutron, so we'll have to grab the global
	; Neutron window variable instead of using one from a Neutron event.
	global neutron
	
	; Get the mouse position
	MouseGetPos, x, y
	
	; Update the page with the new position
	neutron.doc.getElementById("ahk_x").innerText := x
	neutron.doc.getElementById("ahk_y").innerText := y
}
