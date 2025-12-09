library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port(
        Clock      : in std_logic;                     -- input clock signal
        A, B       : in unsigned(7 downto 0);          -- 8-bit inputs from latches A and B
        OP         : in unsigned(15 downto 0);         -- 16-bit selector for operation from Decoder
        Neg        : out std_logic;                    -- is the result negative? Set V-bit output
        R1         : out unsigned(3 downto 0);         -- lower 4 bits of 8-bit result output
        R2         : out unsigned(3 downto 0)          -- upper 4 bits of 8-bit result output
    );
end ALU;

architecture calculation of ALU is

    -- temporary signal declarations
    signal Reg1, Reg2, Result : unsigned(7 downto 0) := (others => '0');

begin

    -- temporarily store A in Reg1, B in Reg2
    Reg1 <= A;
    Reg2 <= B;

    process (Clock)
    begin
        if rising_edge(Clock) THEN                 -- calculation at positive clock edge
            case OP is

                -- Do Addition
                when "0000000000000001" =>
						  Neg <= '0';
                    Result <= Reg1 + Reg2;

                -- Do Subtraction (Neg bit set if required)
                when "0000000000000010" =>
						  if (Reg2 > Reg1) then
							Neg <= '1';
						  else
							Neg <= '0';
							end if;
							Result <= Reg1 - Reg2;
                -- Do Inverse
                when "0000000000000100" =>
                    Result <= not Reg1;
						  Neg <= '0';
                -- Do Boolean NAND
                when "0000000000001000" =>
                    Result <= not (Reg1 and Reg2);
						  Neg <= '0';
                -- Do Boolean NOR
                when "0000000000010000" =>
                    Result <= not (Reg1 or Reg2);
						  Neg <= '0';
                -- Do Boolean AND
                when "0000000000100000" =>
                    Result <= (Reg1 and Reg2);
						  Neg <= '0';
                -- Do Boolean OR
                when "0000000001000000" =>
                    Result <= (Reg1 xor Reg2);
						  Neg <= '0';
                -- Do Boolean XOR
                when "0000000010000000" =>
                    Result <= (Reg1 or Reg2);
						  Neg <= '0';
                -- Do Boolean XNOR
                when "0000000100000000" =>
                    Result <= not (Reg1 xor Reg2);
						  Neg <= '0';
                -- Default: do nothing
                when OTHERS =>
                    Result <= "--------";
						   Neg <= '0';
            end case;
        end if;
    end process;

    -- Split the 8-bit Result output into two 4-bit halves
    R1 <= Result(3 downto 0);   -- lower 4 bits
    R2 <= Result(7 downto 4);   -- upper 4 bits

end calculation;
