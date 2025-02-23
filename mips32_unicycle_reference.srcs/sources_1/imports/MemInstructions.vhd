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

--  TestMirroir
--X"20100024",
--X"3C081001", -- Load Upper dans $t0 10010000
--X"3C091001", -- Load Upper dans $t1
--X"21290004", -- $t1 += 4 => 10010004
--X"F1010000", -- Read registre vectoriel à l'adresse $t0 dans $tv1
--X"ED210000", -- Write registre vectoriel $tv1 dans $t1
--X"3c011001",
--X"00300821",
--X"8c240000",
--X"0004c820",
--X"0c100007",
--X"08100015",
--X"00805020",
--X"00001020",
--X"200cffff",
--X"340b8000",
--X"000b5c00",
--X"20090020",
--X"11200006",
--X"00021042",
--X"014b4024",
--X"00481025",
--X"000a5040",
--X"2129ffff",
--X"0810000d",
--X"03e00008",
--X"00402820",
--X"22100004",
--X"3c011001",
--X"00300821",
--X"ac220000",
--X"2002000a",
--X"0000000c",

X"20100024",
X"3c011001",
X"00300821",
X"8c240000",
X"0004c820",
X"0c100007",
X"08100015",
X"00805020",
X"00001020",
X"200cffff",
X"340b8000",
X"000b5c00",
X"20090020",
X"11200006",
X"00021042",
X"014b4024",
X"00481025",
X"000a5040",
X"2129ffff",
X"0810000d",
X"03e00008",
X"00402820",
X"22100004",
X"3c011001",
X"00300821",
X"ac220000",
X"2002000a",
X"0000000c",


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

