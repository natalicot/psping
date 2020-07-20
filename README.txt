psping [-c ###] [-t ###] [-u user-name] exe-name
Counts and echos number of live processes for a user, whose executable file is exe-name.
Repeats this every second indefinitely, unless passed other specifications using switches:
-c - limit amount of pings, e.g. -c 3. Default is infinite
-t - define alternative timeout in seconds, e.g. -t 5. Default is 1 sec
-u - define user to check process for. Default is ANY user.
