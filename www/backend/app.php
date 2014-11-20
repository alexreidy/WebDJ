<?php

require_once 'MessageCenter.php';

$GET_MESSAGE  = "gm";
$SEND_MESSAGE = "sm";

$messageCenter = new MessageCenter('127.0.0.1', 'root', '');

function get($key) {
    return isset($_GET[$key]) ? $_GET[$key] : null;
}

$name = get('name');
if ( ! $name || $name == '') die();

switch ($_GET['action']) {
    case $GET_MESSAGE:
        echo($messageCenter->findMessagesFor($name, true, true));
        break;

    case $SEND_MESSAGE:
        $message = get('message');
        if ($message && $message != '')
            $messageCenter->sendMessage($name, $message);
        break;
}

?>