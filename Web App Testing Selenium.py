# -*- coding: utf-8 -*-
"""
Created on Fri Apr 23 23:36:34 2023

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
from selenium.webdriver.support.ui import Select

from selenium.webdriver.support import expected_conditions as EC


#data = pd.read_csv("CCMG_member_numbers_change_language.csv")
#data = pd.read_csv("CCMG_member_numbers_test_login5.csv")

#months=data['Renewal']

#dates= "1 "+months+ " 2020"+ " - "+ "1 "+months+ " 2021"

#member_number_input=str("validmembershipnum")
member_number_input=str("test63533554")

driver = webdriver.Chrome('C:/Users/grant/OneDrive/Documents/COMENSA/chromedriver.exe')
vars = {}
driver.get("https://site.co.za/Account/Login?)
driver.set_window_size(1296, 696)
#driver.find_element(By.ID, "Username").click()
driver.find_element(By.ID, "Username").send_keys("user")
#driver.find_element(By.ID, "Password").click()
driver.find_element(By.ID, "Password").send_keys("password")
driver.find_element(By.NAME, "button").click()#click login
driver.find_element(By.CSS_SELECTOR, ".community-change span").click()#click change community
driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_gvCommunities_ctl36_lnkBtnManage").click()#select Community 36=E2 sage BC 
    
    
#for mem_num in range(len(membership_numbers)) :
   # print(mem_num)
    #member_number_input=str(membership_numbers[mem_num])
    #print(member_number_input)
    
# Find element by ID
driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_txtmembnumber").send_keys(member_number_input)#enter membership number from table
driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_butSearch").click()#click the search button
driver.find_element(By.LINK_TEXT, "Details").click()#Click details link

#===============================================================================
#alternate method
#===============================================================================
# find element by CSS
    
#driver.find_element(By.CSS_SELECTOR, "li:nth-child(2) span:nth-child(1)").click()
#driver.execute_script("window.scrollTo(0,294.8148498535156)")
#driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_drpNationality").click()
#dropdown = driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_drpNationality")
#driver.find_element(By.CSS_SELECTOR, "li:nth-child(4) span:nth-child(1)").click()
driver.find_element(By.CSS_SELECTOR, "li:nth-child(2) span:nth-child(1)").click()

#dropdown=driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlPostalProvince")
dropdown=driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlHomeLanguage")

print(dropdown)

selector = Select(dropdown)


#==========================================================================
#for debuging
#==========================================================================
# Waiting for the values to load
#element = WebDriverWait(driver, 
#10).until(EC.element_to_be_selected(selector.options[0]))
#==========================================================================
#print all options in the dropdown
options = selector.options
for index in range(1, len(options)-1):
    print(options[index].text)



#=============================================================================
#variation 2
# =============================================================================
# 
# driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlHomeLanguage").click()
#     driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlHomeLanguage").send_keys("Other")
#     #driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlHomeLanguage").send_keys(Keys.ENTER)
#     #driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlHomeLanguage").click()
#     #dropdown = driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlHomeLanguage")
#     #dropdown.find_element(By.XPATH, "//option[. = 'Other']").click()
#     
#     #driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlHomeLanguage").click()
#     #driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_ddlHomeLanguage").click()
#     driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_ctl01_btnSave").click()
#     driver.find_element(By.CSS_SELECTOR, ".active > .app-menu__label").click()
#     driver.find_element(By.LINK_TEXT, "Search now").click()
#     driver.find_element(By.ID, "ctl00_ctl00_ContentThemed_GenericContent_txtmembnumber").click()
# 
# =============================================================================
    
print("completed")    