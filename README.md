# Bistro 42

> Unofficial Vm for 42's remote
>
> Work efficiently to grab a drink before the lockdown 

## Table of Contents

* [About bistro42](#about-bistro42)
  * [Roadmap](#roadmap)
  * [Built With](#built-with)
  * [Security](#security)
    * [Known Bugs](#known-bugs)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
  * [Usage](#usage)
* [Contributing](#contributing)
* [Contact Us](#contact-us)
* [Authors](#authors)
* [Licence](#licence)
* [Acknowledgments](#acknowledgments)
* [References](#references)

## About bistro42

Unofficial VM to work on 42 Cursus

### Roadmap

See the [open issues](https://github.com/thdelmas/bistro42/issues) for a list of proposed features.

### Built-With

Any dependencies should go here, maybe better empty

### Security

#### Known Bugs

Hopefully, this should be empty to

See the [open issues](https://github.com/thdelmas/bistro42/issues) for a list of known issues.

## Getting Started

### Prerequisites

### Installation

```sh
git clone https://github.com/thdelmas/bistro42 # Fetch source files
cd bistro42

# Create the virtualbox vm
./catsansvin.sh '42cursus-libft'
# Or
# ./catsansvin.sh '42cursus-ft_printf,42cursus-get_next_line,42cursus-libft'

```

### Usage

> Warning: Power Off via VirtualBox GUI leads to dataloss (mainly shell history)

- Connect with login: `student` and password: `student`
- Open a shell (`Ctrl` + `alt` + `t`)
- Run `ssh -p 4222 "$USER@127.0.0.1"`


## How to Contribute

We warmly welcome contributions from everyone! Here's how you can get involved:

* **Bug fixes and improvements:** We appreciate any fixes for bugs or ways to improve the project. Feel free to open an issue or submit a pull request. 
* **New features:** Do you have an idea for a new feature? We'd love to hear about it! Open an issue to discuss or create a pull request with your implementation.
* **Documentation:** Help improve the project's documentation by fixing typos, clarifying steps, or adding new content.
* **Testing:**  Writing unit tests helps ensure the project's stability. Consider contributing tests for new features or existing code.

For a detailed guide on contributing, refer to our [CONTRIBUTING.md](CONTRIBUTING.md) file. Additionally, you can find potential bounties for contributions on [Bount.ing](https://bount.ing).

## Sponsorship

We appreciate your support! Here are ways to contribute financially:

* **Become a sponsor:** Support the entire project's development by becoming a sponsor on GitHub. This provides ongoing support and helps us prioritize features and bug fixes.
* **Sponsor specific issues:**  See an issue you care deeply about? You can directly sponsor that specific issue on [Bount.ing](https://bount.ing). This allows you to incentivize a fix or feature addition.

By sponsoring, you directly help us improve and maintain this project. Thank you for your contribution!

## Contact Us

## Authors

* **[thdelmas](https://github.com/thdelmas)** - *Initial design*

## Licence

License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

Thanks to all 42's Staff Members

Thanks to all people spending their time to make a better world

## References

- <https://meta.intra.42.fr>
- <https://guacamole.42.fr>
- [Official VM 🇬🇧 ](https://cdn.42.fr/english-version.ova)
- [Official VM documentation 🇬🇧 ](https://drive.google.com/open?id=1J-3LxhaMrX-EOBVNo0lJaensLJgmGM2O)
- [Official VM 🇫🇷 ](https://cdn.42.fr/xubuntu-42.ova)
- [Official VM documentation 🇫🇷 ](https://drive.google.com/open?id=1FldhyDrknoxWUG9g5KhrS1QeJ_twShjD)

- [Unattended linux install](https://github.com/coreprocess/linux-unattended-installation)
