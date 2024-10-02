---
title: Setting Environment Variables !!!
author: vivekragunathan
layout: post
date: 2006-03-27T00:11:00+00:00
url: /2006/03/27/setting-environment-variables/
categories:
  - Uncategorized

---
Need to change or set the value of an environment variable programmatically and without the need to restart/log off the machine. I need the change to reflect for all processes, ie, I need to change the global environment value and not the one in the PEB [Process Environment Block] of a process. Frustated with setting the value of an environment variable !!!

For getting the set of environment variables or to get the value of an environment vaible from your C# program, there is the GetEnvironmentVariables/GetEnvironmentVariable API in the System.Environment class. But there is no API for setting the value of an environment variable.

The system environment variables are stored in the registry under HKEY\_LOCAL\_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment.

The [current] user environment variables are stored in the registry under HKEY\_CURRENT\_USERE\Environment.

When the system boots up, the environment is built from this list in the registry. If we change the value directly in the registry, the change does not effect. For example, change the value of TEMP variable that specifies the temporary files directory, in the registry and check with the set command in the command prompt, you won&#8217;t see the change you made. Or just create a new entry in the registry under the one of the above mentioned registry paths, you won&#8217;t see the change. Also you can verify that programmatically with GetEnvironmentVariable API.

But the changes you made will be reflected after a log off or restart. After some research, I found the Win32 SDK API SetEnvironmentVariable. But unfortunately, it just the changes the variable value in the PEB of that process alone, it does not effect the global environment values. Pathetic.

There is definitely a solution for this simple and primary problem. All we have to do is to update the registry as we discussed before, and also notify that the global enviroment variable list has been modified. Ok, how do we do that ?

Simple, one line of code.

```cpp
// Broadcast the WM_SETTINGCHANGE message for Enviroment</span>
SendMessageTimeout(
  HWND_BROADCAST, 
  WM_SETTINGCHANGE, 
  0,
  (LPARAM) “Environment”,
  SMTO_ABORTIFHUNG,
  5000,
  &dwReturnValue
);
```

Of course, this is C++ code. Not a big deal to do that in C# or whatever.
