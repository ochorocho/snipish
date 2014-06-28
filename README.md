# snipish

## Description

Manage code snippets with syntax highlighting, search and tags.

### You can highlight the following syntaxes:

* bash
* html
* php
* js
* css
* typoscript
* ruby
* python
* xml
* sql
* yaml
* sass

## Requirements

* A HTML5 capable browser
* Redmine 2.5.x (2.x not tested)


## Installation

_Clone repository:_

```
git clone https://github.com/ochorocho/snipish.git
```

_Restart Redmine:_

```
cd /your/redmine/root/
touch tmp/restart.txt
```

_Run migration:_

```
cd /your/redmine/root/
rake redmine:plugins:migrate
```


