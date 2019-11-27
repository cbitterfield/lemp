<?php

# Sample index.php file for cbitterfield/lemp-ubuntu18-04 Docker image.
# To use your own website instead, please refer to the documentation:
# https://registry.hub.docker.com/u/cbitterfield/lemp-ubuntu18-04 

$server_name = $_SERVER['SERVER_NAME'];
    if ($server_name = "_") {
        $server_name = "default server";
    }
    
    $title = $_SERVER['SERVER_NAME'];

    		
    $serverGlobals = $GLOBALS['_SERVER'];
    $global_output = "<table id=\"t01\">\n";
    $global_output = $global_output . "\t\t<tr><th>Key</th><th>Value</th></tr>\n"; //display just the value
    $count = 1;
    while (list($key,$value) = each($serverGlobals)) {
       
        $global_output = $global_output . "\t\t<tr><td>$key</td><td>$value</td></tr>\n"; 
        $count = $count + 1;
    }
    $global_output = $global_output . "</table>\n";
    
    
    
    		
print <<< HTML
<html>
 <head>
  <title>$title</title>
 </head>
<style>
table {
  width:100%;
}
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
th, td {
  padding: 15px;
  text-align: left;
}
table#t01 tr:nth-child(even) {
  background-color: #eee;
}
table#t01 tr:nth-child(odd) {
 background-color: #fff;
}
table#t01 th {
  background-color: black;
  color: white;
}
</style>
 <body>
    <h2>Testing LEMP Configuration</h2>
    <p>My name is $server_name </p>
    <p>This is a test of HTML and PHP</p>
    <p>Testing connection with default database [$database] </p>
    <p>Database test results: $database_test</p>
    <hr>
    <h2>Here's all the values of the super global _SERVER associative array:</h2>
    $global_output
HTML;
    		
    		

?>

