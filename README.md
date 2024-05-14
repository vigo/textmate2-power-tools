![Version](https://img.shields.io/badge/version-2.3.11-orange.svg)
![Plaftorm](https://img.shields.io/badge/platform-TextMate_2_-blue.svg)
![Powered by Rake](https://img.shields.io/badge/powered_by-rake-blue?logo=ruby)


# TextMate2 - Power Tools

This bundle includes most used commands (*on a daily basis*) of me!...

## Installation

```bash
cd ~/Library/Application\ Support/TextMate/Bundles/
git clone https://github.com/vigo/textmate2-power-tools.git PowerTools.tmbundle

# Restart your TextMate2
```

You need to install extra tools for **Golang** helper. You need to enable
default **Go Bundle** from TextMate first...

```bash
$ go install golang.org/x/tools/cmd/goimports@latest
$ go install mvdan.cc/gofumpt@latest
$ go install github.com/segmentio/golines@latest
$ go install golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow@latest
$ go install honnef.co/go/tools/cmd/staticcheck@latest

$ brew install golangci-lint
```

Shellcheck feature requires `shellcheck` binary;

```bash
$ brew install shellcheck
```

You need to add your **brew/bin** path to `PATH` variable too:

```bash
$ command -v golangci-lint
/opt/homebrew/bin/golangci-lint     # my brew/bin is: /opt/homebrew/bin

# add to TextMate variable
PATH /opt/homebrew/bin:${PATH}
```

and you need to set:

- `TM_GOPATH` and `GOPATH` get the value of `$ go env GOPATH`
- `TM_GO` get the value of `$ command -v go`
- `GOMODCACHE` get the value of `$ go env GOMODCACHE`

```bash
$ go env GOPATH           # (example) for TM_GOPATH and GOPATH => /Users/vigo/.local/go
$ go env GOMODCACHE       # (example) for GOMODCACHE  => /Users/vigo/.local/go/pkg/mod
$ command -v go           # (example) for TM_GO  => /opt/homebrew/opt/go/libexec/bin/go

$ defaults write com.macromates.TextMate environmentVariables \
    -array-add "{enabled = 1; value = \"$(command -v go)\"; name = \"TM_GO\"; }"
$ defaults write com.macromates.TextMate environmentVariables \
    -array-add "{enabled = 1; value = \"$(go env GOPATH)\"; name = \"TM_GOPATH\"; }"
$ defaults write com.macromates.TextMate environmentVariables \
    -array-add "{enabled = 1; value = \"$(go env GOPATH)\"; name = \"GOPATH\"; }"
$ defaults write com.macromates.TextMate environmentVariables \
    -array-add "{enabled = 1; value = \"$(go env GOMODCACHE)\"; name = \"GOMODCACHE\"; }"
```

Other bundle dependencies (*not required but nice to have*)

- https://github.com/blahed/Vue.tmbundle
- https://github.com/michaeledgar/protobuf-tmbundle

---

## News

**2023-12-23**

- Remove old django related snippets
- Add new django related snippets (4+)

**2023-06-27**

- Yeah, I’m still developing this bundle
- Add `-` + <kbd>⇥</kbd> create dynamic comment till your wrap column size!

**2023-04-18**

- Add shellcheck disable comment via `dis` + TAB

**2023-01-01**

- Add error tool tip max line length via `TM_ERROR_TOOLTIP_MAX_LINE`

**2022-07-14**

- `golangci-lint` runner checks for `TM_GOLANGCI_LINT_LOG_LEVEL` environment
  variable. Due to `go 1.18`, `golangci-lint` produces some warnings. You can
  bypass those warnings via setting `TM_GOLANGCI_LINT_LOG_LEVEL`. Default is set
  to `error` (no more warnings).

**2022-07-13**

- add `fprf` + <kbd>⇥</kbd>, golang `fmt.Fprintf` snippet.

**2022-06-03**

- `golint` removed, now using `golangci-lint`’s `revive`. (*golint has been archived by the owner*)

---

## Available Items

1. [TextMate](#textMate-helpers)
1. [Django](#django)
1. [Python](#python)
1. [Ruby](#ruby)
1. [Rake](#rake)
1. [Bash](#bash)
1. [Markdown](#markdown)
1. [jQuery](#jquery)
1. [HTML](#html)
1. [Javascript](#javascript)
1. [Go](#go)
1. [Swift](#swift)
1. [Lisp](#lisp)
1. [Elixir](#elixir)
1. [Git](#git)
1. [General](#general)
1. [Templates](#templates)

---

### TextMate Helpers

Scopes:

- `text.xml.plist`
- `source.tm-properties`

- `folder` + <kbd>⇥</kbd> : Add folder for `info.plist`
- `-` + <kbd>⇥</kbd> : Add delimeter for `info.plist`
- `prop` + <kbd>⇥</kbd> : Add properties for `.tm_properties`
   - excludes: `excludeInFolderSearch` / `excludeInFileChooser`
   - includes: `include`
   - spelling: `spellingLanguage`
- "Show Environment Variables" for better, sorted and grouped env-var list

---

### Django

**Update**

- Improve Django snippets/helpers
- Add Django REST generics and viewsets

#### Django Snippets

| TAB completion | Description |
|----------------|:------------|
| `admin` + <kbd>⇥</kbd> | ![Screenshot of: admin](Screens/django-admin-1.png?1 "admin+TAB") |
| `admin` + <kbd>⇥</kbd> | ![Screenshot of: admin](Screens/django-admin-2.png?1 "admin+TAB") |
| `model` + <kbd>⇥</kbd> | ![Screenshot of: model](Screens/django-model.png?1 "model+TAB") |
| `meta` + <kbd>⇥</kbd> (*Model meta options*) |   ![Screenshot of: opt](Screens/django-model-meta.png?1 "meta+TAB") |
| `fld` + <kbd>⇥</kbd> (*For fields...*) | ![Screenshot of: fld](Screens/django-fld.png?1 "fld+TAB") |
| `opt` + <kbd>⇥</kbd> (*For field options...*) | ![Screenshot of: opt](Screens/django-opt.png?2 "opt+TAB") |
| `hlp` + <kbd>⇥</kbd> (*Helpers*) | ![Screenshot of: hlp](Screens/django-hlp.png?2 "hlp+TAB") |
| `str` + <kbd>⇥</kbd> | Injects `def __str__(self):` |
| `save` + <kbd>⇥</kbd> | Injects model save `def save(self, *args, **kwargs):` |
| `does` + <kbd>⇥</kbd> | `Model.DoesNotExist` |
| `wr` + <kbd>⇥</kbd> (*Management commands*) | `self.stdout.write` |
| `ws` + <kbd>⇥</kbd> (*Management commands*) | `self.style` |
| `=` + <kbd>⇥</kbd> (*Template*) | `{{ variable }}` |
| `==` + <kbd>⇥</kbd> (*Template*) | `{% tag %}` |
| `ase` + <kbd>⇥</kbd> (*Test*) | `self.assertQuerysetEqual` |

#### Django Scope

You have a scope called: **Python Django (Extended)**.
Press <kbd>⌃</kbd> + <kbd>⌥</kbd> + <kbd>⇧</kbd> + <kbd>P</kbd> for selecting
this scope.

---

### Python

You can prettify any kind of Python `list` or `dict` via <kbd>⌥</kbd> +
<kbd>⌘</kbd> + <kbd>P</kbd> in any scope!

#### Python Snippets

| TAB completion | Description |
|----------------|:------------|
| `ase` + <kbd>⇥</kbd> | ![Screenshot of: ase](Screens/python-ase.png?1 "ase+TAB") |
| `utf` + <kbd>⇥</kbd> | `# -*- coding: utf-8 -*-` |
| `p` + <kbd>⇥</kbd> | Print with format: `print(CURSOR.format())` |
| `pp` + <kbd>⇥</kbd> | `pp = pprint.PrettyPrinter(indent=4)` |
| `pr` + <kbd>⇥</kbd> | Pretty Print with format: `pp.pprint(CURSOR.format())` |
| `tern` + <kbd>⇥</kbd> | Ternary expression helper |
| `pdbg` + <kbd>⇥</kbd> | Injects Python Debuffer |
| `ipdbg` + <kbd>⇥</kbd> | Injects IPython Debuffer |
| `logger` + <kbd>⇥</kbd> | Injects `logger` snippet |
| `loggerbc` + <kbd>⇥</kbd> | Injects `logger` snippet with basic config |
| <kbd>⌃</kbd> + <kbd>'</kbd> | Docstring |
| `init` + <kbd>⇥</kbd> (*Class*) | Injects `def __init__ ...` |
| `@sm` + <kbd>⇥</kbd> (*Class*) | Injects `@staticmethod` |
| `@cm` + <kbd>⇥</kbd> (*Class*) | Injects `@classmethod` |
| `@pr` + <kbd>⇥</kbd> (*Class*) | Injects `@property` |
| `__` + <kbd>⇥</kbd> (*Class*) | Injects `__str__` or `__repr__` |
| `imp` + <kbd>⇥</kbd> (*import*) | Injects `import` with some predefined package names |
| `inject` + <kbd>⇥</kbd> (*apped*) | Injects `TM_PYTHON_FMT_VIRTUAL_ENV` related appends to `sys.path` |
| `=` + <kbd>⇥</kbd> (*python*) | Injects python placeholder `{}` |
| `.` + <kbd>⇥</kbd> (*doctest*) | Injects `>>> ` |
| <kbd>⇧</kbd> + <kbd>⌘</kbd> + <kbd>i</kbd> | Create `__init__.py` |

`hlp` + <kbd>⇥</kbd>

    from __future__ import unicode_literals
                           print_function
                           division
                           absolute_imports

---

## Ruby

You need to add **Ruby on Rails** bundle from Preferences/Bundles.

### Ruby Snippets for ERB

Scope: `text.html.erb`

| TAB completion | Description |
|---------------|:-------------|
| `=` + <kbd>⇥</kbd> | `<%= CURSOR %>` |
| `if` + <kbd>⇥</kbd> | ERB compatible `if` |
| `each` + <kbd>⇥</kbd> | ERB compatible `each` and `each_with_index` |

---

## Rake

### Rake Snippets

`tas` + <kbd>⇥</kbd>

* Task with args
* Task with args and dependecies
* Task w/o description

* `tasr` + <kbd>⇥</kbd>: Creates remote-task skel
* `tasd` + <kbd>⇥</kbd>: Creates default task code
* `inv` + <kbd>⇥</kbd>: Creates `Rake::Task...invoke` + params
* `des` + <kbd>⇥</kbd>: `desc "...."` only
* `args` + <kbd>⇥</kbd>: `args.with_defaults(...)`

---

## Bash

Added [shellcheck](https://github.com/koalaman/shellcheck) linter/checker support. 
Use `TM_SHELLCHECK_DISABLE` to disable it! You need to install `shellcheck` via;

```bash
brew install shellcheck
```

If you already have `shellcheck`, set binary path to `TM_SHELLCHECK`:

```bash
# custom shellcheck path
defaults write com.macromates.textmate environmentVariables -array-add \
    '{ name = "TM_SHELLCHECK"; enabled = 1; value = "/path/to/shellcheck"; }'

# disable shellcheck
defaults write com.macromates.textmate environmentVariables -array-add \
    '{ name = "TM_SHELLCHECK_DISABLE"; enabled = 1; value = "1"; }'
```

You can disable shellcheck feature on your scripts via `dis` + TAB, this
adds:

```bash
# shellcheck disable=all
```

comment.

You need to restart TextMate after these settings...

### Bash Snippets

* `if` + <kbd>⇥</kbd>: `if` / `else` / `elif` template.
* `for` + <kbd>⇥</kbd>: Array iteration template
* `for` + <kbd>⇥</kbd>: Range iteration template
* `envi` + <kbd>⇥</kbd>: Inject some environment variables.

---

### Markdown

### Markdown Snippets

* `badge` + <kbd>⇥</kbd>: Adds **img.shields.io** badge!
* <kbd>⌥</kbd> + <kbd>(</kbd>: Fixes Parenthesis behavior. 

---

### jQuery

### jQuery Snippets

* `each` + <kbd>⇥</kbd>: jQuery `each` code template
* `ready` + <kbd>⇥</kbd>: jQuery `$(document).ready()` code template
* `plug` + <kbd>⇥</kbd>: jQuery plugin skel.

---

## HTML

### HTML Snippets

* `more` + <kbd>⇥</kbd>: `&rsquo;`
* <kbd>⌃</kbd> + <kbd>⌘</kbd> + <kbd>S</kbd>: Wrap selection with smart quotes.
* <kbd>⌃</kbd> + <kbd>C</kbd>: Wrap/unwrap code Inline
* `p` + <kbd>⇥</kbd>: `<p>carret<p>`
* `li` + <kbd>⇥</kbd>: `<li>carret<li>`

---

### Javascript

### Javascript Snippets

* `con` + <kbd>⇥</kbd>: Generates `console.log`, `console.dir`,
  `console.warn`, `console.error`, `console.group`, `console.groupEnd` skel
* `if` + <kbd>⇥</kbd>: `if` related code.
* `fun` + <kbd>⇥</kbd>: `function` related code.
* `for` + <kbd>⇥</kbd>: `for` related code.
* `swi` + <kbd>⇥</kbd>: `switch` related code.
* `load` + <kbd>⇥</kbd>: Injects `window.addEventListener(...)`

### Javascript Commands

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

When you hit <kbd>⌘</kbd> + <kbd>S</kbd>, TextMate runs unless disabler
environment variable(s) is/are set:

- `gofumpt`
- `gofmt`
- `goimports`
- `golines`
- `go vet` + shadow
- `golangci-lint`
- `staticcheck`

You can disable format/lint feature (*all of them*) via setting
`TM_DISABLE_GO_LINTER` environment variable.

You can disable linters piece by piece;

- `TM_DISABLE_GOFUMPT`
- `TM_DISABLE_GOFMT`
- `TM_DISABLE_GOIMPORTS`
- `TM_DISABLE_GOLINES`

- `TM_DISABLE_GOVET`
- `TM_DISABLE_GOVET_SHADOW`
- `TM_DISABLE_GOLANGCI_LINT`
- `TM_DISABLE_STATIC_CHECK`

Also you can configure `golines` via;

- `TM_GOLINES_MAX_LEN`: Default value is `100`
- `TM_GOLINES_TAB_LEN`: Default value is `4`

environment variables.

Use `TM_GOLANGCI_LINT_LOG_LEVEL` to by-pass linter warnings (`go 1.18` issue):

- `TM_GOLANGCI_LINT_LOG_LEVEL` to `error` shows only errors
- `TM_GOLANGCI_LINT_LOG_LEVEL` to `warning` shows warnings too
- `TM_GOLANGCI_LINT_LOG_LEVEL` to `info` show info level logs

Error tool tip had some issues, due to TextMate’s limit, lines > 150 chars
was broken. Now it’s fixed. Use `TM_ERROR_TOOLTIP_MAX_LINE` environment
variable to set your desired amount. Maximum is `150`.

### Go Commands

* <kbd>⌥</kbd> + <kbd>R</kbd> : Runs `gofmt` + `goimports` without save!

### Go Snippets

* `fmt` + <kbd>⇥</kbd>: `fmt.METHOD`
* `spr` + <kbd>⇥</kbd>: `fmt.Sprintf`
* `prl` + <kbd>⇥</kbd>: `fmt.Println`
* `prf` + <kbd>⇥</kbd>: `fmt.Printf`
* `errf` + <kbd>⇥</kbd>: `fmt.Errorf`
* `tof` + <kbd>⇥</kbd>: `reflect.TypeOf`
* `log` + <kbd>⇥</kbd>: `log.METHOD`
* `if` + <kbd>⇥</kbd>: `if` conditions or `obj, ok` condition
* `for` + <kbd>⇥</kbd>: `for` conditions
* `str` + <kbd>⇥</kbd>: Define `struct`
* `fld` + <kbd>⇥</kbd>: Define `struct` field
* `ctp` + <kbd>⇥</kbd>: Inserts compile time proof fill place holders of `var _ interface = (*struct)(nil)`
* `seed` + <kbd>⇥</kbd>: Inserts random seeder
* `gcil` + <kbd>⇥</kbd>: Creates `.golangci.yml` under current working directory.
* `fprf` + <kbd>⇥</kbd>: `fmt.Fprintf`


`.golangci.yml` default config:

```yaml
run:
  concurrency: 4
  timeout: 1m

linters-settings:
  revive:
    ignore-generated-header: true
    severity: warning
    rules:
      - name: exported
        severity: warning
        arguments:
            - "checkPrivateReceivers"
            - "sayRepetitiveInsteadOfStutters"
      - name: error-return
        severity: warning
      - name: error-naming
        severity: warning
      - name: if-return
        severity: warning
      - name: var-naming
        severity: warning
      - name: var-declaration
        severity: warning
      - name: receiver-naming
        severity: warning
      - name: errorf
        severity: warning
      - name: empty-block
        severity: warning
      - name: unused-parameter
        severity: warning
      - name: unreachable-code
        severity: warning
      - name: redefines-builtin-id
        severity: warning
      - name: superfluous-else
        severity: warning
      - name: unexported-return
        severity: warning
      - name: indent-error-flow
        severity: warning
      - name: blank-imports
        severity: warning
      - name: range
        severity: warning
      - name: time-naming
        severity: warning
      - name: context-as-argument
        severity: warning
      - name: context-keys-type
        severity: warning
      - name: indent-error-flow
        severity: warning
      - name: waitgroup-by-value
        severity: warning
      - name: useless-break
        severity: warning
      - name: struct-tag
        severity: warning

linters:
  disable-all: true
  enable:
    - asciicheck 
    - durationcheck 
    - errcheck 
    - errorlint 
    - exhaustive 
    - gosec 
    - govet 
    - makezero 
    - nilerr 
    - rowserrcheck 
    - exportloopref 
    - sqlclosecheck 
    - staticcheck 
    - typecheck 
    - bodyclose 
    - noctx 
    - prealloc
    - gosimple
  presets:
    - comment 
    - error 
    - format 
    - metalinter 
    - unused

issues:
  exclude-use-default: false
```

You can configure golangci via setting `TM_GOLANGCI_LINT_MANUAL` environment
variable manually w/o config file. Example variable and value:

```bash
TM_GOLANGCI_LINT_MANUAL    -p comment -p error -p format -p metalinter -p unused -E gosimple -E asciicheck -E durationcheck -E errcheck -E errorlint -E exhaustive -E gosec -E govet -E makezero -E nilerr -E rowserrcheck -E exportloopref -E sqlclosecheck -E staticcheck -E typecheck -E bodyclose -E noctx -E prealloc
```

This works only if any of these file(s) is/are unset/not-exists in the project
root:

- `.golangci.yml`
- `.golangci.yaml`
- `.golangci.toml`
- `.golangci.json`

---

## Swift

You need to install/activate **Swift Bundle** from: TextMate > Preferences >
Bundles.

### Swift Snippets

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

### Lisp Snippets

* `p` + <kbd>⇥</kbd>: Print

### Lisp Commands

* <kbd>⌘</kbd> + <kbd>R</kbd>: Run. 

---

## Elixir

You need to install/activate **Elixir Bundle**:

```bash
cd ~/Library/Application\ Support/TextMate/Bundles/
git clone https://github.com/elixir-lang/elixir-tmbundle.git Elixir.tmbundle
```

### Elixir Snippets

* `p` + <kbd>⇥</kbd>: Print or Inspect
* `#`: Select text in quotes then press `#` (*Ruby’s string interpolation-ish*)

---

## Git

Press <kbd>⌥</kbd> + <kbd>⌘</kbd> + <kbd>B</kbd> for;

1. Git blame current line
1. Git blame current line for last N commit

---

## General

| TAB completion | Description |
|----------------|:------------|
| `dateT` + <kbd>⇥</kbd> | ![Screenshot of: dateT](Screens/general-datet.png?1 "dateT+TAB") |
| `lorem` + <kbd>⇥</kbd> | ![Screenshot of: lorem](Screens/general-lorem.png?1 "lorem+TAB") |
| <kbd>⌥</kbd> + <kbd>'</kbd> | Single smart apostrophe. (*Works in html, text, markdown, yaml*) |
| `applek` + <kbd>⇥</kbd> | Generate apple symbols like: ⌘ ⎋ more... |
| `applek` + <kbd>⇥</kbd> | Generate apple symbols inside of `<kbd>` tags. |
| `-` + <kbd>⇥</kbd> | Dynamic comment. Fills remaning line with `-` |
| `--` + <kbd>⇥</kbd> | Line delimeter, 80 charts comment `# ---- ...` |
| `---` + <kbd>⇥</kbd> | Dynamic tilda. Fills remaning line with `~` |
| <kbd>⌥</kbd> + <kbd>⌘</kbd> + `B` | Shows `git blame` for current line |

---

## Templates

| Language        | Scope                 | TAB Completion                  |
|:----------------|:----------------------|:--------------------------------|
| BASH            | source.shell          | `temp` + <kbd>⇥</kbd> |
| Python          | source.python         | `temp` + <kbd>⇥</kbd> |
| Python          | source.python         | `temp` + <kbd>⇥</kbd> with Doctests |
| Python          | source.python         | `temp` + <kbd>⇥</kbd> with Logging |
| Golang          | source.go             | `temp` + <kbd>⇥</kbd> |
| HTML            | -no scope required-   | `html5` + <kbd>⇥</kbd> |
| HTML with Bulma | -no scope required-   | `html5` + <kbd>⇥</kbd> with Bulma.io CSS |
| Vue Component   | text.html.vue         | `temp` + <kbd>⇥</kbd> |

---

## Contributor(s)

* [Uğur "vigo" Özyılmazel][contributer-01] - Creator, maintainer

## License

This project is licensed under MIT.

[contributer-01]: https://github.com/vigo
