gpyr<-function(df_pyr, pyear, pcol=iiasa6, w=400, h=500, legend="top", pmax=NULL, no.edu=FALSE){
  #df_pyr<-df_pyr1;pyear=2010; pcol=iiasa4; w=400;pmax=NULL
  dfm <- df_pyr %>% filter(year==pyear, sexno==1, ageno!=0, eduno!=0) %>% select(ageno, age ,edu,pop) %>% 
    dcast(age+ageno~edu, value.var="pop") %>%  arrange(desc(ageno)) %>% select(-ageno)
  dff <- df_pyr %>% filter(year==pyear, sexno==2, ageno!=0, eduno!=0) %>% select(ageno, age ,edu,pop) %>% 
    dcast(age+ageno~edu, value.var="pop") %>% arrange(desc(ageno)) %>% select(-ageno)
  if(no.edu==TRUE){
    dfm <- df_pyr %>% filter(year==pyear, sexno==1, ageno!=0, eduno==0) %>% select(ageno, age ,edu,pop) %>% 
      dcast(age+ageno~edu, value.var="pop") %>%  arrange(desc(ageno)) %>% select(-ageno)
    dff <- df_pyr %>% filter(year==pyear, sexno==2, ageno!=0, eduno==0) %>% select(ageno, age ,edu,pop) %>% 
      dcast(age+ageno~edu, value.var="pop") %>% arrange(desc(ageno)) %>% select(-ageno)
  }
  dft <- df_pyr %>% filter(year==pyear, sexno==0, ageno==0, eduno==0)
  if(is.null(pmax))
    pmax<-max(df_pyr %>% filter(year==pyear, ageno!=0, sexno!=0, eduno==0) %>% .[["pop"]], na.rm=TRUE)
  bar1 <- gvisBarChart(dfm, xvar="age", yvar=names(dfm)[-1],
    options=list(bar="{groupWidth:'90%'}", isStacked=TRUE, 
                 title=paste0("Total Population: ",round(dft$pop/1000,2)," m"), titleTextStyle="{fontName:'Arial',fontSize:16}",
                 hAxis=paste0("{direction:-1, maxValue:",pmax,", title: 'Male'}"),
                 colors=pcol, height=h, width=w, 
                 chartArea="{right:'0%',left:'15%',width:'85%',top:'5%',height:'85%'}"))
  bar2 <- gvisBarChart(dff, xvar="age", yvar=names(dfm)[-1],
    options=list(bar="{groupWidth:'90%'}", isStacked=TRUE,
                 hAxis=paste0("{maxValue:",pmax,", title: 'Female'}"),
                 legend="{position:'none'}",
                 colors=pcol, height=h, width=w,
                 chartArea="{right:'15%',left:'0%',width:'85%',top:'5%',height:'85%'}"))
  top1<-gvisBarChart(dfm, xvar="age", yvar=names(dfm)[-1],
                     options=list(colors=pcol, height=30, width=2*w, 
                                  legend="{position:'top', textStyle: {fontSize: 12}}",
                                  chartArea="{right:'0%',left:'0%',width:'100%',top:'100%',height:'0%'}"))
  if(legend=="none")
    gg<-gvisMerge(bar1, bar2, horizontal = TRUE, tableOptions="cellspacing=0, cellpadding=0")
  if(legend=="top")
    gg<-gvisMerge(top1, tableOptions="cellspacing=0, cellpadding=0",
              gvisMerge(bar1, bar2, horizontal = TRUE, tableOptions="cellspacing=0, cellpadding=0"))
  return(gg)
}
#plot(gpyr(df1, 2010))
#plot(gpyr(df1, 2010, legend="only"))

