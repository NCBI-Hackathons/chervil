# CHERVIL

Computational Human Endogenous RetroViral Infection Landscape is a pipeline and analytical tool for detection of endogenous retroviral expression features that correspond to current or previous viral infection.


![image](image.png)


## What is CHERVIL and why do we need it?
Human endogenous retroviral elements (HERVs) are retroviruses that have integrated themselves into the human germline. Usually, they remain latent in the human genome. However, previous work suggests that some HERVs become actively transcribed upon viral infection. CHERVIL uses differential expression analysis of HERVs in healthy and infected populations via RNA-seq in  to detect pre-symptomatic or historic viral infection.

CHERVIL builds on an existing pipeline built for HERV detection [RetroSpotter](https://github.com/NCBI-Hackathons/RetroSpotter) and adds on a machine learning component to identify patterns in HERV expression specific to distinct viral infections.

## Overview Diagram of Workflow

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="1074px" version="1.1" content="&lt;mxfile userAgent=&quot;Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6&quot; version=&quot;8.8.6&quot; editor=&quot;www.draw.io&quot; type=&quot;device&quot;&gt;&lt;diagram name=&quot;Page-1&quot; id=&quot;efa7a0a1-bf9b-a30e-e6df-94a7791c09e9&quot;&gt;5VjLcpswFP0aL9sBERO8jF2n6Uwy7cRpmy4VuIAagYgQ2O7X9wqEMYU0nakfmdgLo/sQuo9zBGLkzJLVR0mz+EYEwEfEClYj58OIEHtMbLxozbrWTDy3VkSSBcapVSzYLzBKy2gLFkDecVRCcMWyrtIXaQq+6uiolGLZdQsF766a0Qh6ioVPeV/7nQUqNlrbnbSGK2BRbJb2yHlteKD+YyRFkZr1RsQJq19tTmhzL5NoHtNALLdUznzkzKQQqh4lqxlwXdumbPW8y2esm7glpOqfJhCTUa7WTfIQYC2MKKSKRSRSyuetduoXsgR9BxuFKttKslCKVcKNAVZM3W+Nf2iX92MtpUqu782MSmhtP0GptUEELZRAVRvEtRCZuWMdto712dSNKheF9Bsv+8zAicoIGj97sik9QhpEAhgSOkngVLGyuwI12Io2fm19cWBK/Ey5m+VLygtoIOJyDGQaCowbsUpNrO5ToVEwvSghZbKVcRTp652kae5LlimMQ2cuRcg4soZYAuFmxYBg01lQBCOGkIbIFKiHAStZUFCeN4tj4PX69b17mOg2eRkzBYusjnSJW0C38RGneW5cfZEw34w3YNcCxspnggtZLeAEFLzQ105KikfYsri+Bw/hJqgSpILV33ve7+Ryi8Vjw714i8C2Ze2gu4490N09sWvfPJkM8MSxhqu7B55MdsaTC86iFCdczW+/Vc+RKuAQMH9f8yagij7QXA9LRvH/hkbMfze9vljcnQo9zATiOPWU9R+sOBB9nDdDH8caog85FH2a5XdAn08BJspCHSeqaKLBXP+j5qmgjdHQC1aZhDxnIt3w6RbDF4tMKAXyxAh15h6XUOO3QygyRKizgxGK7IxQ81LwUj9tfA1bFjLNCqvIWRrh9e7L51N76riT45Jkd6/kX/NeX6t9MIWledE4sdZOyFFbS9y9bXev83DrDWySBzzcej0m3Q6/aFcHVP3GkL9K5GtqXtKEcQ1bQ/b/44PBPzkw/u1eeV/G/4uQt96fj7dQb3cwb2wN7A9xUh0EvXco0Dc73HH2GPuV7DF7KjeK7bfQyrb1wdmZ/wY=&lt;/diagram&gt;&lt;/mxfile&gt;" onclick="(function(svg){var src=window.event.target||window.event.srcElement;while (src!=null&amp;&amp;src.nodeName.toLowerCase()!='a'){src=src.parentNode;}if(src==null){if(svg.wnd!=null&amp;&amp;!svg.wnd.closed){svg.wnd.focus();}else{var r=function(evt){if(evt.data=='ready'&amp;&amp;evt.source==svg.wnd){svg.wnd.postMessage(decodeURIComponent(svg.getAttribute('content')),'*');window.removeEventListener('message',r);}};window.addEventListener('message',r);svg.wnd=window.open('https://www.draw.io/?client=1&amp;lightbox=1&amp;edit=_blank');}}})(this);" viewBox="0 0 1074 311" style="cursor:pointer;max-width:100%;max-height:311px;"><defs/><g transform="translate(0.5,0.5)"><path d="M 150.17 49.82 Q 190.6 49.82 190.6 99.88 Q 190.6 149.94 226.59 149.94" fill="none" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><path d="M 231.84 149.94 L 224.84 153.44 L 226.59 149.94 L 224.84 146.44 Z" fill="#000000" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><rect x="0" y="0" width="150" height="100" fill="#dae8fc" stroke="#6c8ebf" pointer-events="none"/><g transform="translate(0.5,28.5)"><switch><foreignObject style="overflow:visible;" pointer-events="all" width="146" height="40" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; font-size: 12px; font-family: Helvetica; color: rgb(0, 0, 0); line-height: 1.2; vertical-align: top; width: 146px; white-space: normal; word-wrap: normal; text-align: center;"><div xmlns="http://www.w3.org/1999/xhtml" style="display:inline-block;text-align:inherit;text-decoration:inherit;"><font face="Avenir">Transcriptome profiles of heathy and infected individuals</font></div></div></foreignObject><text x="73" y="26" fill="#000000" text-anchor="middle" font-size="12px" font-family="Helvetica">[Not supported by viewer]</text></switch></g><path d="M 383 150 Q 383 150 456.63 150" fill="none" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><path d="M 461.88 150 L 454.88 153.5 L 456.63 150 L 454.88 146.5 Z" fill="#000000" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><rect x="233" y="100" width="150" height="100" fill="#dae8fc" stroke="#6c8ebf" pointer-events="none"/><g transform="translate(233.5,135.5)"><switch><foreignObject style="overflow:visible;" pointer-events="all" width="146" height="26" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; font-size: 12px; font-family: Helvetica; color: rgb(0, 0, 0); line-height: 1.2; vertical-align: top; width: 146px; white-space: normal; word-wrap: normal; text-align: center;"><div xmlns="http://www.w3.org/1999/xhtml" style="display:inline-block;text-align:inherit;text-decoration:inherit;"><font face="Avenir">Align HERV to reference database via Magic-BLAST</font></div></div></foreignObject><text x="73" y="19" fill="#000000" text-anchor="middle" font-size="12px" font-family="Helvetica">[Not supported by viewer]</text></switch></g><path d="M 613 150 Q 613 150 686.63 150" fill="none" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><path d="M 691.88 150 L 684.88 153.5 L 686.63 150 L 684.88 146.5 Z" fill="#000000" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><rect x="463" y="100" width="150" height="100" fill="#dae8fc" stroke="#6c8ebf" pointer-events="none"/><g transform="translate(463.5,128.5)"><switch><foreignObject style="overflow:visible;" pointer-events="all" width="146" height="40" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; font-size: 12px; font-family: Helvetica; color: rgb(0, 0, 0); line-height: 1.2; vertical-align: top; width: 146px; white-space: normal; word-wrap: normal; text-align: center;"><div xmlns="http://www.w3.org/1999/xhtml" style="display:inline-block;text-align:inherit;text-decoration:inherit;"><font face="Avenir">Identify &amp; quantify HERV expression via RetroSpotter</font></div></div></foreignObject><text x="73" y="26" fill="#000000" text-anchor="middle" font-size="12px" font-family="Helvetica">[Not supported by viewer]</text></switch></g><path d="M 843 150 Q 843 150 916.63 150" fill="none" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><path d="M 921.88 150 L 914.88 153.5 L 916.63 150 L 914.88 146.5 Z" fill="#000000" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><rect x="693" y="100" width="150" height="100" fill="#dae8fc" stroke="#6c8ebf" pointer-events="none"/><g transform="translate(693.5,135.5)"><switch><foreignObject style="overflow:visible;" pointer-events="all" width="146" height="26" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; font-size: 12px; font-family: Helvetica; color: rgb(0, 0, 0); line-height: 1.2; vertical-align: top; width: 146px; white-space: normal; word-wrap: normal; text-align: center;"><div xmlns="http://www.w3.org/1999/xhtml" style="display:inline-block;text-align:inherit;text-decoration:inherit;"><font face="Avenir">Evolve classifier using TPOT</font></div></div></foreignObject><text x="73" y="19" fill="#000000" text-anchor="middle" font-size="12px" font-family="Helvetica">&lt;font face="Avenir"&gt;Evolve classifier using TPOT&lt;/font&gt;</text></switch></g><rect x="923" y="100" width="150" height="100" fill="#dae8fc" stroke="#6c8ebf" pointer-events="none"/><g transform="translate(927.5,142.5)"><switch><foreignObject style="overflow:visible;" pointer-events="all" width="138" height="12" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; font-size: 12px; font-family: Helvetica; color: rgb(0, 0, 0); line-height: 1.2; vertical-align: top; width: 139px; white-space: nowrap; word-wrap: normal; text-align: center;"><div xmlns="http://www.w3.org/1999/xhtml" style="display:inline-block;text-align:inherit;text-decoration:inherit;"><font face="Avenir">Use classifier on new data</font></div></div></foreignObject><text x="69" y="12" fill="#000000" text-anchor="middle" font-size="12px" font-family="Helvetica">&lt;font face="Avenir"&gt;Use classifier on new data&lt;/font&gt;</text></switch></g><path d="M 150.17 250.05 Q 190.6 250.05 190.6 199.99 Q 190.6 149.94 226.59 149.94" fill="none" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><path d="M 231.84 149.94 L 224.84 153.44 L 226.59 149.94 L 224.84 146.44 Z" fill="#000000" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><rect x="0" y="200" width="150" height="100" fill="#dae8fc" stroke="#6c8ebf" pointer-events="none"/><g transform="translate(0.5,235.5)"><switch><foreignObject style="overflow:visible;" pointer-events="all" width="146" height="26" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; font-size: 12px; font-family: Avenir; color: rgb(0, 0, 0); line-height: 1.2; vertical-align: top; width: 146px; white-space: normal; word-wrap: normal; text-align: center;"><div xmlns="http://www.w3.org/1999/xhtml" style="display:inline-block;text-align:inherit;text-decoration:inherit;">Reference database of HERVs</div></div></foreignObject><text x="73" y="19" fill="#000000" text-anchor="middle" font-size="12px" font-family="Avenir">Reference database of HERVs</text></switch></g><path d="M 111.67 300.11 L 111.67 300.11" fill="none" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><path d="M 111.67 300.11 L 111.67 300.11 L 111.67 300.11 L 111.67 300.11 Z" fill="#000000" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><path d="M 150.17 250.05 Q 150.17 250.05 150.17 250.05" fill="none" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/><path d="M 150.17 250.05 L 150.17 250.05 L 150.17 250.05 L 150.17 250.05 Z" fill="#000000" stroke="#000000" stroke-miterlimit="10" pointer-events="none"/></g></svg>

### RetroSpotter Plus
* Utilize RetroSpotter to identify differentially expressed HERVs in infected populations
    + Supply SRA accession numbers for expression dataset of healthy and infection of interest samples
    + Supply database of HERV sequences of interest
* Generate HERV1 count dataframe
* Apply machine learning to identify HERV expression patterns specific to viral infection using [TPOT](https://github.com/EpistasisLab/tpot).

## How to use CHERVIL

1. Input .csv file with two columns: accession numbers and their classifications.
```csv
SRR123456, infected
SRR789101, infected
SRR112131, infected
SRR415161, control
SRR718192, control
SRR021222, control
```
(note: these are made-up accessions)

2. Simple one line command to generate HERV count data
3. Other use info here?

## Installation
### Requirements

You will need the following:

1. R
2. Python 3.6
3. A sense of adventure

### Instructions

First, clone a copy of the repository:

    $ git clone https://github.com/NCBI-Hackathons/chervil.git

and then `cd` into it:

    $ cd chervil

Odds are that you will want to run CHERVIL in a [virtual environment](https://virtualenv.pypa.io/en/stable/). If you don't have virtualenv installed, run:

    $ pip install virtualenv

And then to set up your shiny new virtual environment:

    $ virtualenv env --python=python3.6
    $ source env/bin/activate

Next, to install the Python components, run:

    (env) $ pip install -r requirements.txt

Optionally, [install XGBoost](https://xgboost.readthedocs.io/en/latest/build.html) (**highly recommended**). This will dramatically improve the quality of your classifier.

## Example Run
### Example Dataset
* PRJNA349748: Human Tracheobronchial Epithelial (HTBE) cells infected with Influenza
    + Data Type: RNA-seq
    + Conditions / Samples: H1N1, H5N1, H3N2, mock-infected controls
