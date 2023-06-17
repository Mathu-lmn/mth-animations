# Description 📃 :

👋 Hey guys, I've always wanted to easily test the animations in FiveM and I never really found the script that fits the purpose, so I decided to make my own and today I'm releasing it for free!

This script has been updated for gamebuild mp2023_01 / b2944 / San Andreas Mercenaries thanks to [TayMcKenzieNZ](https://github.com/TayMcKenzieNZ) for the pull request.

Animations found by [DurtyFree](https://github.com/DurtyFree/gta-v-data-dumps) gta v data dumps. 


---
## Usage 🛠️ :

To use the resource, download it, put the `mth-animations` folder in your main resources folder.
Add `start mth-animations` to your server.cfg.
Then, once you're in game, use the command `/animations` to toggle the menu.

<br>

### Config.lua: 
> By changing this to `true` will make the `/animations` command only accessible for **server admins**.
```lua
Config.AdminOnly = false 
```
---
## Features ✨ :
* Accessible json file for all animations dict and names
* Search button to specify what you're looking for
* STANDALONE : this means that you don't need any dependencies to start this script on your server
* Change permissions of the command
* Up to date animations list
* Easy to use

---

*Demo 👀 :*

🎥 [Video](https://streamable.com/yfl6us): https://streamable.com/yfl6us

**Link to the resource :** [mathu-lmn/mth-animations (github.com)](https://github.com/Mathu-lmn/mth-animations)

Feel free to open an Issue or make a PR to help me improve this resource !

*PS : I used this file to get the animations list so huge thanks to @DurtyFree : [gta-v-data-dumps](https://github.com/DurtyFree/gta-v-data-dumps)*