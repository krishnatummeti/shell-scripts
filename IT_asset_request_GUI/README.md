# IT Asset Request GUI Tool

Simple GUI-based script to request IT assets.

## Requirements

- Linux desktop environment
- bash
- zenity
- python3

## Files

- asset_request_gui.sh – main script
- send_email.py – sends email notifications
- inventory.txt – list of available assets
- requests_log.txt – generated log of all requests

## How to Run

1. Install Zenity  
   `sudo apt install zenity` (Debian/Ubuntu)  
   `sudo dnf install zenity` (Fedora/RHEL)

2. Make script executable  
   `chmod +x asset_request_gui.sh`

3. Run the script  
   `./asset_request_gui.sh`

## Notes

- Edit `inventory.txt` to manage assets
- Email settings must be updated in `send_email.py`
- Works only with available items
- Log file is saved as `requests_log.txt`
