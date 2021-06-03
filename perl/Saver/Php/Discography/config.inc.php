<?php
$HOST = "localhost";
$USER = "root";
$PASSWRD = "";
$DBNAME = "Discography";
$TBL_BIO = "tbl_biographies";
$TBL_ALB = "tbl_albums";
$TBL_TIT = "tbl_titres";

mysql_connect($HOST, $USER ,$PASSWRD);
mysql_select_db($DBNAME);
?>