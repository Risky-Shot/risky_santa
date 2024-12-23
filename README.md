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
- [TRClassic](https://github.com/trclassic92) - Gift Props
