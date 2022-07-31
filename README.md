# sqlmonitor.sh


- [sqlmonitor.sh](#sqlmonitorsh)
  - [Started 🚀](#started-)
    - [Examples](#examples)
  - [Prerequisites 📋](#prerequisites-)
    - [SQLCMD](#sqlcmd)
    - [WSL](#wsl)
    - [WSL-NOTIFY-SEND](#wsl-notify-send)
  - [Test ⚙️](#test-️)
    - [Example 1](#example-1)
  - [Wiki 📖](#wiki-)
  - [Version 📌](#version-)
  - [Authors ✒️🖇️🛠️](#authors-️️️)
  - [License 📄](#license-)
  - [Expressions of Gratitude 🎁](#expressions-of-gratitude-)

## Started 🚀

Script in **bash**. Checks an array of instance of MS Sql Server to verify Errores, Locks, Capacity, Database.


> Use for encrypt pasword [https://github.com/DavidBaezDbz/encriptPassword](https://github.com/DavidBaezDbz/encriptPassword)

> Use a script for the windows [https://github.com/metal3d/bashsimplecurses](https://github.com/metal3d/bashsimplecurses)

### Examples

```sh
    bash sqlmonitor.sh 
```
> Checks every 5 seconds without creating tests and don't validate the prerequisites.





## Prerequisites 📋

**The script validate the existense of the software:**

1. sqlcmd




### SQLCMD

Install **postfix**,  it's important to install and configure **POSTFIX** after do you try to send the email.

```sh
    sudo apt update
    sudo apt-get install postfix
```

Review the next page, works for me. [https://tonyteaches.tech/postfix-gmail-smtp-on-ubuntu/](https://tonyteaches.tech/postfix-gmail-smtp-on-ubuntu/)

Second password for you account gmail [https://www.youtube.com/watch?v=J4CtP1MBtOE](https://www.youtube.com/watch?v=J4CtP1MBtOE)


### WSL

Install **wsl2** on your **windows 11**

1. Run Windows Terminal as administrator.

```
    wsl --install
```
2. Install a GNU/Linux distribution from those available in the Microsoft application store.

[Ubuntu 20.04](https://apps.microsoft.com/store/detail/ubuntu-2204-lts/9PN20MSR04DW?hl=es-co&gl=CO)
> The tests were on this version

3. Restart our computer to be able to start the Ubuntu installation.

4. Running the Ubuntu application and follow the steps

[Microsoft Documentation](https://docs.microsoft.com/es-es/windows/wsl/install)


### WSL-NOTIFY-SEND

Install **wsl-notify-send**

- Download your version [https://github.com/stuartleeks/wsl-notify-send/releases](https://github.com/stuartleeks/wsl-notify-send/releases)
- Extract wsl-notify-send.exe from the downloaded zip and ensure that it is in your `PATH`
- **Testing** In WSL, run `notify-send "Hello from WSL"` and you should see a Windows toast notification!

> `wsl-notify-send` provides a Windows executable that is intended to be a replacement for the [Linux `notify-send` utility](https://ss64.com/bash/notify-send.html).

[https://github.com/stuartleeks/wsl-notify-send](https://github.com/stuartleeks/wsl-notify-send)

```



## Instalación 🔧

Clone my repository and enjoy.

```
git clone git@github.com:DavidBaezDbz/bashsql.git
```

Give permison to the bash

```sh
chmod a+x sqlmonitor.sh
```
or execute whit `bash` command

```sh
bash sqlmonitor.sh 
```
> Checks every 5 seconds 

And the las step, is fill the file email and websitecheck

**email**
```
xxxxx@domain.com,xxxxx1@domain.com
```
**sqlcheck**
```
127.0.0.1|Local|Local (127.0.0.1 Docker)|MonitorBash
```

Example

```sh
bash sqlmonitor.sh 
```
> Checks every 5 Seconds
> 

## Test ⚙️

### Example 1

Execute the bash

```sh
    bash sqlmonitor.sh 
```
> Checks every 5 seconds 


**IF YOU HAVE PROBLEMS WITH THE SQLCMD**




## Wiki 📖

You can find out much more about how to use this project in our [Wiki](https://github.com/DavidBaezDbz/sqlmonitor/wiki)

## Version 📌

In the fiture a will use [SemVer](http://semver.org/) for versioning. For all available versions, see the [tags en este repositorio](https://github.com/DavidBaezDbz/sqlmonitor/tags).

## Authors ✒️🖇️🛠️


* **David Baez Sanchez** - *Initial Work* - [DBZ repository](https://github.com/DavidBaezDbz) - [David Baez](https://davidbaezdbz.github.io/)


## License 📄

Working on this  - see the file [LICENSE.md](LICENSE.md) for details

## Expressions of Gratitude 🎁

* Tell others about this project 📢
* Invite for a beer 🍺 or a coffee ☕ to someone on the team.. 
* Publicly thanks 🤓.
* Anything you want.
