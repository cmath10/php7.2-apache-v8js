<?php

$v8 = new \V8Js();

ob_start();

$v8->executeString('
const arr = [1, 2, 3, 4];
const summa = arr.reduce((summ, el) => summ + el, 0);

print("Array: " + arr.join(", ") + "\n");
print("Summa: " + summa + "\n");
');

echo ob_get_clean();
