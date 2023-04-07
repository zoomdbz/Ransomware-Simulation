# Ransomware-Simulation
This requires Domain Admin and runs on the Domain Controller to simulate a ransomeware attack by writing a txt file to C:\ on every computer on the network. 
It gets a list of all computers in the domain, checks if they are online, and then creates the file on the remote computer using a background job. It also includes an error log file to record any failures.
