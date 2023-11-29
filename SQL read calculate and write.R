mb51_mining<-filter(mb51_data,`OME`=="Mining")
mb51_so<-filter(mb51_data,`OME`=="SO")
mb51_sco<-filter(mb51_data,`OME`=="SCO")
mb51_sso<-filter(mb51_data,`OME`=="SSO")
mb51_sat<-filter(mb51_data,`OME`=="SAT")

sq01_sco<-filter(sq01_data,`OME`=="Mining")
sq01_so<-filter(sq01_data,`OME`=="SO")
sq01_sco<-filter(sq01_data,`OME`=="SCO")
sq01_sso<-filter(sq01_data,`OME`=="SSO")
sq01_sat<-filter(sq01_data,`OME`=="SAT")
  
#############################################################################################
mining
############################################################################################
mb51_mining_12<-filter(mb51_mining,`Document.Date`> as.Date("2019-07-01"))%>%
  mutate("Mat_Plant_Month"=paste(`Mat_Plant`,"-",substr(`Document.Date`,6,7),sep=""))

mb51_mining_24<-filter(mb51_mining,`Document.Date`> as.Date("2018-07-01"))
mb51_mining_24_unique<-data.frame("Mat_Plant"=unique(mb51_mining_24$Mat_Plant))

non_moving<-anti_join(sq01_mining_unique,mb51_mining_24_unique,by="Mat_Plant")%>%# inSq01not in last 24 months movement
  mutate("n"=0)%>%
  mutate("Material"=sq01_data$Material.No [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant"=sq01_data$Plant [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")

turn1<-count(mb51_mining_12,`Mat_Plant`)%>%
  mutate("Material"=mb51_mining_12$MaterialNo [ match(`Mat_Plant`,mb51_mining_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_mining_12$Plant [ match(`Mat_Plant`,mb51_mining_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn1<-rbind(turn1,non_moving)%>%
  mutate("Method"="Stock Movement")

unique_months1<-count(mb51_mining_12,`Mat_Plant_Month`)%>%
  mutate("Mat_Plant"=mb51_mining_12$Mat_Plant [ match(`Mat_Plant_Month`,mb51_mining_12$Mat_Plant_Month)])

turn_months1<-count(unique_months1,`Mat_Plant`)%>%
  mutate("Material"=mb51_mining_12$MaterialNo [ match(`Mat_Plant`,mb51_mining_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_mining_12$Plant [ match(`Mat_Plant`,mb51_mining_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn_months1<-rbind(turn_months1,non_moving)%>%
  mutate("Method"="Stock Movement by Months")

turn1_comb<-rbind(turn1,turn_months1)


#############################################################################################
sco
############################################################################################
sq01_sco_unique<-data.frame("Mat_Plant"=unique(sq01_sco$Mat_Plant))#create unique table with no repeated material numbers

mb51_sco_12<-filter(mb51_sco,`Document Date`> as.Date("2019-07-01"))%>%
  mutate("Mat_Plant_Month"=paste(`Mat_Plant`,"-",substr(`Document Date`,6,7),sep=""))

mb51_sco_24<-filter(mb51_sco,`Document Date`> as.Date("2018-07-01"))
mb51_sco_24_unique<-data.frame("Mat_Plant"=unique(mb51_sco_24$Mat_Plant))

non_moving2<-anti_join(sq01_sco_unique,mb51_sco_24_unique,by="Mat_Plant")%>%# inSq01not in last 24 months movement
  mutate("n"=0)%>%
  mutate("Material"=sq01_data$Material.No [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant"=sq01_data$Plant [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")

turn2<-count(mb51_sco_12,`Mat_Plant`)%>%
  mutate("Material"=mb51_sco_12$MaterialNo [ match(`Mat_Plant`,mb51_sco_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_sco_12$Plant [ match(`Mat_Plant`,mb51_sco_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn2<-rbind(turn2,non_moving2)%>%
  mutate("Method"="Stock Movement")

unique_months2<-count(mb51_sco_12,`Mat_Plant_Month`)%>%
  mutate("Mat_Plant"=mb51_sco_12$Mat_Plant [ match(`Mat_Plant_Month`,mb51_sco_12$Mat_Plant_Month)])

turn_months2<-count(unique_months2,`Mat_Plant`)%>%
  mutate("Material"=mb51_sco_12$MaterialNo [ match(`Mat_Plant`,mb51_sco_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_sco_12$Plant [ match(`Mat_Plant`,mb51_sco_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn_months2<-rbind(turn_months2,non_moving2)%>%
  mutate("Method"="Stock Movement by Months")

turn2_comb<-rbind(turn2,turn_months2)

#############################################################################################
so
############################################################################################
sq01_so_unique<-data.frame("Mat_Plant"=unique(sq01_so$Mat_Plant))#create unique table with no repeated material numbers

mb51_so_12<-filter(mb51_so,`Document Date`> as.Date("2019-07-01"))%>%
  mutate("Mat_Plant_Month"=paste(`Mat_Plant`,"-",substr(`Document Date`,6,7),sep=""))

mb51_so_24<-filter(mb51_so,`Document Date`> as.Date("2018-07-01"))
mb51_so_24_unique<-data.frame("Mat_Plant"=unique(mb51_so_24$Mat_Plant))

non_moving3<-anti_join(sq01_so_unique,mb51_so_24_unique,by="Mat_Plant")%>%# inSq01not in last 24 months movement
  mutate("n"=0)%>%
  mutate("Material"=sq01_data$Material.No [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant"=sq01_data$Plant [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")

turn3<-count(mb51_so_12,`Mat_Plant`)%>%
  mutate("Material"=mb51_so_12$MaterialNo [ match(`Mat_Plant`,mb51_so_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_so_12$Plant [ match(`Mat_Plant`,mb51_so_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn3<-rbind(turn3,non_moving3)%>%
  mutate("Method"="Stock Movement")

unique_months3<-count(mb51_so_12,`Mat_Plant_Month`)%>%
  mutate("Mat_Plant"=mb51_so_12$Mat_Plant [ match(`Mat_Plant_Month`,mb51_so_12$Mat_Plant_Month)])

turn_months3<-count(unique_months3,`Mat_Plant`)%>%
  mutate("Material"=mb51_so_12$MaterialNo [ match(`Mat_Plant`,mb51_so_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_so_12$Plant [ match(`Mat_Plant`,mb51_so_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn_months3<-rbind(turn_months3,non_moving3)%>%
  mutate("Method"="Stock Movement by Months")

turn3_comb<-rbind(turn3,turn_months3)
#############################################################################################
sso
############################################################################################
sq01_sso_unique<-data.frame("Mat_Plant"=unique(sq01_sso$Mat_Plant))#create unique table with no repeated material numbers

mb51_sso_12<-filter(mb51_sso,`Document Date`> as.Date("2019-07-01"))%>%
  mutate("Mat_Plant_Month"=paste(`Mat_Plant`,"-",substr(`Document Date`,6,7),sep=""))

mb51_sso_24<-filter(mb51_sso,`Document Date`> as.Date("2018-07-01"))
mb51_sso_24_unique<-data.frame("Mat_Plant"=unique(mb51_sso_24$Mat_Plant))

non_moving4<-anti_join(sq01_sso_unique,mb51_sso_24_unique,by="Mat_Plant")%>%# inSq01not in last 24 months movement
  mutate("n"=0)%>%
  mutate("Material"=sq01_data$Material.No [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant"=sq01_data$Plant [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")

turn4<-count(mb51_sso_12,`Mat_Plant`)%>%
  mutate("Material"=mb51_sso_12$MaterialNo [ match(`Mat_Plant`,mb51_sso_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_sso_12$Plant [ match(`Mat_Plant`,mb51_sso_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn4<-rbind(turn4,non_moving4)%>%
  mutate("Method"="Stock Movement")

unique_months4<-count(mb51_sso_12,`Mat_Plant_Month`)%>%
  mutate("Mat_Plant"=mb51_sso_12$Mat_Plant [ match(`Mat_Plant_Month`,mb51_sso_12$Mat_Plant_Month)])

turn_months4<-count(unique_months4,`Mat_Plant`)%>%
  mutate("Material"=mb51_sso_12$MaterialNo [ match(`Mat_Plant`,mb51_sso_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_sso_12$Plant [ match(`Mat_Plant`,mb51_sso_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn_months4<-rbind(turn_months4,non_moving4)%>%
  mutate("Method"="Stock Movement by Months")

turn4_comb<-rbind(turn4,turn_months4)


#############################################################################################
sat
############################################################################################
sq01_sat_unique<-data.frame("Mat_Plant"=unique(sq01_sat$Mat_Plant))#create unique table with no repeated material numbers

mb51_sat_12<-filter(mb51_sat,`Document Date`> as.Date("2019-07-01"))%>%
  mutate("Mat_Plant_Month"=paste(`Mat_Plant`,"-",substr(`Document Date`,6,7),sep=""))

mb51_sat_24<-filter(mb51_sat,`Document Date`> as.Date("2018-07-01"))
mb51_sat_24_unique<-data.frame("Mat_Plant"=unique(mb51_sat_24$Mat_Plant))

non_moving5<-anti_join(sq01_sat_unique,mb51_sat_24_unique,by="Mat_Plant")%>%# inSq01not in last 24 months movement
  mutate("n"=0)%>%
  mutate("Material"=sq01_data$Material.No [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant"=sq01_data$Plant [ match(`Mat_Plant`,sq01_data$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")

turn5<-count(mb51_sat_12,`Mat_Plant`)%>%
  mutate("Material"=mb51_sat_12$MaterialNo [ match(`Mat_Plant`,mb51_sat_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_sat_12$Plant [ match(`Mat_Plant`,mb51_sat_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn5<-rbind(turn5,non_moving5)%>%
  mutate("Method"="Stock Movement")

unique_months5<-count(mb51_sat_12,`Mat_Plant_Month`)%>%
  mutate("Mat_Plant"=mb51_sat_12$Mat_Plant [ match(`Mat_Plant_Month`,mb51_sat_12$Mat_Plant_Month)])

turn_months5<-count(unique_months5,`Mat_Plant`)%>%
  mutate("Material"=mb51_sat_12$MaterialNo [ match(`Mat_Plant`,mb51_sat_12$Mat_Plant)])%>%
  mutate("Plant"=mb51_sat_12$Plant [ match(`Mat_Plant`,mb51_sat_12$Mat_Plant)])%>%
  mutate("Plant Name"=plant_names_all$`Plant name` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("BU"=plant_names_all$`Business Unit` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("OME"=plant_names_all$`OME` [ match(`Plant`,plant_names_all$Plant)])%>%
  mutate("Movement Category"=ifelse(as.numeric(`n`)==0,"Non-Moving",ifelse(`n`<=5,"Slow","Fast")))%>%
  setnames("n","Movement")


turn_months5<-rbind(turn_months5,non_moving5)%>%
  mutate("Method"="Stock Movement by Months")

turn5_comb<-rbind(turn5,turn_months5)

movement_comb<-rbind(turn1_comb,turn2_comb,turn3_comb,turn4_comb,turn5_comb)

query_string_create<-"USE [app_power_bi] CREATE TABLE [dbo].[SC_Inv_Opt_Movement](
[Mat_Plant] [ntext] NULL
,[Movement] [float]NULL
,[Material] [ntext] NULL
,[Plant] [ntext] NULL
,[Plant Name] [ntext] NULL
,[BU] [ntext] NULL
,[OME] [ntext] NULL
,[Movement Category] [ntext] NULL
,[Method] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]"
create_test<-sqlQuery(server_conn, query_string_create)

dbAppendTable(con, Id(database="app_power_bi", schema = "dbo",table = "SC_Inv_Opt_Movement"), movement_comb)

