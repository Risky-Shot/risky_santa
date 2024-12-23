# Risky Santa

**Risky Santa** is a FiveM script that brings holiday cheer to your server by providing gifts to logged-in players at various locations in the city. Players can find small and large gift boxes at specified time intervals, each containing different items.

## Features

- Gift Distribution: Gifts appear at random locations across the city at specified time intervals.

- Gift Types: Two types of gifts:

  - Small Gift Box: Configurable.

  - Large Gift Box: Configurable.

- Customizable Locations: Add or modify the locations where gifts spawn.

- Configurable Intervals: Adjust the time interval between gift spawns.

## Installation

- Download the script from this repository.

- Place the `risky_santa` folder into your FiveM server's resources directory.

- Add the following line to your server.cfg file:

  ```ensure risky_santa```
- Add items from `install/items.lua` to `ox_inventory/data/items.lua` file.

- Start or restart your FiveM server.

## Usage

- Gifts will spawn automatically at the configured locations and intervals.

- Players can walk up to a gift and interact with it to claim the items.

- Notifications will inform players when and where gifts are available.

## Requirements
- qbx_core
- ox_lib
- ox_inventory

## Special Thanks : 
- [TRClassic](https://github.com/trclassic92) - [Christmas Props](https://github.com/trclassic92/tr_christmas_props_2024)

This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0
International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

