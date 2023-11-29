#import libraries
library(data.table)
library(dplyr)
library(DT)
library(readxl)
library(xlsx)
library(tidyverse)           
library(RODBC)

#connect to server
server_conn <- odbcConnect("sql_mspem_sas")
#query data from server
query3<- "SELECT * FROM [app_power_bi].[LAB_RDO].[StockAvailability_SQ01_MMReview_VIEW_All]"
query2<-"SELECT TOP (100) [Plant]
,[Material No]
,[Material Type]
,[Material Description]
,[Type]
,[Reorder Point]
,[Min Lot Size]
,[Max Level]
,[Unrestricted Stock]
,[Unit of Entry]
,[Storage Location]
,[Material Status]
,[Critical]
,[MovAvgPrice]
,[Stock Value]
,[MRPC]
,[Lead Time]
,[ABC Indicator]
,[Safety Stock]
,[Profit Ctr]
,[Refurbishment Indicator]
,[Created Date]
,[Material Group]
,[Total Value]
,[Material Group Desc]
,[MRP Controller]
,[VALUERANGE]
,[SAPSystemID]
,[UniqueJoinKey]
,[DBLoadDate]
FROM [app_power_bi].[LAB_RDO].[StockAvailability_SQ01_MMReview_VIEW_All]"
query_string<-paste("SELECT TOP (1) FROM [app_power_bi].[dbo].[LAB_RDO].[StockAvailability_SQ01_MMReview_VIEW_All] ")
Sq01_data<-sqlQuery(server_conn, query3)

#########################################################
SSO
###########################################################
#import file data
setwd("C:/Users/langmagr1/Desktop/Desktop Documents/SC Inv optimization/Mining")
keep_cols<-c("Material",	"Material Description",	"Plnt",	"MovAvgPrice",	"Min. Lot Sze",	"Unrestricted",	"Profit Ctr",	"Typ",	"Last Chg",	"Max. level",	"Created",	"Reorder Point",	"Refurbishment Indicator",	"MTyp",	"Cri",	"ABC",	"Blocked",	"LS",	"Matl Group",	"Material Group Desc.",	"MRPC",	"MRP",	"PDT",	"MS",	"ProcType",	"Safety Stock",	"SPT",	"In Qual. Insp.",	"Bin",	"SLoc",	"MRP Controller (Materials Planner)",	"ValCl",	"ValueRange",	"Unrestr. Consgt")
SQ01_mine2<-fread("SQ01_MM_9800_9818.txt",fill=TRUE,skip = "Plnt",blank.lines.skip=TRUE,colClasses = "character",select=keep_cols, stringsAsFactors = FALSE)
SQ01_mine2$MovAvgPrice<-(gsub("[.]","",SQ01_mine2$MovAvgPrice))
cng<-c("MovAvgPrice","Min. Lot Sze","Unrestricted","Max. level",	"Created",	"Reorder Point",	"Blocked",	"Safety Stock",	"In Qual. Insp.",		"Unrestr. Consgt")
SQ01_mine2<-SQ01_mine2[, (cng):=lapply(.SD, function(x) gsub(",",".",x)), .SDcols = cng]

SQ01_mine2[is.na(SQ01_mine2)] <- ""

#change work directory
setwd("C:/Users/langmagr1/Desktop/Desktop Documents/SC Inv optimization")
#import data file
plant_names_all<-fread("plant_names_all.csv",stringsAsFactors = FALSE)
#change work directory
setwd("C:/Users/langmagr1/Desktop/Desktop Documents/2020/SC Inv optimization/MB25_PS1_SSO_01072019_11052020")

filenames = list.files(pattern = "\\.csv$")
filenames2<-str_sub(filenames,6,-5)
MB25_SSO<-lapply(filenames, fread,colClasses="character" ) %>% 
  set_names(filenames2) %>% 
  rbindlist(idcol = "Plant_num",fill=TRUE)%>%
  mutate("Mat_Plant"=paste(`Material`,"-",`Plnt`,sep=""))

MB25_SSO$`Reqmt Date`<-gsub("[.]","/",MB25_SSO$`Reqmt Date`)
MB25_SSO$`Reqmt Date`<-as.Date(MB25_SSO$`Reqmt Date`,"%d/%m/%Y")
MB25_SSO<-mutate(MB25_SSO,"Requirment Status"=ifelse(`Reqmt Date`<=Sys.Date(),"Overdue","Due"))

setwd("C:/Users/langmagr1/Desktop/Desktop Documents/SC Inv optimization/PurchaseOrderDelivery")
ZMMQ03<-fread("SSO.csv",colClasses="character",stringsAsFactors = FALSE)%>%
  mutate("Mat_Plant"=paste(Material,"_",Plnt,sep=""))

setwd("C:/Users/langmagr1/Desktop/Desktop Documents/SC Inv optimization/ME5A_ALL_26052020")
ME5A<-fread("SSO_ME5A.csv",colClasses="character",stringsAsFactors = FALSE)%>%
  mutate("Mat_Plant"=paste(Material,"_",Plnt,sep=""))

setwd("C:/Users/langmagr1/Desktop/Desktop Documents/SC Inv optimization/Movement")
movement<-fread("movements_comb.csv",colClasses="character",stringsAsFactors = FALSE)

msb_description<-fread("msb_description.csv",stringsAsFactors = FALSE)
mat_info<-fread("material_info.csv",stringsAsFactors = FALSE)
abc_class<-fread("abc_class.csv",stringsAsFactors = FALSE)

setwd("C:/Users/langmagr1/Desktop/Desktop Documents/SC Inv optimization/BOM/ZPM77_PS1_MINING_9800_9818_MAT")
bom_mat<-fread("Mining_material_BOM.csv",colClasses="character",stringsAsFactors = FALSE)
setwd("C:/Users/langmagr1/Desktop/Desktop Documents/SC Inv optimization/BOM/ZPM77_PS1_MINING_9801_EQUIP")
bom_equip<-fread("Mining_equip_BOM.csv",colClasses="character",stringsAsFactors = FALSE)
setwd("C:/Users/langmagr1/Desktop/Desktop Documents/SC Inv optimization/BOM/ZPM77_PS1_MINING_9801_FLOC")
bom_floc<-fread("Mining_BOM_floc.csv",colClasses="character",stringsAsFactors = FALSE)

Open_POs<-mutate(ZMMQ03, "Mat_Plant"=paste(Material,"_",Plnt,sep=""))%>%
  mutate("Manual or Auto PO"=ifelse(`Created by`=="PTP_USER","Auto PO", ifelse(`Created by`=="SC_BATCH","Auto PO","Manual PO")))%>%
  #mutate("Due Status"=ifelse(identical(substr(`Age Analysis`,1,3),"Not"),"Not Overdue","Overdue")) %>%
  mutate("Diff Quantity"=as.numeric(`PO quantity`)-as.numeric(`Qty delivered`))%>%
  mutate("Outstanding Value"=as.numeric(`Diff Quantity`)*as.numeric(`Net price`))

Open_POs_count<-count(ZMMQ03, `Material`)

Open_POs_qty<-Open_POs%>%
  group_by(Material) %>%
  summarize("PO qty" = sum(as.numeric(`Diff Quantity`), na.rm = TRUE))

Open_res_count<-count(MB25_mine, `Material`)

Open_res_qty<-MB25_mine %>% group_by(Material) %>%
  summarize("Outstanding req Qty" = sum(as.numeric(`Diff. qty`), na.rm = TRUE))

Open_PR_count<-count(ME5A, `Material`)

Open_PR_qty<-ME5A %>% group_by(Material) %>%
  summarize("PR qty" = sum(as.numeric(`Quantity`), na.rm = TRUE))


Sq01_data_SSO<-filter(Sq01_data,`Plant`==8201)

SQ01_comb<-mutate(Sq01_data_SSO,"Mat_Plant"=paste(`Material No`,"-",`Plant`,sep=""))%>%
  mutate("plant_name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"="Mining")%>%
  mutate("bu"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Mat_MRP_Type"=paste(`Material Type`," ",`Type`,sep=""))%>%
  mutate("Category"=mat_info$Category [ match(`Mat_MRP_Type`,mat_info$Mat_MRP_Type)])%>%
  mutate("SOH"=as.numeric(`Unrestricted Stock`))%>%
  mutate("max_level"=ifelse(as.numeric(`Max Level`)!=0,as.numeric(`Max Level`),as.numeric(`Reorder Point`)))%>%
  mutate("MM_block_status"=msb_description$Description [ match(`Material Status`,msb_description$Code)])%>%
  mutate("SOH ROP Diff"=as.numeric(SOH)-as.numeric(`Reorder Point`))%>%
  mutate("Buffer Stock %"=as.numeric(SOH)/as.numeric(`Reorder Point`)*100)%>%
  mutate("Num POs"=Open_POs_count$n [ match(`Material No`,Open_POs_count$Material)])%>%
  mutate("Qty POs"=Open_POs_qty$`PO qty` [ match(`Material No`,Open_POs_qty$Material)])%>%
  mutate("Num PRs"=Open_PR_count$n [ match(`Material No`,Open_PR_count$Material)])%>%
  mutate("Qty PRs"=Open_PR_qty$`PR qty` [ match(`Material No`,Open_PR_qty$Material)])%>%  
  mutate("Num Reservations"= Open_res_count$n[match(`Material No`,Open_res_count$Material)])%>%
  mutate("Qty Reservations"= Open_res_qty$`Outstanding req Qty` [match(`Material No`,Open_res_qty$Material)])%>%
  mutate("Res Requirement Date"=MB25_SSO$`Reqmt Date` [match(`Material No`,MB25_SSO$Material)])%>%
  mutate("Reservation Status"= MB25_SSO$`Requirment Status` [match(`Mat_Plant`,MB25_SSO$Mat_Plant)])%>%
  mutate("PO Status"=Open_POs$`Age Analysis`[match(`Material No`,Open_POs$Material)])%>%
  mutate("Criticality"=ifelse(`Critical`=="X","Critical","Non-Critical"))%>%
  mutate("Manual or AUTO PO"= Open_POs$`Manual or Auto PO`[match(`Material No`,Open_POs$Material)])


saveRDS (Sq01_data,"SQL_SQ01.rds")

SQ01_comb[is.na(SQ01_comb)] <- "" 
SQ01_comb[is.nan(SQ01_comb)] <- "" 
write.csv(SQ01_comb,file="SSO_reservations.csv")
