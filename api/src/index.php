<?php

    require_once 'config.php';

    connect();
 

    function json_stream($array) { return json_encode($array, JSON_UNESCAPED_UNICODE); }