# Myshazam

Tools for handling your Shazam history / dumps.

- [Oto Brglez](http://github.com/otobrglez)

## Installation

Install it as Ruby gem:

    $ gem install myshazam

## Usage

1. Login to your [Shazam](http://www.shazam.com/) account and click on "[downlaod history](http://www.shazam.com/myshazam/download-history)".

2. Convert Shazam history file - myshazam-history.html - into Torrent magnet with "shazam2magnets" command.

    ```
    shazam2magnets ~/Downloads/myshazam-history.html &> magnets.txt
    ```

3. Download files with aria2c client

    ```
    aria2c -i magnets.txt -d ~/Download/MyShazam
    ```

## Contributing

1. Fork it ( https://github.com/otobrglez/myshazam/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
