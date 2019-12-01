<?php

// Sample index.php file for cbitterfield/lemp2 Docker image.
// To use your own website instead, please refer to the documentation:
// https://registry.hub.docker.com/u/cbitterfield/lemp2
// License GNU 3.0
// Reuse permitted please provide link to original source in derived code

// This file is located at http://github.com/cbitterfield/lem2

// Turn off cache for testing
header('Expires: Sun, 01 Jan 2014 00:00:00 GMT');
header('Cache-Control: no-store, no-cache, must-revalidate');
header('Cache-Control: post-check=0, pre-check=0', FALSE);
header('Pragma: no-cache');

$server_name = $_SERVER['SERVER_NAME'];
    if ($server_name == "_") {
        $server_name = "default server";
    }
    
    $title = $_SERVER['SERVER_NAME'];

    		
    $serverGlobals = $GLOBALS['_SERVER'];
    $global_output = "<table id=\"t01\">\n";
    $global_output = $global_output . "<tr><th colspan=\"2\"><h2>Values from the super global _SERVER associative array:</h2></th></tr>";
    $global_output = $global_output . "\t\t<tr><th>Key</th><th>Value</th></tr>\n"; //display just the value
    $count = 1;
    while (list($key,$value) = each($serverGlobals)) {
       
        $global_output = $global_output . "\t\t<tr><td>$key</td><td>$value</td></tr>\n"; 
        $count = $count + 1;
    }
    $global_output = $global_output . "</table>\n";
    
    // Test Database connectivity with connection and simple query
    $sql = "show variables;";
    
    // Example Database connect variables replaced on first run
    // Example Database connect variables replaced on first run
    $sql_server   = "127.0.0.1";
    $sql_username = "__sqlusername__";
    $sql_password = "__sqlpassword__";
    $sql_database = "__sqldatabase__";
    $sql_port     = 3306;
    $sql_socket    = "/var/run/mysqld/mysqld.sock";
    // Becareful with connecting via Sockets or TCP protocols.
    // Default Socket ubuntu mysql is /var/run/mysqld/mysqld.sock
    // Socket is subject to file/dir permissions
    
    
    //First test SQL Connection and return a connection message good or bad
    $conn = mysqli_connect($sql_server, $sql_username, $sql_password, $sql_database, $sql_port, $sql_socket);
    
    if (!$conn) {
        $database_connect_message = "Connection failed: " . mysqli_connect_error();
        //header("Location: $url"); Use this to redirect the user if the connection fails.
       
    } else {
        $database_connect_message = "database services connected with user " . $sql_username;
        
    }
    
    // Next perform a sql query to test database
    // Only try if the connection is value
    $values = array();
    $columns = array();
    if ($conn) {
        $res = $conn->query($sql);
        $values = $res->fetch_all(MYSQLI_ASSOC);
        if(!empty($values)){
            $columns = array_keys($values[0]);
            $names = print_r ($columns,true);
            
        }
        
        
        // Create a HTML table if there are results
        $database_table = "<table id=\"t01\">\n";
        $database_table = $database_table . "<tr><th colspan=\"2\"><h2>Values from the SQL query results of $sql<h2></th><tr>";
        // Create a header row
        $database_table = $database_table . "\n\t\t<tr>";
        foreach ($columns as $column){
            $database_table = $database_table . "<th>" . $column . "</th>";
        }
        $database_table = $database_table . "</tr>\n";
        
        //use "print_r" to show an array -- print_r($values);
        
        foreach ($values as $row) {
            foreach ($columns as $column){
                $database_table = $database_table . "<td>" . $row[$column] . "</td>";
            }
            $database_table = $database_table . "</tr>\n";
        }
        $database_table = $database_table . "</table>\n";
    }
    
    		
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
    <table id="t01">
    <tr><th colspan="2"><h2>Testing your LEMP Configuration and SQL connection</h2></th></tr>
    <tr><td>My name is</td><td>$server_name</td></tr>
    <tr><td colspan="2">This is a test of HTML and PHP</td></tr>
    <tr><td>Testing connection with default database</td><td>[$sql_database]</td></tr>
    <tr><td>Database connection test results</td><td>$database_connect_message</td></tr>
    </table>
    <hr>
    $global_output
    <hr>
    $database_table
HTML;
    		
    		

?>

