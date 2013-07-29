# Postfix module for Puppet

**Manages Postfix configuration.**

This module is provided by [Camptocamp](http://www.camptocamp.com/)

This module requires Augeas.

## Simple usage

    include postfix

    postfix::config { "relay_domains": value  => "localhost host.foo.com" }

## Classes

### postfix

The top-level class, to install and configure Postfix.

## Definitions

### postfix::config

Add/alter/remove options in Postfix main configuration file (main.cf)

### postfix::hash

Creates Postfix hashed "map" files, and build the corresponding db file.

### postfix::transport

Manages content in the transport map.

### postfix::virtual

Manages content in the virtual map.

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/camptocamp/puppet-postfix/issues).

For pull requests, it is very much appreciated to check your Puppet manifest
with [puppet-lint](https://github.com/camptocamp/puppet-postfix/issues) to follow the recommended Puppet style guidelines from the
[Puppet Labs style guide](http://docs.puppetlabs.com/guides/style_guide.html).

## License

Copyright (c) 2013 <mailto:puppet@camptocamp.com> All rights reserved.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

