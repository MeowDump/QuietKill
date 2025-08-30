# QuiteKill Module

QuiteKill is a KernelSU/Magisk module that force-stops background apps to free memory, save battery, and keep your device smooth. It can be triggered automatically when you lock your device using power button or controlled manually through a built-in WebUI.


### Preview

<p align="center">
  <img src="https://raw.githubusercontent.com/MeowDump/MeowDump/refs/heads/main/Assets/ss7.gif" alt="Screenshot 1" width="22%">
  <img src="https://raw.githubusercontent.com/MeowDump/MeowDump/refs/heads/main/Assets/ss8.gif" alt="Screenshot 2" width="22%">
  <img src="https://raw.githubusercontent.com/MeowDump/MeowDump/refs/heads/main/Assets/ss9.png" alt="Screenshot 3" width="22%">
  <img src="https://raw.githubusercontent.com/MeowDump/MeowDump/refs/heads/main/Assets/ss10.png" alt="Screenshot 4" width="22%">
</p>


## Features

- **Automatic App Killer**  
  A short tap of the power button instantly stops all running user apps.  

- **Ignore List**  
  Add package names of apps you want to keep alive. These apps will never be killed.  

- **System App Killer**  
  Pre-installed Google services on non-vanilla ROMs such as Photos, Gmail, Gdrive etc. are system apps and not killed by default. Add them to the Force Kill list if you want them stopped.  

- **WebUI Control Panel**  
  A clean and responsive interface to:  
  - Run the killer on demand  
  - View, filter, copy, and export logs  
  - Manage ignore and force-kill lists  
  - Monitor killed vs. skipped apps in real time  
  - Switch between light and dark themes  

- **Stop Trigger Option**  
  You can disable the power button trigger by clicking on the module's action button if you only want to run QuiteKill manually.


## Stop Logic

1. **User Apps** – All user-installed apps are killed by default  
2. **System Apps** – Only killed if explicitly added to the Force Kill list  
3. **Ignored Apps** – Always protected and never killed, regardless of trigger  


## Installation

- Flash via Magisk, KernelSU, or Apatch  
- Reboot your device  
- Access the WebUI in the module’s webroot  


## Disclaimer

Force-stopping apps may affect notifications, background sync, and system stability.  
Use the ignore list for critical apps and be careful with the system kill list.

