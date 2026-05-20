<?php

interface ModelInterface {
    public static function getCreateTableSQL(): string;
}