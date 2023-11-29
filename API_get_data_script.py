import requests
import json
import pandas as pd


#url = 'https://reports.api.mm.co.za/Member?page=1&pageSize=100'
url = 'https://reports.api.mm.co.za/CustomTabs'
#payload = open("request.json")
headers = {
    'accept': '*/*',
    'communityId': '002590a85a77',
    'x-api-key': '114651234',
    'x-api-secret': 'ZDViOWFkZDEtYjQ3Ni00ZDU3LWI4ZDctMDdkZDJiZjAxOGM1OmdyYW50QGUUJSHDFRIUTR',
}
#r = requests.post(url, data=payload, headers=headers)

r = requests.get(url, headers=headers)
rc=r.content
print(r)

df1=rc.decode('utf-8')
dmp=json.loads(df1)
dt=pd.DataFrame(dmp)

out=dt[["professionalNumber","membershipNumber", "picturePath"]]

#----------------------------------------------------------------------


url = 'https://reports.api.co.za/Designation'

headers = {
    'accept': '*/*',
    'communityId': '002590a85a77',
    'x-api-key': '114651234',
    'x-api-secret': 'ZDViOWFkZDEtYjQ3Ni00ZDU3LWI4ZDctMDdkZDJiZjAxOGM1OmdyYW50QGUUJSHDFRIUTR',
}

r = requests.get(url, headers=headers)
rc=r.content

df1=rc.decode('utf-8')
dmp=json.loads(df1)
dt2=pd.DataFrame(dmp)

desg_ids=dt2["id"]
#-------------------------------------------------------------
url = 'https://reports.api.mymembership.co.za/api/CustomTabs/971/tab'

headers = {
    'accept': '*/*',
    'communityId': '002590a85a77',
    'x-api-key': '114651234',
    'x-api-secret': 'ZDViOWFkZDEtYjQ3Ni00ZDU3LWI4ZDctMDdkZDJiZjAxOGM1OmdyYW50QGUUJSHDFRIUTR',
}

r = requests.get(url, headers=headers)
rc=r.content

df1=rc.decode('utf-8')
dmp=json.loads(df1)
dt4=pd.DataFrame(dmp)

#tab_ids=dt4["id"]
#-------------------------------------------------------------------------------

cred = pd.DataFrame()
for desg in range(len(desg_ids)):
    
    url = 'https://reports.api.co.za/Designation/type/'+str(desg_ids[desg])+'/members'
    print(url)

#url = 'https://reports.api.co.za/Designation/type/23/members'

headers = {
    'accept': '*/*',
    'communityId': '002590a85a77',
    'x-api-key': '114651234',
    'x-api-secret': 'ZDViOWFkZDEtYjQ3Ni00ZDU3LWI4ZDctMDdkZDJiZjAxOGM1OmdyYW50QGUUJSHDFRIUTR',
}

    r = requests.get(url, headers=headers)
    rc=r.content

    df1=rc.decode('utf-8')
    dmp=json.loads(df1)
    dt3=pd.DataFrame(dmp)
    cred=cred.append(dt3)





cred_out=cred.merge(dt, left_on = "membershipNumber", right_on = "membershipNumber", how = "left")
cred_out=cred_out.merge(dt4, left_on = "memberId", right_on = "memberId", how = "left")

summary=cred_out[["membershipNumber","professionalNumber_x","firstname_x","lastname_x","picturePath","answerText"]]
summary.to_csv('COMENSA_cred_pic289.csv', index=False)
