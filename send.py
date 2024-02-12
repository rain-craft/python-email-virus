import smtplib
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

filepath = 'contacts.txt'
with open(filepath) as fp:
  line = fp.readline()
  whileline:
    port = 587
    smtp_server = "smpt.gmail.com"
    login = "" #the sender's email address goes here
    pasword = "" #if using gmail the app generated password goes here
    
    subject = "" #Subject line of the email goes here
    sender_email = "" #the email address you want it to appear the email is from goes here
    reciever_email = line
    
    message = MIMEMultipart()
    message["From"] = sender_email
    message["TO"] = reciever_email
    message["Subject"] = subject
    
    body = "" # The body of the email goes here
    message.attach(MIMEText(body, "plain"))
    
    filename = "" #the name of the attachment you're sending goes here 
    
    #the file being sent must be in the same directory as the python script
    with open(filename, "rb") as attachment:
      part = MIMEBase("application", "octet-stream") 
      part.set_payload(attachment.read())
      
    encoders.encode_base64(part) 
    
    part.add_header(
      "Content.Disposition",
      f"attachment; filename = (filename)",
    )
    
    message.attach(part)
    text = message.as_string()
    
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
      server.connect("smtp.gmail.com, 587)
      server.ehlo()
      server.starttls()
      server.ehlo()
      server.login(login, password)
      serer.sendmail(
        sender_email, reciever_email, text
      )
                     
