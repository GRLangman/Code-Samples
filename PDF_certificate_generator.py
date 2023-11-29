
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 10 15:41:41 2022

@author: LANGMAGR1
"""


import os
# import urllib2
import time
from reportlab import platypus 
from reportlab.lib.pagesizes import landscape, A4
from reportlab.lib.units import mm, inch
from reportlab.platypus import SimpleDocTemplate, Image
from reportlab.pdfgen import canvas
import pandas as pd 
from reportlab.lib import colors
import datetime


# Read in the CSV file located in the same folder as this scrip.
#Remember to change the name below to match your CSV filename.
# The date format in the csv file must be dd mm yyyy. (do this using custom format)
data = pd.read_csv("Students_November.csv")



#select only the name column from the data as nms.
nms=data['FullName']

#select only the start date from the data as dt_start.
dt_start=data['Start Date']

#Select only the end date from the data as dt_end.
dt_end=data['End Date']

# create a column in data to combine start and end date with a hyphen inbetween
data['FullDate']=data['Start Date']+' - '+ data['End Date']

# select only the full date column as full_dt
full_dt=data['FullDate']

# read in the backround image file as image_file (name can be changed to match new file name)
image_file = "STUDENT MEMBER.jpg"

#read in the signatures(new certificate version already has signatures so these are currently not used)
pres_sign="COMENSA_pres_2023.png"
vp_sign="COMENSA_VP.png"


for nm in range(len(nms)) :
   

    
    #create a pdf canvas with the member name
    c = canvas.Canvas(nms[nm] + '.pdf', pagesize=landscape(A4))
    
    # Create the required text variables
    txt_1="THIS IS TO CERTIFY THAT"
    txt_2="IS A"
    txt_member="COMENSA STUDENT MEMBER"
    txt_3="FOR THE PERIOD"
    txt_period=str(full_dt[nm])
    txt_pres="President"
    txt_vp="Vice President"
    txt_line="____________________"
    
    
    # Formula to try and center the name based on the number of characters in the name
    name_cent=146-((len(nms[nm])/2)*7.5)

    # Formula to try and center the date based on the number of characters in the date
    period_cent=151-((len(txt_period)/2)*3)

    #add each of the text variables
    c.drawImage(image_file, 30 , 40, width=276*mm, height=185*mm)
    c.setFont("Helvetica", 15)
    c.drawString( 115*mm, 177*mm, txt_1)
    c.setFont("Helvetica", 36)
    c.setFillColor(colors.HexColor("#1e71ad"))#("#0b548b"))
    c.drawString( name_cent*mm, 155*mm, (nms[nm]).upper())
    c.setFont("Helvetica", 15)
    c.setFillColor(colors.black)
    c.drawString( 143*mm, 139*mm, txt_2)
    c.setFont("Helvetica", 36)
    c.setFillColor(colors.black)
    c.drawString( 55*mm, 117*mm, txt_member)
    c.setFont("Helvetica", 15)
    c.setFillColor(colors.black)
    c.drawString( 125*mm, 99*mm, txt_3)
    c.setFont("Helvetica-Bold", 15)
    c.setFillColor(colors.HexColor("#1e71ad"))
    c.drawString( period_cent*mm, 87*mm, txt_period)
    c.setFont("Helvetica", 18)
    c.setFillColor(colors.black)
    
    #c.showPage()
    # save the pdf, it has already been named when created above
    c.save()    
    
    
    