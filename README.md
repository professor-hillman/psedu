# LBCC - Windows Server

To configure Google Chrome to be the default web browser on Windows Clients, simply add the the `chromedefault.xml` file to a globally accesible fileshare and configure the following Group Policy:

```
- Computer Configuration
  - Policies
    - Administrative Templates
      - Windows Components
        - File Explorer
          - Set a default associations configuration file
```
