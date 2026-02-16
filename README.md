# CMUdict

CMUdict (the Carnegie Mellon Pronouncing Dictionary) is a free
pronouncing dictionary of English, suitable for uses in speech
technology and is maintained by the Speech Group in the School of
Computer Science at Carnegie Mellon University.

**Official Homepage:** http://www.speech.cs.cmu.edu/cgi-bin/cmudict

The Carnegie Mellon Speech Group does not guarantee the accuracy of
this dictionary, nor its suitability for any specific purpose. In
fact, we expect a number of errors, omissions and inconsistencies to
remain in the dictionary. We intend to continually update the
dictionary by correction existing entries and by adding new ones. From
time to time a new major version will be released.

We welcome input from users: Please send email to Alex Rudnicky
(air+cmudict@cs.cmu.edu).

The Carnegie Mellon Pronouncing Dictionary, in its current and
previous versions is Copyright (C) 1993-2014 by Carnegie Mellon
University.  Use of this dictionary for any research or commercial
purpose is completely unrestricted.  If you make use of or
redistribute this material we request that you acknowledge its
origin in your descriptions.

If you add words to or correct words in your version of this
dictionary, we would appreciate it if you could send these additions
and corrections to us (air+cmudict@cs.cmu.edu) for consideration in a
subsequent version. All submissions will be reviewed and approved by
the current maintainer, Alex Rudnicky at Carnegie Mellon.


## About ARPABET

ARPABET (also known as ARPAbet) is a phonetic transcription code
developed by Advanced Research Projects Agency (ARPA) as a part of
their Speech Understanding Research project in the 1970s. The name
ARPABET is directly derived from ARPANET, the precursor to the modern
Internet, as both were projects funded by ARPA (now DARPA).

The CMU Pronouncing Dictionary uses ARPABET as its phonetic notation
system because:

1. ARPABET was specifically designed for American English speech
   recognition and synthesis applications.

2. It uses a simple ASCII-based encoding system that is both
   machine-readable and human-readable, making it ideal for
   computational linguistics applications.

3. It provides a standardized way to represent the approximately 39
   phonemes of American English using 1-2 letter codes, with stress
   markers (0, 1, 2) for vowels.

4. Its historical connection to speech research makes it well-suited
   for speech technology applications, which is the primary purpose
   of this dictionary.


## Speech Synthesis Applications

The CMUdict ARPABET encoding is widely used in various speech
synthesis systems:

Azure Speech Services: Microsoft Azure's English speech synthesis
services support ARPABET phonetic notation (alongside SAPI phonetics)
for precise pronunciation control in Speech Synthesis Markup Language
(SSML). This allows developers to specify exact pronunciations using
the same phonetic system as CMUdict.

For more information on phonetic sets in Azure Speech Services, see:
https://docs.azure.cn/en-us/ai-services/speech-service/speech-ssml-phonetic-sets


## Phoneme Mapping to IPA

### Microsoft SAPI Phoneme to IPA Symbol Mapping (American English)

For applications that need to convert between ARPABET/SAPI phonemes (used in CMUdict)
and IPA (International Phonetic Alphabet) symbols, here is a mapping example:

```python
SAPI_TO_IPA = {
    # Vowels
    "AA": "ɑ",
    "AE": "æ",
    "AH": "ʌ",
    "AO": "ɔ",
    "AW": "aʊ",
    "AY": "aɪ",
    "EH": "ɛ",
    "ER": "ɝ",
    "EY": "eɪ",
    "IH": "ɪ",
    "IY": "i",
    "OW": "oʊ",
    "OY": "ɔɪ",
    "UH": "ʊ",
    "UW": "u",
    # Consonants
    "B":  "b",
    "CH": "tʃ",
    "D":  "d",
    "DH": "ð",
    "F":  "f",
    "G":  "ɡ",
    "HH": "h",
    "JH": "dʒ",
    "K":  "k",
    "L":  "l",
    "M":  "m",
    "N":  "n",
    "NG": "ŋ",
    "P":  "p",
    "R":  "ɹ",
    "S":  "s",
    "SH": "ʃ",
    "T":  "t",
    "TH": "θ",
    "V":  "v",
    "W":  "w",
    "Y":  "j",
    "Z":  "z",
    "ZH": "ʒ",
}
```


## Additional Resources

NPM Package: A JavaScript/Node.js implementation of the CMU
Pronouncing Dictionary is available:
https://www.npmjs.com/package/cmu-pronouncing-dictionary
