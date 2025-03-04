# Running the example

1. setup: ```./p4app run [PATH TO THIS EXAMPLE]```
2. running commands:
    * ```h1 ./receive.py >> h1.txt &```
    * ```h2 ./send.py 10.0.1.1 "hi"```
    * ```h1 cat h1.txt``` should show the received packet