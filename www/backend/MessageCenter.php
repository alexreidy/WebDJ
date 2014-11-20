<?php

class MessageCenter {

    private $db;

    private $DB_NAME = 'messagecenter';

    function clean($str) {
        return strip_tags($this->db->real_escape_string($str));
    }

    function __construct($host, $username, $password) {
        $this->db = new mysqli($host, $username, $password);
        if ($this->db->connect_errno) {
            return;
        }

        $dbExists = $this->db->select_db($this->DB_NAME) && !$this->db->errno;

        if (!$dbExists) {
            $this->db->query(" CREATE DATABASE {$this->DB_NAME}; ");
            $this->db->select_db($this->DB_NAME);
            $this->db->query("
                CREATE TABLE messages (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    recipient VARCHAR(50),
                    message VARCHAR(500),
                    received INT DEFAULT 0
                )
            ");
        }
    }

    function sendMessage($recipient, $message) {
        $recipient = $this->clean($recipient);
        $message = $this->clean($message);

        // Try to overwrite a message
        $this->db->query("
            UPDATE messages SET
            ts = CURRENT_TIMESTAMP,
            recipient = '{$recipient}',
            message = '{$message}',
            received = 0
            WHERE received
            LIMIT 1;
        ");

        if ($this->db->affected_rows == 0) {
            // No messages could be overwritten, so insert new
            $this->db->query("
                INSERT INTO messages (recipient, message)
                VALUES ('{$recipient}', '{$message}');
            ");
        }
    }

    // If $wait, function blocks and polls database until messages are found
    function findMessagesFor($recipient, $wait) {
        $messages = [];
        $polls = 0;

        $recipient = $this->clean($recipient);

        do {
            $result = $this->db->query("
                SELECT id, message FROM messages
                WHERE recipient = '{$recipient}'
                AND received = 0
                ORDER BY ts;
            ");

            if ($result) $rows = $result->fetch_all(MYSQLI_ASSOC);

            if (count($rows) > 0) {
                foreach ($rows as $row) {
                    array_push($messages, $row['message']);
                    $this->db->query("
                        UPDATE messages SET received = 1
                        WHERE id = {$row['id']};
                    ");
                }

                break;
            }

            if ($wait) sleep(1);
            $polls++;

        } while ($wait && $polls < 30);

        return $messages;
    }

}

?>