# emacs-nba-scores

An emacs package that fetches realtime NBA scores within Emacs.
Nba.com does not have a public API for fetching realtime scores, and is pretty challenging to scrape 
but with a-little bit of snooping through the websites' XMLHttpRequest I found their call to the internal API.

Here's a screen shot:


## Getting Started

Include nbaScores.el in your .emacs. 
Run M-x nba-scores, then enter desired date for scores (YYYYMMDD)

### Prerequisites

Depends on request.el & json.el


### Installing

Clone https://github.com/lramo062/emacs-nba-scores and require nbaScores.el in your .emacs


## Deployment

I plan to continue to work on this project and in the future include Player stats, Team stats, etc..


## Contributing

Feel free to contact be about contributing to the project!

## Authors

* **Lester Ramos** - *Initial work* - [lramo062](https://github.com/lramo062)

See also the list of [contributors](https://github.com/lramo062/emacs-nba-scores/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Those who contribute to request.el documentation
* Those who contribute to Elisp documentation 
