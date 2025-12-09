library ieee;
use ieee.std_logic_1164.all;

entity decod4to16 is
    port (
        w  : in  std_logic_vector(3 downto 0);   -- 4-bit input
        En : in  std_logic;                      -- enable (active-high)
        y  : out std_logic_vector(15 downto 0)    -- 16 one-hot outputs
    );
end entity decod4to16;

architecture Behavior of decod4to16 is
    signal Enw : std_logic_vector(4 downto 0);   -- {En, w(3), w(2), w(1), w(0)}
begin
    Enw <= En & w;   -- concatenate enable and the 3-bit input

    -- 3-to-8 decode using WITH SELECT
    with Enw select
        y <= "0000000000000001" when "10000",   -- En=1, w="0000"
             "0000000000000010" when "10001",   -- En=1, w="0001"
             "0000000000000100" when "10010",   -- En=1, w="0010"
             "0000000000001000" when "10011",   -- En=1, w="0011"
             "0000000000010000" when "10100",   -- En=1, w="0100"
             "0000000000100000" when "10101",   -- En=1, w="0101"
             "0000000001000000" when "10110",   -- En=1, w="0110"
             "0000000010000000" when "10111",   -- En=1, w="0111"
				 "0000000100000000" when "11000",   -- En=1, w="1000"
             "0000001000000000" when "11001",   -- En=1, w="1001"
             "0000010000000000" when "11010",   -- En=1, w="1010"
             "0000100000000000" when "11011",   -- En=1, w="1011"
             "0001000000000000" when "11100",   -- En=1, w="1100"
             "0010000000000000" when "11101",   -- En=1, w="1101"
             "0100000000000000" when "11110",   -- En=1, w="1110"
             "1000000000000000" when "11111",   -- En=1, w="1111"
             "0000000000000000" when others;   -- En=0 → disable all
end architecture Behavior;
