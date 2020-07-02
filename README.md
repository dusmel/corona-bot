# Corona WhatApp-Bot Live
> This is a simple whatsapp bot that gives live update about corona, this project came to idea to help people in drc and rwanda with problem of poor internet.

[![Build Status][travis-image]][travis-url] [![Open Source Love](https://badges.frapsoft.com/os/mit/mit.svg?v=102)](https://github.com/ellerbrock/open-source-badge/)


![](https://media.giphy.com/media/SU82JtxLPGYXllSeK4/giphy.gif)

## Development setup and Installation

Make sure you have ruby installed

Clone project

```sh
git clone https://github.com/dusmel/corona-bot.git
```

Move to cloned repo

```sh
cd corona-bot
```

Install dependencies

```sh
bundle
```

Run app

 ```sh
 bundle exec rackup config.ru
```

## Usage

1. First you need a whatsapp account 

2. Join the testing sandbox, by sending a message to +1 415 523 8886 with `join arrow-growth` and voilà!

3. To check different commands send `help`

_For more examples and usage, please refer to the [Wiki][wiki]._



## Release History

* 0.2.1
    * CHANGE: Update docs (module code remains unchanged)
* 0.2.0
    * CHANGE: Remove `setDefaultXYZ()`
    * ADD: Add `init()`
* 0.1.1
    * FIX: Crash when calling `baz()` (Thanks @GenerousContributorName!)
* 0.1.0
    * The first proper release
    * CHANGE: Rename `foo()` to `bar()`
* 0.0.1
    * Work in progress


## Authors

* **Hadad Dus** -  [@dusmel](https://github.com/dusmel)

Twitter: [@dusmel](https://twitter.com/hadad__)

See also the list of [contributors](https://github.com/dusmel/corona-bot/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


## Contributing

1. Fork it (<https://github.com/dusmel/corona-bot/fork>)
2. Create your feature branch (`git checkout -b feat-foobar`)
3. Commit your changes (`git commit -am 'add some foobar'`)
4. Push to the branch (`git push origin feat-foobar`)
5. Create a new Pull Request

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki
