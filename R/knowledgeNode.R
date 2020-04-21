





#' 知识点查询
#'
#' @param kc_name 知识分类名称
#'
#' @return 返回数据框
#' @import reticulate
#' @export
#'
#' @examples
#' kc_queryAll()
kn_queryAll <- function(kc_name) {
  rdly <- import('rdlaiye')
  res_list <-rdly$api$kn_query(kc_name = kc_name,format = 'dict')
  r <- lapply(res_list, function(item){
    res<-data.frame(FKnName=item$kn_name,FKnId=item$kn_id,FKcName=item$kc_name,
                    FKcId =item$kc_id,stringsAsFactors = F)
  })
  res <- do.call('rbind',r)
  return(res)
}

#' 知识点上传
#'
#' @param conn  数据库连接
#' @param table_name 表名
#' @param data 知识分类的数据
#'
#' @return 返回值
#' @export
#'
#' @examples
#' kn_upload()
kn_upload <- function(conn=conn_rds('nsic'),data=kn_queryAll(kc_name = 'l112'),table_name='t_ksm_kn') {

  #data <- kn_queryAll(kc_name = kc_name)
  upload_data(conn = conn,table_name = table_name,data = data)

}

#' 判断知识点是否存在
#'
#' @param kn_name 知识点名称
#' @param kc_name 知识分类名称
#' @param conn 连接
#'
#' @return 返回值
#' @export
#'
#' @examples
#' kn_is_exist()
kn_is_exist <-function(kn_name,kc_name,conn=conn_rds('nsic')){
 # kn_upload(kc_name = kc_name,conn = conn)
  sql <- paste0("select 1 from t_ksm_kn
  where FKcName ='",kc_name,"' and FKnName='",kn_name,"'")
  r <- sql_select(conn,sql)
  count <- nrow(r)
  if(count >0){
    res <- TRUE
  }else{
    res <- FALSE
  }
  return(res)
}

#' 创建知识点
#'
#' @param txt 知识点名称
#' @param kc_name 知识点分类
#' @param conn  数据库连接
#'
#' @return 返回值
#' @import reticulate
#' @export
#'
#' @examples
#' kc_create()
#' kn_create('we can do it','l112')
#' 如果内容已经存在，则系统会报错，
#' 目前在python中没有做处理，需要在R中进行处理
#' 在下一个版本中进行改进，返回所有的内容，并更新知识库
kn_create <- function(txt,kc_name,conn=conn_rds('nsic')) {
  rdly <- import('rdlaiye')
  print(kc_name)
  #print(1)
  kn_info <- kn_queryAll(kc_name)
  #print(2)
  #print(kn_info)
  kn_upload(data = kn_info,conn = conn)
  if(kn_is_exist(kn_name = txt,kc_name = kc_name)){
    res <- FALSE
  }else{
    p <-rdly$api$kn_create(txt = txt,kc_name =kc_name)
    res <- TRUE
  }

  return(res)
}
