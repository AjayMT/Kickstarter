# Kickstarter
Kickstarter is a small Mac app that will boost your productivity. It does this by creating 'setups' -- lists of apps to launch and a shell script to run. This lets you get in to your workflows much faster -- you don't have to launch the same apps and run the same shell commands every time you want to work.

## Usage
So you need to start working. Maybe you're a web developer. You launch your browser, and launch an editor from the terminal (Emacs!). The problem is, you need to do this every time you start working, and it gets tedious. With Kickstarter, you launch all your apps once, capture a setup (with Kickstarter), and every time you need to work, you just tell Kickstarter to launch the setup. You can also tell setups to run shell scripts, in the shell of your choice.

## Contribute
Kickstarter is free and open source, and you are free to contribute. You'll need [CocoaPods](http://cocoapods.org) to install some dependencies.

```bash
$ git clone http://github.com/AjayMT/Kickstarter.git
$ cd Kickstarter/
$ pod install
$ open KS.xcworkspace
```
