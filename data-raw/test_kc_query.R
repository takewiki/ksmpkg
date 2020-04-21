library(ksmpkg)
mydata <- kc_query()
View(mydata)

#知识分类上传
kc_upload()



kc_create('l1','l115')

test <-kc_queryRefresh()
