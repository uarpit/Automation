# Automation
My learnings about Jenkin automation with Accurev repository

Accurev:

Login to Accurev: accurev login '<Username>' '<Password>'
Keep the files in Accurev: accurev keep -c "test comment" -l C:\Filelist.txt
Promote to Dev from Workspace: accurev promote -c "test comment" -l C:\Filelist.txt
Promote from stream to stream: accurev promote -c '<Comment>' -s '<FromStream>' -S '<ToStream>' -l "C:\Filelist.txt"
Check the status in any stream for objects in a given list:accurev files -s <Stream> -l "C:\Filelist.txt"
Find all the files which do not have status as member: accurev files -s <Stream> -l "C:\Filelist.txt" | C:\Windows\System32\find /v /i "member"
List all the users in a given group: accurev show -g <Group name> members
Add members to a group: accurev addmember <members> <group>

Configuring SSH RSA key:

Step 1: Open Putty keygen
Step 2: Select Type of key to generate: SSH2-RSA
Step 3: Click Generate and Hover mouse in blank area for randomness
Step 4: Save Private key, Key fingreprint (and Public key just in case) on Windows machine.
Step 5: Copy the public key into ~/.ssh/authorized_keys file.
Note: It should be done in the home directory of the ID that is trying to connect using ssh-rsa key.
Step 6: While connecting from Putty, give the private key path in Connection > SSH > Auth > Private Key file for authentication section
Voila! It should connect without asking for password

Connecting from Dos though winscp to UNIX server and sending a sample file to UNIX
"C:\Program Files (x86)\WinSCP\winscp.com" /command "open sftp://<UserName>:<LinuxPassword>@<Full Server Name>/" "put path\to\source\file /path/to/destination/folder" "exit"

Dos:

Dos command to list all the files in a folder: dir/s/b



