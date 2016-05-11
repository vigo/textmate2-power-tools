# TextMate2 - Power Tools

This bundle includes most used commands (on a daily basis). Trying to migrate
my old TextMate1 stuff here...

## Installation

```bash
cd "~/Library/Application Support/Avian/Bundles/"
# if you don’t have Avian/Bundles folder, you need to create it!

git clone https://github.com/vigo/textmate2-power-tools.git textmate2-power-tools.tmbundle
# reload your TextMate2
```

## Available Items

### Django / admin.ModelAdmin

* `actions_on_top`:
* `date_hierarchy`:
* `empty_value_display (1_9)`:
* `exclude`:
* `fields (multiple)`:
* `fields`:
* `filter_horizontal/vertical`:
* `form`:
* `formfield_overrides`:
* `inlines`:
* `list_display`:
* `list_display_links`:
* `list_filter`:
* `list_max_show_all`:
* `list_per_page`:
* `list_select_related`:
* `ordering`:
* `prepopulated_fields`:
* `radio_fields`:
* `raw_id_fields`:
* `readonly_fields`:
* `search_fields`:
* `show_full_result_count`:
* `view_on_site`:


### Markdown

* `code`: Generates backtick code block for ruby, bash, python, css, js
* `kntrl+c`: Inline code (wraps with backticks)
* `alt+shift+2`: Generates: `’`
* `table`: Generates table code.

### Javascript

* `con`: Generates `console.log`, `console.dir`, `console.warn`, `console.error`
* `for`, `if`, `swi`

### jQuery

* `plugin`: Generates jQuery plugin skel.
* `each`, `ready`

### HTML

* `alt+shift+2`: Generates: `&rsquo`

### Rake

* `tasr`: New remote task
* `tasd`: Default task
* `inv`: Invoke task

### Text

* `lorem`: Generates various Lorem Ipsum texts.

### Middleman

* `more`: Generates `READ_MORE`

### General: Date and Time

* `dateT`: Generates various date and time formats in Turkish.

### Templates

* Bash Script Template, `temp` generates Bash Script Scaffold.

## Change Log

**2016-05-11**

* added: Python `init` and `utf` snippets
* added: Rake helpers

**2016-03-28**

* added: admin.ModelAdmin helpers

**2016-03-28**

* added: `temp` for `source.shell` scope.

**2016-03-24**

* added: HTML snippets
* added: Date and Time snippets
* added: Markdown / table snippet
* added: Javascript snippets added
* added: Text snippets (Lorem Ipsum)
* added: Custom lib, dji18njs snippets
* added: jQuery snippets

**2016-03-20**

* Initial commit

## Contributer(s)

* [Uğur "vigo" Özyılmazel][contributer-01] - Creator, maintainer

## License

This project is licensed under MIT.

[contributer-01]: https://github.com/vigo