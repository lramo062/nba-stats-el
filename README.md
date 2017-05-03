# nba-stats

An emacs package that fetches realtime NBA stats within Emacs.
Nba.com does not have a public API for fetching realtime stats, and is pretty challenging to scrape 
but with a-little bit of snooping through the websites' XMLHttpRequest I found their call to the internal API.

![Alt text](https://github.com/lramo062/emacs-nba-scores/blob/master/img/Screenshot%20from%202016-12-19%2011-48-46.png)
![Alt text](https://github.com/lramo062/emacs-nba-scores/blob/master/img/Screenshot%20from%202016-12-19%2011-48-26.png "Here's a screen shot:")


## Getting Started

* Include nba-stats.el in your .emacs. 
* Run M-x nba-scores, then enter desired date for scores (YYYYMMDD)
* Run M-x nba-daily-player to fetch daily player leaderboards
* Run M-x nba-daily-team to fetch daily team leaderboards
* Run M-x nba-season-player to fetch season player leaderboards
* Run M-x nba-season-team to fetch season team leaderboards

### Prerequisites

Depends on request.el & json.el


### Installing

Clone https://github.com/lramo062/nba-scores-stats and require nba-stats.el in your .emacs


## Todo

* Fetching individual player/team stats given the player/team name

## Contributing

Feel free to contribute to the project!

## Authors

* **Lester Ramos** - *Initial work* - [lramo062](https://github.com/lramo062)

See also the list of [contributors](https://github.com/lramo062/emacs-nba-scores/contributors) who participated in this project.

## License

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

## Acknowledgments

* Those who contribute to request.el & json.el documentation
* Those who contribute to ELisp documentation 
