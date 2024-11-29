/*
Challenge:
Create an user defined function that returns True if a string is a palindrome
*/

DELIMITER //

CREATE FUNCTION is_palindrome(input_string VARCHAR(20))
RETURNS BOOLEAN
BEGIN
    DECLARE reversed_string VARCHAR(20);
    SET reversed_string = REVERSE(input_string);
    RETURN input_string = reversed_string;
END //

DELIMITER ;

SELECT is_palindrome('radar'), is_palindrome('hello')

-- TRUE | FALSE
