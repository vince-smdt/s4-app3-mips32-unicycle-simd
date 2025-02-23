---------------------------------------------------------------------------------------------
--
--	Université de Sherbrooke 
--  Département de génie électrique et génie informatique
--
--	S4i - APP4 
--	
--
--	Auteur: 		Marc-André Tétrault
--					Daniel Dalle
--					Sébastien Roy
-- 
---------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; -- requis pour la fonction "to_integer"
use work.MIPS32_package.all;

entity MemInstructions is
Port ( 
    i_addresse 		: in std_logic_vector (31 downto 0);
    o_instruction 	: out std_logic_vector (31 downto 0)
);
end MemInstructions;

architecture Behavioral of MemInstructions is
    signal ram_Instructions : RAM(0 to 255) := (
------------------------
-- Insérez votre code ici
------------------------

-- acs
X"F0800000", -- lwv $tv0, 0($a0)        -- met => $tv0
X"F0A10000", -- lwv $tv1, 0($a1)        -- sinput => $tv1
X"3C081001", -- lui $t0, 0x1001
X"20080060", -- addi $t0, $zero, 0x60
X"F1020000", -- lwv $tv2, 0($t0)        -- 250 => $tv2
X"",         -- addvs $tv2, $tv0, $t1   -- temp = met+sinput[j]
X"",         -- sltv $tv3, $tv2, $tv1   -- temp < soutput
X"74821800", -- movnv $tv4, $tv2, $tv3  -- soutput = temp < soutput ? temp : output
X"ECC40000", -- swv $tv4, 0($a2)        -- save soutput -- 111011 00110 00100 00000 00000 000000
X"03E00008", -- jr $ra

------------------------
-- Fin de votre code
------------------------
    others => X"00000000"); --> SLL $zero, $zero, 0  

    signal s_MemoryIndex : integer range 0 to 255;

begin
    -- Conserver seulement l'indexage des mots de 32-bit/4 octets
    s_MemoryIndex <= to_integer(unsigned(i_addresse(9 downto 2)));

    -- Si PC vaut moins de 127, présenter l'instruction en mémoire
    o_instruction <= ram_Instructions(s_MemoryIndex) when i_addresse(31 downto 10) = (X"00400" & "00")
                    -- Sinon, retourner l'instruction nop X"00000000": --> AND $zero, $zero, $zero  
                    else (others => '0');

end Behavioral;

