
**LINUX OS PROJECT**
**User Management Automation – SysOps Challenge**

Overview
This project automates Linux user account creation using a shell script named create_users.sh.
It reads a text file containing usernames and groups, creates users, generates passwords, assigns groups, configures home directories, and stores credentials and logs securely.
This solution is useful in SysOps and DevOps environments for onboarding many users quickly and consistently.

Input File Format
Each line in the input file must follow this format:

username;group1,group2,group3

Example:
light; sudo,dev,www-data
siyoni; sudo
manoj; dev,www-data

Rules:
Lines beginning with # are ignored.
Whitespace is ignored.
The username comes before the semicolon.
Groups are comma-separated.

Script Features
The create_users.sh script performs the following tasks:

Reads usernames and groups from a file (default file name: user-man).

Skips comment lines and empty lines.

Removes extra whitespace.
Creates Linux user accounts.
Creates a home directory if missing.
Sets home directory permissions to 700.

**Creates missing groups.**
Adds users to the required groups.
Generates a secure 12-character random password.

**Sets the user password.**
Saves credentials to /var/secure/user_passwords.txt with permission 600.
Logs all operations to /var/log/user_management.log with permission 600.
Handles existing users and groups safely.
Shows clear messages during execution.

**Requirements**
To run the script, you need:
A Linux system (Ubuntu, Debian, CentOS, Rocky, WSL)
Root privileges (use sudo)
Basic Linux knowledge

**How to Use the Script**
**Steps:**
Place create_users.sh in your project directory.
Create a file named user-man with a list of users.
Make the script executable using:
chmod +x create_users.sh

Run the script:
sudo ./create_users.sh

To use a different input file:
sudo ./create_users.sh filename.txt

**Output Locations**
User passwords:
/var/secure/user_passwords.txt
Log file:
/var/log/user_management.log
Home directories:
/home/username

**Verifying the Results**
Check if a user was created:
id username
Check home directory permissions:
ls -ld /home/username
Check password file:
sudo cat /var/secure/user_passwords.txt
Check log file:
sudo tail /var/log/user_management.log

**Security Considerations**
Passwords are saved in plaintext but protected using permission 600.
Input files should remain private and not be committed to version control.
Users should change their initial passwords after first login.
Logging includes sensitive account actions and must remain root-only.
In production, consider replacing plaintext password storage with a secrets manager.

**Example Input File**
kilaru; sudo,dev
venkatesh; sudo
sandy; www-data
ram; dev,www-data

**Example Script Output**
 Processing user: sandy
 Created user: sandy
 Added 'sandy' to group 'www-data'
 Password set for 'sandy'
User creation complete.
**Script Purpose Summary**
The script ensures that user onboarding is automated, secure, consistent, logged, and repeatable.
It eliminates manual user creation and enforces proper permissions and security practices.
