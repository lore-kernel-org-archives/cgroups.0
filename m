From: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Subject: Split process across multiple schedulers?
Date: Mon, 14 Mar 2022 15:19:56 +0000
Message-ID: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 weald.air.saab.se 22EFJvQC027332
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=saabgroup.com;
        s=weald; t=1647271197;
        bh=NMfKos0nNiB4Oz0OvKT1xPjH3pw3nC156jsh/mE4gqA=;
        h=From:To:Subject:Date:From;
        b=KhboJGrOoKjVSprJ1Ht/lodOSl1Qq7upDHE+RDdylmnRszT66GbthShl941htHTzx
         C9iikMaFooKa6oodzHo4wwnSrH5zb4fb+7XAGVa/8SKK4NpolKoq2s9Gu8E+bXGsOR
         sTo3igf9yXe690SmXcPATsG4l9H9CB0ejoOrK5As=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi!

I have tried reading the documentation for CGroups V1 and V2 and it seems t=
hat there is one usecase that we are interested in that *is* supported by C=
Groups V1 but not by CGroups V2. I really hope that I have overlooked somet=
hing and you can tell med to RTFM. ;)

Assume that you want to have a virtual machine running on at least one core=
. Connected to the VM you need to also have a VMM (Virtual Machine Monitor)=
 that acts as some sort of glue between KVM and the Guest in the VM. For in=
stance Virtual Box on Linux uses QEmu as its VMM. Within the VM each virtua=
l core is connected to a thread in the Host computer, and usually you want =
to have a 1:1 mapping between virtual core threads and physical cores.

Preferably for optimal performance you want to isolate the cores where the =
virtual core threads are running so nothing else interferes with them (besi=
des kernel threads connected to IRQs that can't be moved from the isolated =
cores). The VMM is then running on another core that is not running a virtu=
al core thread. CGroups is the preferred way of accomplishing this. :)

The virtual core threads need to have some parent process and the VMM proce=
ss is the natural home of for these threads. My understanding of CGroups V1=
 is that it is possible to have one scheduler associated  there are use cas=
es where you might want to have one kind of scheduler for the VMM process (=
for instance CFS) and another scheduler for the virtual core threads (for i=
nstance FIFO).

My conclusion after reading the documentation for CGroups V2 is that the ab=
ove scenario is no longer possible to do. Or have I misunderstood something=
 here?


A bit more detailed background after the general idea behind my question. A=
ssume that the software running within the VM is an old Windows 98 game you=
 have the license key for (for instance SimCity 3000). The developers of Si=
mCity 3000 didn't anticipate that you would want to run the game on a compu=
ter that was several times faster than what existed at its release. Music p=
lays fine, but when you try to scroll around when zoomed in using the curso=
r keys on the keyboard (or the mouse by placing the mouse pointer on the ed=
ge of the screen) the scrolling speed is inhumanly fast. Basically the game=
 is no longer enjoyable to play. It runs too fast.

Trying to slow it down using a tool like cpulimit is way too coarse; the mu=
sic is no longer possible to listen to as it is played in bursts. However i=
f you instead have a specially designed scheduler that tries to execute a p=
rogram with a configured "slow-down"-factor (each scheduling tick you ensur=
e that it is executed only a fraction of that tick) then you could get it t=
o run with a just about right speed. However you do not want to slow down V=
MM with the same scheduler and thus you want to be able to set different sc=
hedulers for different threads within a single process (assuming that they =
are running on different cores).

And yes, there are other applications for this besides running old games. ;=
)
=20
