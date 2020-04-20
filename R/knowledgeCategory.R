#1知识库查询------
#' 查询知识分类
#'
#' @param show_all 默认显示全部
#'
#' @return 返回数据框结果
#' @import reticulate
#' @export
#'
#' @examples
#' kc_quer(TRUE)
kc_query <- function(show_all = TRUE) {
  rdly <- import('rdlaiye')
  data  <- rdly$api$kc_query(show_all = show_all,format = 'dict')
  res_list <- lapply(data, function(item){
    r = data.frame(FName = item$name,
                   FId = item$id,
                   FParentId = item$parent_id,stringsAsFactors = F)
    return(r)
  })

  res <- do.call('rbind',res_list)
  return(res)
}


#2知识库上传数据库--------
#' 将知识库上传到数据库中
#'
#' @param conn 数据库连接
#' @param data  知识分类数据
#' @param table_name  数据库表名称
#'
#' @return 无
#' @import tsda
#' @export
#'
#' @examples
#'  kc_upload()
#'  create table t_ksm_kc
#' (FName varchar(200),
#'  FId varchar(50),
#'  FParentId varchar(50),
#'  primary key(FId))

kc_upload <- function(conn=conn_rds('nsic'),data=kc_query(),table_name='t_ksm_kc') {

    upload_data(conn = conn,table_name = table_name,data = data)


}



#' 创建知识库
#'
#' @param parentName 上级分类名称
#' @param name  本级名称
#'
#' @return 返回值
#' @import reticulate
#' @export
#'
#' @examples
#' kc_create()
#'
#'
kc_create <- function(parentName,name) {
  rdly <- import('rdlaiye')
  res <- rdly$api$kc_create(kc_parentName =parentName ,kc_name =name )
  return(res)

}





