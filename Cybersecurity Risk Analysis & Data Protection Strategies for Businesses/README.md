 Business Overview/Problem

The prevailing business challenge faced by LOCK CO. is the increasing sophistication of cyber threats and the need to protect sensitive data and infrastructure from potential breaches. Specific obstacles include:
 

    ✓ Frequent attempts by malicious actors to infiltrate the company's systems and steal valuable data.
    ✓ Growing concerns from clients about the security of their data and infrastructure under LOCK CO. management.
    ✓ The evolving regulatory landscape, with stricter data protection and cybersecurity compliance requirements.
    ✓ The need to maintain client trust and preserve the company's reputation amid rising cybersecurity threats.
    ✓ Ensuring business continuity in the face of potential cyberattacks.

Addressing these challenges requires a comprehensive cybersecurity risk analysis and the implementation of robust protective measures.
Rationale for the Project

    The significance of initiating this project is underscored by the following reasons:
     
        ✓ Protection of Sensitive Data: As a technology company handling vast amounts of sensitive client data, safeguarding this information is paramount. A breach could result in significant financial losses and reputational damage.
        ✓ Compliance Requirements: Adherence to evolving cybersecurity regulations is essential. Non-compliance could result in severe penalties and legal consequences.
        ✓ Client Trust: Maintaining client trust is a core value for LOCK CO. Demonstrating a commitment to cybersecurity enhances client confidence.
        ✓ Business Continuity: Cyberattacks can disrupt operations. Mitigating risks ensures uninterrupted service delivery.
        ✓ Reputation Management: Protecting the company's reputation is crucial in a highly competitive industry. Demonstrating robust cybersecurity practices enhances the company's image
         

Aim of the Project

The project aims to achieve the following objectives:

 

    ✓ Conduct a comprehensive cybersecurity risk assessment to identify vulnerabilities and threats.
    ✓ Develop a cybersecurity strategy tailored to the Corporation's unique needs and risk profile.
    ✓ Implement cybersecurity measures to protect sensitive data and infrastructure.
    ✓ Ensure compliance with relevant cybersecurity regulations.
    ✓ Enhance incident response and recovery capabilities.

Data Description

    The network_logs1: dataset contains logs of network activities, capturing details like source and destination IP addresses, traffic type, protocol, and security features like firewall rules and encryption algorithms.
    The network_logs2: dataset focuses on security attributes of network connections, detailing the type of threats, connection statuses, severity levels, and various flags for identifying malicious activities.
    The user_behavior_data: dataset tracks individual user activities, such as activity count, timestamps, and metrics related to email and downloads, aiming to identify suspicious behavior.


network_logs1 Dataset:

    ✓ ID: Unique identifier for each log entry.
    ✓ Source_IP: The IP address where the network traffic originates.
    ✓ Destination_IP: The IP address to which the network traffic is directed.
    ✓ Protocol: The network protocol used, such as TCP, UDP, or ICMP.
    ✓ Timestamp: The date and time when the log was generated.
    ✓ Traffic_Type: Specifies whether the traffic is Inbound or Outbound.
    ✓ Source_Port: Port number from where the traffic originates.
    ✓ Destination_Port: Port number at which the traffic is aimed.
    ✓ Data_Volume: The amount of data transferred in bytes.
    ✓ Packet_Size: The size of the network packet in bytes.
    ✓ HTTP_Status_Code: The HTTP status code like 200, 404, or 500.
    ✓ Firewall_Rule: Status of the firewall rule applied, such as Allow, Deny, or Quarantine.
    ✓ VPN_Status: Indicates if the VPN is enabled (True) or disabled (False).
    ✓ MFA_Status: Multi-Factor Authentication status; options include Used, Failed, or Bypassed.
    ✓ Credential_Used: Password or credential used for authentication.
    ✓ Data_Classification: Classification of the data being transferred, such as Public or Confidential.
    ✓ Encryption_Algorithm: The encryption algorithm used like AES, RSA, or SHA-256.

    network_logs2 Dataset:
    ✓ Linked_ID:Unique identifier for each log entry..
    ✓ Threat_Type: Type of security threat like Malware, DDoS, or Phishing.
    ✓ Connection_Status: Indicates if the connection is Blocked or Allowed.
    ✓ Severity_Level: Severity level of the threat, options are Low, Medium, High, or Critical.
    ✓ Flagged: Indicates if the traffic was flagged as potentially malicious (True or False).
    ✓ Payload_Data: Additional payload data, left empty in your script.
    ✓ Device_Type: Type of device involved in the network activity.
    ✓ Application: Application involved in generating the traffic.
    ✓ Notes: Additional notes, left empty in your script.
    ✓ External_Internal_Flag: Specifies if the traffic is external or internal.
    ✓ Service_Name: Name of the network service like HTTP or FTP.
    ✓ File_Hash: Hash of any files transferred.
    ✓ Linked_Events_ID: UUID linked to other relevant events.
    ✓ Data_Exfiltration_Flag: Indicates if data exfiltration occurred (True or False).
    ✓ Asset_Classification: Classification of the asset involved.
    ✓ Session_ID: Unique session ID.
    ✓ TTL_Value: Time To Live value of the network packet.
    ✓ User_Behavior_Score: Score to indicate suspicious user behavior.
    ✓ Incident_Category: Category of the incident like Initial Access or Execution.
    ✓ Cloud_Service_Info: Cloud service information, such as AWS, Azure, or GCP.
    ✓ IoC_Flag: Indicator of Compromise flag (True or False)

    user_behavior_data Dataset:
    ✓ ID: Unique identifier for each user activity record.
    ✓ Activity_Count: Count of activities performed by the user.
    ✓ Suspicious_Activity: Flag to indicate if the activity is suspicious (True or False).
    ✓ Last_Activity_Timestamp: Timestamp of the last activity performed.
    ✓ Browser: Browser information where the activity was performed.
    ✓ Number_of_Downloads: Count of files downloaded.
    ✓ Email_Sent: Number of emails sent by the user.

 
Tech Stack

This project elaborates on the sole use of SQL as the technology for the execution of the project. SQL, a powerful querying language, will be utilized to address the database management and data analytics needs of the project, ensuring efficient handling, manipulation,  analysis and retrieval of data.
