![Version](https://img.shields.io/badge/version-2.0.0-orange.svg)
![Plaftorm](https://img.shields.io/badge/platform-TextMate-blue.svg)


# TextMate2 - Power Tools

This bundle includes most used commands (*on a daily basis*) of me!...

## Installation

```bash
cd ~/Library/Application\ Support/TextMate/Bundles/
git clone https://github.com/vigo/textmate2-power-tools.git PowerTools.tmbundle

# Restart your TextMate2
```

## Available Items

### Django

#### Snippets

TAB completion | Description
---------------|:-----------
`admin` + <kbd>⇥</kbd> | ![Screenshot of: admin](Screens/django-admin.png?1 "admin+TAB")
`model` + <kbd>⇥</kbd> | ![Screenshot of: model](Screens/django-model.png?1 "model+TAB")
`fld` + <kbd>⇥</kbd> (*For fields...*) | ![Screenshot of: fld](Screens/django-fld.png?1 "fld+TAB")
`opt` + <kbd>⇥</kbd> (*For field options...*) | ![Screenshot of: opt](Screens/django-opt.png?1 "opt+TAB")
`hlp` + <kbd>⇥</kbd> (*Helpers*) | ![Screenshot of: hlp](Screens/django-hlp.png?1 "hlp+TAB")

#### Scope

You have a scope called: **Python Django (Extended)**.
Press <kbd>⌃</kbd> + <kbd>⌥</kbd> + <kbd>⇧</kbd> + <kbd>P</kbd> for selecting
this scope.


---


### Python

#### Snippets

TAB completion | Description
---------------|:-----------
`ase` + <kbd>⇥</kbd> | ![Screenshot of: ase](Screens/python-ase.png?1 "ase+TAB")
`utf` + <kbd>⇥</kbd> | `# -*- coding: utf-8 -*-`
`p` + <kbd>⇥</kbd> | Print with format: `print(CURSOR.format())`
`pp` + <kbd>⇥</kbd> | `pp = pprint.PrettyPrinter(indent=4)`
`pr` + <kbd>⇥</kbd> | Pretty Print with format: `pp.pprint(CURSOR.format())`
<kbd>⌃</kbd> + <kbd>'</kbd> | Docstring

`hlp` + <kbd>⇥</kbd>

    from __future__ import unicode_literals
                           print_function
                           division
                           absolute_imports


---


## Ruby

You need to add **Ruby on Rails** bundle from Preferences/Bundles.

### Snippets for ERB

TAB completion | Description
---------------|:-----------
`=` + <kbd>⇥</kbd> | `<%= CURSOR %>`
`if` + <kbd>⇥</kbd> | ERB compatible `if`
`each` + <kbd>⇥</kbd> | ERB compatible `each` and `each_with_index`


---


## Rake

### Snippets

`tas` + <kbd>⇥</kbd>

* Task with args
* Task with args and dependecies
* Task w/o description

* `tasr` + <kbd>⇥</kbd>: Creates remote-task skel
* `tasd` + <kbd>⇥</kbd>: Creates default task code
* `inv` + <kbd>⇥</kbd>: Creates `Rake::Task...invoke` + params
* `des` + <kbd>⇥</kbd>: `desc "...."` only


---


## Bash

### Snippets

* `if` + <kbd>⇥</kbd>: `if` / `else` / `elif` template.
* `for` + <kbd>⇥</kbd>: Array iteration template


---

### Markdown

### Snippets


* `badge` + <kbd>⇥</kbd>: Adds **img.shields.io** badge!
* <kbd>⌥</kbd> + <kbd>(</kbd>: Fixes Parenthesis behavior. 


---


### jQuery

### Snippets

* `each` + <kbd>⇥</kbd>: jQuery `each` code template
* `ready` + <kbd>⇥</kbd>: jQuery `$(document).ready()` code template
* `plug` + <kbd>⇥</kbd>: jQuery plugin skel.


---


## HTML

### Snippets

* `more` + <kbd>⇥</kbd>: `&rsquo;`
* <kbd>⌃</kbd> + <kbd>⌘</kbd> + <kbd>S</kbd>: Wrap selection with smart quotes.


---


### Javascript

### Snippets


* `con` + <kbd>⇥</kbd>: Generates `console.log`, `console.dir`,
  `console.warn`, `console.error` skel
* `if` + <kbd>⇥</kbd>: `if` related code.
* `fun` + <kbd>⇥</kbd>: `function` related code.
* `for` + <kbd>⇥</kbd>: `for` related code.
* `swi` + <kbd>⇥</kbd>: `switch` related code.

### Commands

You need to install `node` locally and must define `TM_NODE` variable and set
the executable path for node:

```bash
# example
defaults write com.macromates.textmate environmentVariables -array-add \
    '{enabled = 1; value = "/path/to/node"; name = "TM_NODE"; }'
```

* <kbd>⌘</kbd> + <kbd>R</kbd>: Runs javascript. 


---


## Go

### Snippets

* `fmt` + <kbd>⇥</kbd>: Go format helper


---


## Swift

You need to install/activate **Swift Bundle** from: TextMate > Preferences >
Bundles.

### Snippets

* `p` + <kbd>⇥</kbd>: Print statement
* `typ` + <kbd>⇥</kbd>: Type of object
* `=` + <kbd>⇥</kbd>: Variable safe print
* `des` + <kbd>⇥</kbd>: Describe object


---


## Lisp

You need to install/activate **Lisp Bundle** from: TextMate > Preferences >
Bundles. Please set `TM_CLISP` variable for executer. You can install from
brew: `brew install clisp`

```bash
# example
defaults write com.macromates.textmate environmentVariables -array-add \
    '{enabled = 1; value = "/usr/local/bin/clisp"; name = "TM_CLISP"; }'
```

### Snippets

* `p` + <kbd>⇥</kbd>: Print

### Commands

* <kbd>⌘</kbd> + <kbd>R</kbd>: Run. 


---


## Elixir

You need to install/activate **Elixir Bundle**:

```bash
cd ~/Library/Application\ Support/TextMate/Bundles/
git clone https://github.com/elixir-lang/elixir-tmbundle.git Elixir.tmbundle
```

### Snippets

* `p` + <kbd>⇥</kbd>: Print or Inspect
* `#`: Select text in quotes then press `#` (*Ruby’s string interpolation-ish*)


---


## General

TAB completion | Description
---------------|:-----------
`dateT` + <kbd>⇥</kbd> | ![Screenshot of: dateT](Screens/general-datet.png?1 "dateT+TAB")
`lorem` + <kbd>⇥</kbd> | ![Screenshot of: lorem](Screens/general-lorem.png?1 "lorem+TAB")
<kbd>⌥</kbd> + <kbd>'</kbd> | Single smart apostrophe. (*Works in html, text, markdown, yaml*)
`applek` + <kbd>⇥</kbd> | Generate apple symbols like: ⌘ ⎋ more...
`applek` + <kbd>⇥</kbd> | Generate apple symbols inside of `<kbd>` tags.
`--` + <kbd>⇥</kbd> | Line delimeter, 80 charts comment `# ---- ...`
`---` + <kbd>⇥</kbd> | Dynamic tilda. Fills remaning line with `~`

---


## Templates

Language      | Scope                 | TAB Completion
:-------------|:----------------------|:--------------------------------
BASH          | source.shell          | `temp` + <kbd>⇥</kbd>
Python        | source.python         | `temp` + <kbd>⇥</kbd>
Python        | source.python         | `temp` + <kbd>⇥</kbd> with Doctests
Golang        | source.go             | `temp` + <kbd>⇥</kbd>
HTML          | -no scope required -  | `html5` + <kbd>⇥</kbd>


---


## Contributer(s)

* [Uğur "vigo" Özyılmazel][contributer-01] - Creator, maintainer

## License

This project is licensed under MIT.

[contributer-01]: https://github.com/vigo
