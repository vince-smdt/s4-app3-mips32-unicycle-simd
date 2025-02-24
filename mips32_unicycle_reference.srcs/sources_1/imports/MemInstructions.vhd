---------------------------------------------------------------------------------------------
--
--	Universit� de Sherbrooke 
--  D�partement de g�nie �lectrique et g�nie informatique
--
--	S4i - APP4 
--	
--
--	Auteur: 		Marc-Andr� T�trault
--					Daniel Dalle
--					S�bastien Roy
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
-- Ins�rez votre code ici
------------------------

-- main
X"3c011001", -- la $a0, met
X"34240000",
X"3c011001", -- la $a1, sinput
X"34250040",
X"3c011001", -- la $a2, soutput
X"34260050",
X"0c100013", -- jar CalculSurvivant
X"2002000a", -- $v0 = 10
X"0000000c", -- syscall

-- acs
X"F0800000", -- lwv $tv0, 0($a0)        -- met => $tv0
X"8ca90000", -- lw $t1, 0($a1)          -- sinput[j] => $t1
X"3C081001", -- lui $t0, 0x1001
X"20080060", -- addi $t0, $zero, 0x60
X"F1020000", -- lwv $tv2, 0($t0)        -- 250 => $tv2
X"74404800", -- addvs $tv2, $tv0, $t1   -- temp = met+sinput[j]
X"FC620800", -- sltv $tv3, $tv2, $tv1   -- temp < soutput
X"74821800", -- movnv $tv4, $tv2, $tv3  -- soutput = temp < soutput ? temp : output
X"ECC40000", -- swv $tv4, 0($a2)        -- save soutput -- 111011 00110 00100 00000 00000 000000
X"03E00008", -- jr $ra

-- calcul survivant
X"23bdfff0",
X"afbf0004",
X"3c011001",
X"34240000",
X"afa40008",
X"3c011001",
X"34250040",
X"afa5000c",
X"3c011001",
X"34260050",
X"afa60010",
X"00008021",
X"20010004",
X"1030000a",
X"0c100009",
X"22100001",
X"8fa40008",
X"20840010",
X"afa40008",
X"8fa5000c",
X"20a50004",
X"afa5000c",
X"8fa60010",
X"0810001f",
X"8fbf0000",
X"23bd0010",
X"03e00008",

------------------------
-- Fin de votre code
------------------------
    others => X"00000000"); --> SLL $zero, $zero, 0  

    signal s_MemoryIndex : integer range 0 to 255;

begin
    -- Conserver seulement l'indexage des mots de 32-bit/4 octets
    s_MemoryIndex <= to_integer(unsigned(i_addresse(9 downto 2)));

    -- Si PC vaut moins de 127, pr�senter l'instruction en m�moire
    o_instruction <= ram_Instructions(s_MemoryIndex) when i_addresse(31 downto 10) = (X"00400" & "00")
                    -- Sinon, retourner l'instruction nop X"00000000": --> AND $zero, $zero, $zero  
                    else (others => '0');

end Behavioral;

