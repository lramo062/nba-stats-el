(require 'request)
(require 'json) 


;; Function that makes NBA API Call
(defun nba-scores (date)
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


;; fetches the games from the JSON response
(defun fetch-games (games)
  (seq-doseq (elt games)
    (print (format-message "%s: %s\n %s: %s"
             ;; Home Team Name
             (assoc-default 'triCode (fetch-team elt 'hTeam))
             ;; Home Team Score
             (sum-score (assoc-default 'linescore (fetch-team elt 'hTeam)))
             ;; Visiting Team Name
              (assoc-default 'triCode (fetch-team elt 'vTeam))
             ;; Visiting Team Score
             (sum-score (assoc-default 'linescore (fetch-team elt 'vTeam)))))))


;; sums up the scores in the associative list
(defun sum-score (line-score)
  (loop for x in (append line-score nil)
        sum (string-to-int (assoc-default 'score x))))


;; fetches the team tricode from the JSON response
(defun fetch-team (game team)
  (assoc-default team game))


(print-buffer
