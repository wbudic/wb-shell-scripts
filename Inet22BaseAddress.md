# Internet Math Base 22 Number

Storage and conversion from int decimal to base 22 number creates an alternative to using current form of 127.0.0.1.
Former being more human readable. The IMB22 format is yet shorter in length and faster to compare, to store and operate.

Notice - This document is not part of any know standards to author. It has been put in public domain, for better understanding any further works or research.

## Obtaining the IMB22 Number

* The following script shows how to convert to and from an localhost 127.0.0.1 address.

```perl

perl -le ' use Math::Int2Base qw(int2base base2int);
    $i=3;
    $u += ($_<<8*$i--) for "127.0.0.1" =~ /(\d+)/g;    
    print "INTIP:$u";
    $imb=int2base($u,22);
    print "IMB22:$imb";
    $int10=base2int($imb, 22);
    print "INT10:$int10";
'
```

* The above prints:

```bash
INTIP:2130706433
IMB22:IH9DK09
INT10:2130706433
```

* Where INTIP: *2130706433* is the decimal number of the 127.0.0.1, and IMB22: *IH9DK09* is the base 22 one version.
* 255.255.255.255 Example:

```bash
echo "255.255.255.255" | perl -le '
use Math::Int2Base qw(int2base base2int);
    $i=3;while(<STDIN>){print $ADR.=$_};
    $u += ($_<<8*$i--) for $ADR =~ /(\d+)/g;
    print "INTIP:$u";
    $imb=int2base($u,22);
    print "IMB22:$imb";
'
255.255.255.255

INTIP:4294967295
IMB22:1FJ8B183

```

* So -> 255.255.255.255 == *1FJ8B183*
* How about 192.168.0.1?
  
```bash
echo "192.168.0.1" | perl -le '
use Math::Int2Base qw(int2base base2int);
$i=3;while(<>){print $ADR.=$_};
$u += ($_<<8*$i--) for $ADR =~ /(\d+)/g;
print "INTIP:$u";
$imb=int2base($u,22);
print "IMB22:$imb";
$int10=base2int($imb, 22);
print "INT10:$int10";
'
192.168.0.1

INTIP:3232235521
IMB22:16B3J6C9
INT10:3232235521
```

* 192.168.0.1 == *16B3J6C9*, And *1FJ8B183* > *16B3J6C9*
  * Check:

    ```bash
    perl -le "use Math::Int2Base qw(int2base base2int); 
    print base2int('1FJ8B183',22) > base2int('16B3J6C9',22)?'true':'false'"

    ```

## Valid Internet Host Mask Number Range

**Sorry -> This Section Is Under Development**

## Historical Significance of Twenty-Two

* logₐ(X) -> X=10, a=10, b=22 == 1 (From x=1..10, is 0..1 *10* numbers with up to 3 decimal places precision.
* logₐ(X) -> X=100, a=10, b=22 == 2 (From x=1..100, is 0..2 *100* numbers with up to 3 decimal places precision.
* logₐ(X) -> X=1000, a=10, b=22 == 3


### General
(For following the origin source was -> <https://www.ridingthebeast.com/numbers/nu22.php>)

* The 22 elements by which God created the world.
* At his Ascension, by twenty-two times Jesus blesses the creation.
* The Word of God is at the 22th level of conscience. The cosmic conscience would subdivide indeed into 24 dimensional or spiritual levels. The maximal conscience level, the 24th, would be attributable only to the God-Father and the 23th level would be considered as being an energy protective area surrounding the level 24. The 22th level of conscience would be also that of the antique Elohim also named the 24 Ancients.
* Twenty-two is the number of biblical books of the Old Testament - Hebrews and Protestants. This number is obtained by counting for only one book the twelve minor prophets, as well as the Judges, the Kings, Ezra, the Chronicles (each one being generally divided into two books). It is also necessary to integrate Ruth with the Judges and the Lamentations with Jeremiah. And it is thanks to this last restriction that we obtain finally 22 instead of 24. Flavius Joseph (Against Apion, I, 8, 1st s.) is the first one to have proposed a distribution in 22 books.
* The Mezuzah contains fifteen verses of the last book the Old Testament, the Deuteronomy, VI, 4-9 and XI, 13-21, for a total of 170 words, always written in 22 lines. This small roll is inserted in a tube of wood or metal and is attached to the superior right side on the frame of a door, according to the commandment of the Bible: "And you will write them on the frame of the door of your house" .

* The 22 chapters of the Vendidad, book of the Avesta, written by Zarathustra.

* The 22 prayers ("Yeshts") of the "Khorda-Avesta".

* The Chronos god was surrounded by 22 main assistants and 22 secondary, according to the Phoenician Sanchoniaton.

* For the Muslives, the Koran is the recording of the oral revelation authorized by the grace of God to the Prophet of Islam during almost 22 years, in the beginning of the seventh century of the Christian era - from 610 to 632.

* According to S. Doucet and J.-P. Larosee, the man is composed twenty-two evolutionary bodies gathered in four categories: subtle body, energy body, galactic body and temporal body. Each one of these 22 bodies is formed of 1296 "partitions" that they call circumferences, vibrating each one at a precise frequency. This number 1296 is called "Energizing number", since it is the product of 12 (Cosmic number) and 108 (Universal number). By multiplying 22 by 1296, they obtain the total number of 28512 circumferences composing the 22 evolutionary bodies of the man, that is according to them the number of the man and also that of Infinite Energy.

* Several old alphabets had twenty-two letters: Chaldean, Sabean, Roman, Copt and Hebraic. The letters of the Hebraic alphabet are divided into three mother letters (Aleph, Mem, Shin), seven double letters (Beth, Guimel, Daleth, Kaph, Phe, Resh, Tau) twelve simple letters (He, Waw, Zain, Heth, Teth, Yod, Lamed, Nun, Samekh, Ayin, Tzade, Qoph).

* According to saint Yves of Alveydre, the primitive alphabet of all the humanity, at the period of "Ram" (adam alphabet or "Watan"), would have comprised 22 signs.

* Salemi points out that the Hebrew Candelabra includes 22 chalices, 22 apples and 22 flowers by counting the point superior of the axis.

* "From the twenty-two great Masters that counted the "Templiers Order" since its creation to its term, seven lost the life in combats; five died of their wounds, one of voluntary fast, having fallen to hands of infidels. Finally, James Molay had to be burnt alive under Philip the Bel, but the Order was dissolved when this crime occurred. It is therefore on the whole thirteen great Masters in function who paid of their existence the honor to command the soldiers of Christ." (John Carpentier)

* The 22 cards of the Tarot - 22 mysteries major.

* The Cosmos would shelter 22 Super-Universe.

* The totality of mystical knowledge is contained in the symbolic of the first twenty-two numbers, according to Bambaras.

* The initiation of Pythagoras with the Egyptian priests lasted 22 years.

* The twenty-two channels linking the ten "Sephiroth" between them in the "sephirotic Tree" of the Cabal.

* According to some mediumnic revelations, it would exist 22 main stars where all the entities will pass to achieve the complete cycle of their evolution.

* Twenty-two is the number of writable regular polygons in an Euclidiean circle: 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 24, 30, 36, 40, 45, 60, 72, 90, 120, 180, 360. These are twenty-two of the twenty-four dividers of 360, the two first, 1 and 2, not defining polygons.

* Length of the cubit in number of fingers, for Bambaras, which corresponds to the totality of the categories of the creation: this cubit from Bambaras represents therefore the universe.

* Number of total stars of which is composed the Little Bear. However, only seven of them are visible to the naked eye.

* 22 divided by 7 gives the number "pi", which represents the mysterious and approximate ratio of the perimeter of a circle to its diameter.

* The head of the man is constituted of 22 bones: 8 for the cranium and 14 for the face.

* Anniversary of marriage: weddings of ebony.

### Gematria

The shout of alert "22!" was used by the typographers warning thus the arrival of the chief of workshop. 
The number is obtained by addition of the numerical value of each letter of the French word "chef" (chief) 
according to their position in the Latin alphabet: C=3, H=8, E=5 and F=6.

### Released: v.1.0 Date:20210629

   This document has been written by Will Budic and is from the project ->  <https://github.com/wbudic/wb-shell-scripts>