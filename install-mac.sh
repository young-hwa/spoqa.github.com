#!/bin/sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install ruby
sudo gem install github-pages
echo "You can run the server by using 'jekyll serve'."
