# lynrco/longview

## Description

Add linode-longview source list and GPG key then install and start the
linode-longview service. The steps for installation are derived from the
documentation provided in the [Linode Library Longview article][3La].

## Usage

To use the module include

```
  class { 'longview':
    api_key => 'longview api key',
  }
```

in the site's node definition, where 'longview api key' is replaced with
the Longview API Key from the Longview node's settings page, like
`https://manager.linode.com/longview/settings/nodename` as shown in step
15 of [Linode Library Longview article][3La].

[3La]: https://library.linode.com/longview
