;;; nba-stats.el --- Fetches up-to date NBA scores and stats from NBA.com.

;; Copyright (C)
;;   2016-Present Lester Ramos
;; Author: Lester Ramos <lramo062@fiu.edu>
;; Created: 2016-12-27
;; Version: 0.0.1
;; Keywords: nba, scores, stats
;; Homepage: https://github.com/lramo062/nba-stats

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:
;;
;; Nba-stats is a small script that fetches real time scores or stats
;; for the current NBA Season.
;;
;; This script depends on NBA's internal API's that I have traced through
;; NBA.com's network XHR Requests.  If any formatting in the JSON or URL path
;; changes, then unfortunately this script is of no use and will need to be
;; updated accrodingly.

;;; Installation:

;; 1. Place nba-stats.el on your Emacs load-path.
;;
;; 2. Compile the file (necessary for speed):
;; M-x byte-compile-file <location of nba-stats.el>
;;
;; 3. Add the following to your dot-emacs/init file:
;; (require 'nba-stats)
;;
;; - Call the function of choice:
;; M-x nba-scores
;; M-x nba-player-stats

;;; TODO: Query for individual player/team season stats

;;; Code:

;;; Customize interface:

;; (require 'request)
;; (require 'json)

;;; Code:

;; NBA Game Scores ------------------------------------------------------------------

(defun nba-scores (date)
  "Return the NBA Scores for a given Date (as DATE)."
  (interactive "sEnter date YYYYMMDD:")
  (request
   (concat "http://data.nba.net/data/10s/prod/v1/" date "/scoreboard.json")
   :type "GET"
   :parser 'json-read
   :success (cl-function
             (lambda (&key data &allow-other-keys)
               (with-output-to-temp-buffer "*nba-scores*"
                 (fetch-games (assoc-default 'games data))
                 (switch-to-buffer "*nba-scores*"))))
   :error (message "Error Making HTTP Request")))



(defun fetch-games (games)
  "Prints team name and score for each game (as GAMES)."
  (seq-doseq (x games)
    (print (format-message "%s: %s\n %s: %s"
                           ;; Home Team Name
                           (assoc-default 'triCode (fetch-team x 'hTeam))
                           ;; Home Team Score
                           (sum-score (assoc-default 'linescore (fetch-team x 'hTeam)))
                           ;; Visiting Team Name
                           (assoc-default 'triCode (fetch-team x 'vTeam))
                           ;; Visiting Team Score
                           (sum-score (assoc-default 'linescore (fetch-team x 'vTeam)))))))



(defun sum-score (line-score)
  "Sums up the scores in the associative list (as LINE-SCORE)."
  (loop for x in (append line-score nil)
        sum (string-to-int (assoc-default 'score x))))


(defun fetch-team (game team)
  "Fetches games (as GAME) along with the teams (as TEAM) either hTeam or vTeam."
  (assoc-default team game))



;; NBA Daily Player/Team Leaderboards ------------------------------------------------------------

;; NBA JSON is structured the same for both season/daily & player/team stats so this
;; function works with the JSON arrays and checks the object properties as the condition to
;; call the correct function.
;; Used by both the list-player-stats & list-team-stats to
;; fetch the stats. Argument TYPE is actually the name of one of the two above functions and will
;; be called with funcall. 
(defun get-data (data type)
  "Fetches the daily stats (as DATA) depending on either team/palyer stats (as TYPE)."
  (seq-doseq (x (append data nil))
    (cond ((equal "Points" (assoc-default 'title x)) (print (format-message "Points: %S" (funcall type x 'PTS))))
          ((equal "Points Per Game" (assoc-default 'title x)) (print (format-message "Points Per Game: %S" (funcall type x 'PTS))))
          ((equal "Rebounds" (assoc-default 'title x)) (print (format-message "Rebounds: %S" (funcall type x 'REB))))
          ((equal "Rebounds Per Game" (assoc-default 'title x)) (print (format-message "Rebounds Per Game: %S" (funcall type x 'REB))))
          ((equal "Assists" (assoc-default 'title x)) (print (format-message "Assists: %S" (funcall type x 'AST))))
          ((equal "Assists Per Game" (assoc-default 'title x)) (print (format-message "Assists Per Game: %S" (funcall type x 'AST))))
          ((equal "Blocks" (assoc-default 'title x)) (print (format-message "Blocks: %S" (funcall type x 'BLK))))
          ((equal "Blocks Per Game" (assoc-default 'title x)) (print (format-message "Blocks Per Game: %S" (funcall type x 'BLK))))
          ((equal "Steals" (assoc-default 'title x)) (print (format-message "Steals: %S" (funcall type x 'STL))))
          ((equal "Steals Per Game" (assoc-default 'title x)) (print (format-message "Steals Per Game: %S" (funcall type x 'STL))))
          ((equal "Turnovers" (assoc-default 'title x)) (print (format-message "Turnovers: %S" (funcall type x 'TOV))))
          ((equal "Three Pointers Made" (assoc-default 'title x)) (print (format-message "Three Pointers Made: %S" (funcall type x 'FG3M))))
          ((equal "Free Throws Made" (assoc-default 'title x)) (print (format-message "Free Throws Made: %S" (funcall type x 'FTM))))
          ((equal "Fantasy Points" (assoc-default 'title x)) (print (format-message "Fantasy Points: %S" (funcall type x 'FANTASY_POINTS))))
          ((equal "Fantasy Points Per Game" (assoc-default 'title x)) (print (format-message "Fantasy Points Per Game: %S" (funcall type x 'FANTASY_POINTS))))
          ((equal "Field Goal Percentage" (assoc-default 'title x)) (print (format-message "Field Goal Percentage: %S" (funcall type x 'FG_PCT))))
          ((equal "Three Point Percentage" (assoc-default 'title x)) (print (format-message "Three Point Percentage: %S" (funcall type x 'FG3_PCT))))
          ((equal "Free Throw Percentage" (assoc-default 'title x)) (print (format-message "Free Throw Percentage: %S" (funcall type x 'FT_PCT)))))))


(defun list-player-stats (data stat-type)
  "Helper function to get-daily-player-stats.
Lists the player names (as DATA) & stat-value depending on Stat-Type (as STAT-TYPE)."
  (loop for x in (append (assoc-default 'playerstats data) nil)
        collect (list (assoc-default 'PLAYER_NAME x) (assoc-default stat-type x))))


(defun list-team-stats (data stat-type)
  "Helper function to get-daily-team-stats.
Lists the team names (as DATA) & stat-value depending on Stat-Type (as STAT-TYPE)."
  (loop for x in (append (assoc-default 'teamstats data) nil)
        collect (list (concat (assoc-default 'TEAM_CITY x) " " (assoc-default 'TEAM_NAME x)) (assoc-default stat-type x))))


(defun nba-daily-player ()
  "Return all the daily leading player stats with respect to the stat-type."
  (interactive)
  (request
   "http://stats.nba.com/js/data/widgets/home_daily.json"
   :type "GET"
   :parser 'json-read
   :success (cl-function
             (lambda (&key data &allow-other-keys)
               (with-output-to-temp-buffer "*nba-daily-player-stats*"
                 (get-data (assoc-default 'items (aref (assoc-default 'items data) 0)) 'list-player-stats))))
   :error (message "Error Making HTTP Request")))

(defun nba-daily-team ()
  "Return all the daily leading team stats with respect to the stat-type."
  (interactive)
  (request
   "http://stats.nba.com/js/data/widgets/home_daily.json"
   :type "GET"
   :parser 'json-read
   :success (cl-function
             (lambda (&key data &allow-other-keys)
               (with-output-to-temp-buffer "*nba-daily-team-stats*"
                 (get-data (assoc-default 'items (aref (assoc-default 'items data) 1)) 'list-team-stats))))
   :error (message "Error Making HTTP Request")))

(defun nba-season-player ()
  "Return all the season leading player stats with respect to the stat-type."
  (interactive)
  (request
   "http://stats.nba.com/js/data/widgets/home_season.json"
   :type "GET"
   :parser 'json-read
   :success (cl-function
             (lambda (&key data &allow-other-keys)
               (with-output-to-temp-buffer "*nba-season-player-stats*"
                 (get-data (assoc-default 'items (aref (assoc-default 'items data) 0)) 'list-player-stats))))
   :error (message "Error Making HTTP Request")))

(defun nba-season-team ()
  "Return all the season leading player stats with respect to the stat-type."
  (interactive)
  (request
   "http://stats.nba.com/js/data/widgets/home_season.json"
   :type "GET"
   :parser 'json-read
   :success (cl-function
             (lambda (&key data &allow-other-keys)
               (with-output-to-temp-buffer "*nba-season-team-stats*"
                 (get-data (assoc-default 'items (aref (assoc-default 'items data) 1)) 'list-team-stats))))
   :error (message "Error Making HTTP Request")))



(provide 'nba-stats)
;;; nba-stats.el ends here
