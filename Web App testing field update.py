# -*- coding: utf-8 -*-
"""
Created on Fri Jun  4 10:03:14 2023

@author: Grant
"""


import pandas as pd 
import pytest
import time
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

from selenium.webdriver.support.select import Select

data = pd.read_csv("SAOA_test.csv")
#data = pd.read_csv("acc_check_e2.csv")
#data = pd.read_csv("path_id_check.csv")
#data = pd.read_csv("CCMG_member_numbers_test_login5.csv")


membership_numbers=data['MembershipNumber']
#prof_number=data['Professional Number']
acc_nums=data['AccountNumber']
#ID_numbers=data['ID Number']
#email=data['Email address']
#alt_email=data['Alternate Email']
#mobile=data['Cell phone']

#ID_numbers="9507270039089"
driver = webdriver.Chrome('C:/Users/grant/OneDrive/Documents/chromedriver.exe')
vars = {}
driver.get("https://site.co.za/Account/Login?")
#driver.set_window_size(1296, 696)
#driver.find_element(By.ID, "Username").click()
driver.find_element(By.ID, "Username").send_keys("user")
#driver.find_element(By.ID, "Password").click()
driver.find_element(By.ID, "Password").send_keys("password")
driver.find_element(By.NAME, "button").click()#click login
driver.find_element(By.CSS_SELECTOR, ".community-change span").click()#click change community
driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_gvCommunities_ctl176_lnkBtnManage").click()#select community
  
    
#loop through all members in imported table
for mem_num in range(len(membership_numbers)) :
    print(mem_num)
    member_number_input=str(membership_numbers[mem_num])
    acc_num_input=str(acc_nums[mem_num])
    #alt_email_input=str(alt_email[mem_num])
    #mobile_input="0"+ str(mobile[mem_num])
    print(member_number_input)
    #print(mobile_input)
    
    
    
    driver.find_element(By.CSS_SELECTOR, "li:nth-child(9) .app-menu__label").click()
    driver.find_element(By.LINK_TEXT, "Search now").click()
    
    driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_txtmembnumber").clear()
    driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_txtmembnumber").send_keys(member_number_input)#enter membership number from table
    driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_txtmembnumber").send_keys(Keys.ENTER)
    driver.find_element(By.LINK_TEXT, "Details").click()
    #ismem=driver.find_element(By.ID,"ctl00_ctl00_ContentThemed_GenericContent_gvE2Admin").text
    #lnktxt=ismem[46:58]

    #for debugging
    #print(lnktxt)
    

    user_defined_type_dropdown_element_title = driver.find_element(By.ID,"ctl00_ctl00_ContentThemed_GenericContent_ctl00_drpTitleId")
    mem_title = Select(user_defined_type_dropdown_element_title)

# to print the text
    mem_title2=mem_title.first_selected_option.text

    # to print the value
    #mem_title3=mem_title.first_selected_option.get_attribute("value")#returns unique element code

    print(mem_title2)
    #print(mem_title3)

    if mem_title2=="":
        print("title in null")
    elif mem_title2=="[select]":
        print("title is select")  
    else:
        print("title not null")



    
    
    
    
    
    mem_name=driver.find_element(By.ID,"ctl00_ctl00_ContentThemed_GenericContent_ctl00_txtContactName").text
    print(mem_name)
    if mem_name=="":
        print("name in null")
    else:
        print("name not null")
        
    mem_lastname=driver.find_element(By.ID,"ctl00_ctl00_ContentThemed_GenericContent_ctl00_txtContactLastName").text
    print(mem_lastname)
    if mem_lastname=="":
        print("lastname in null")
    else:
        print("lastname not null")
        
    
    #mem_province=driver.find_element(By.ID,"ctl00_ctl00_ContentThemed_GenericContent_ctl00_ddlPracticeProvince").text
    
    user_defined_type_dropdown_element_province = driver.find_element(By.ID,"ctl00_ctl00_ContentThemed_GenericContent_ctl00_ddlPracticeProvince")
    mem_province = Select(user_defined_type_dropdown_element_province)

# to print the text
    mem_province2=mem_province.first_selected_option.text
    print(mem_province2)
    if mem_province2=="":
        print("province in null")
    elif mem_province2=="[Please select...]":
        print("province is select")  
    else:
        print("province not null")
    mem_acc=driver.find_element(By.ID, "txtAccountNumber").text

    print(mem_acc)
    print(acc_num_input)


    
print("completed")    