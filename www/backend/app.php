<?php

require_once 'MessageCenter.php';

$GET_MESSAGES = "gm";
$SEND_MESSAGE = "sm";

$messageCenter = new MessageCenter('127.0.0.1', 'root', '');

function get($key) {
    return isset($_GET[$key]) ? $_GET[$key] : null;
}

$name = get('name');
if ( ! $name || $name == '') die();

switch ($_GET['action']) {
    case $GET_MESSAGES:
        $messages = $messageCenter->findMessagesFor($name, true);
        foreach ($messages as $message) {
            echo($message . "\n");
        }
        break;

    case $SEND_MESSAGE:
        $message = get('message');
        if ($message && $message != '')
            $messageCenter->sendMessage($name, $message);
        break;
}

?>