From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 16:00:49 -0400
Message-ID: <55DB77F1.5080802@gmail.com>
References: <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020001050609050906070008"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:message-id
         :disposition-notification-to:date:user-agent:mime-version
         :in-reply-to:content-type;
        bh=AGJSMJ+wTXiYk3TpDjlazsNBZsh6QofYzmnNyejdPAA=;
        b=cBxWl+N0xuNk2mB0rwejq2iUqMqTPFDyt/p9amMBN62SncxWwrQLUcFLQ2ptp0E5OY
         mCQNtso8CNBGMz/wXgi14x2kHyTiSSUHBVuP2AAphpSsD59EjO2Fv1r5N5upgDCB5XQF
         5zYsKQbBM5dXt7m206HqypoPHukia8rYMfc666/bUqWPn0vTGpBrSb1yjgUBpV0NUBUq
         Btwgrx/Es2Di1r8/c9nlUdWBO7itTuKjLxxIu9x1AnDADLB+laQVsK6ihtJd/Ik4sWsf
         6pgMJE0JzUSve6gK77mLkEf2pFTcizd2bvv8LgfoTBeNUIOJcMMLaXif3t8sDUzGBVyY
         aMQA==
In-Reply-To: <20150824170427.GA27262-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

This is a cryptographically signed message in MIME format.

--------------ms020001050609050906070008
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-24 13:04, Tejun Heo wrote:
> Hello, Austin.
>
> On Mon, Aug 24, 2015 at 11:47:02AM -0400, Austin S Hemmelgarn wrote:
>>> Just to learn more, what sort of hypervisor support threads are we
>>> talking about?  They would have to consume considerable amount of cpu=

>>> cycles for problems like this to be relevant and be dynamic in number=
s
>>> in a way which letting them competing against vcpus makes sense.  Do
>>> IO helpers meet these criteria?
>>>
>> Depending on the configuration, yes they can.  VirtualBox has some rat=
her
>> CPU intensive threads that aren't vCPU threads (their emulated APIC th=
read
>> immediately comes to mind), and so does QEMU depending on the emulated=

>
> And the number of those threads fluctuate widely and dynamically?
It depends, usually there isn't dynamic fluctuation unless there is a=20
lot of hot[un]plugging of virtual devices going on (which can be the=20
case for situations with tight host/guest integration), but the number=20
of threads can vary widely between configurations (most of the VM's I=20
run under QEMU have about 16 threads on average, but I've seen instances =

with more than 100 threads).  The most likely case to cause wide and=20
dynamic fluctuations of threads would be systems set up to dynamically=20
hot[un]plug vCPU's based on system load (such systems have other issues=20
to contend with also, but they do exist).
>> hardware configuration (it gets more noticeable when the disk images a=
re
>> stored on a SAN and served through iSCSI, NBD, FCoE, or ATAoE, which i=
s
>> pretty typical usage for large virtualization deployments).  I've seen=
 cases
>> first hand where the vCPU's can make no reasonable progress because th=
ey are
>> constantly getting crowded out by other threads.
>
> That alone doesn't require hierarchical resource distribution tho.
> Setting nice levels reasonably is likely to alleviate most of the
> problem.
In the cases I've dealt with this myself, nice levels didn't cut it, and =

I had to resort to SCHED_RR with particular care to avoid priority=20
inversions.
>> The use of the term 'hypervisor support threads' for this is probably =
not
>> the best way of describing the contention, as it's almost always a ful=
l
>> system virtualization issue, and the contending threads are usually st=
orage
>> back-end access threads.
>>
>> I would argue that there are better ways to deal properly with this (I=
solate
>> the non vCPU threads on separate physical CPU's from the hardware emul=
ation
>> threads), but such methods require large systems to be practical at an=
y
>> scale, and many people don't have the budget for such large systems, a=
nd
>> this way of doing things is much more flexible for small scale use cas=
es
>> (for example, someone running one or two VM's on a laptop under QEMU o=
r
>> VirtualBox).
>
> I don't know.  "Someone running one or two VM's on a laptop under
> QEMU" doesn't really sound like the use case which absolutely requires
> hierarchical cpu cycle distribution.
It depends on the use case.  I never have more than 2 VM's running on my =

laptop (always under QEMU, setting up Xen is kind of pointless ona quad=20
core system with only 8G of RAM), and I take extensive advantage of the=20
cpu cgroup to partition resources among various services on the host.



--------------ms020001050609050906070008
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI0MjAwMDQ5WjBPBgkq
hkiG9w0BCQQxQgRApaQxbeFV1GpnZZuINd9OnY4Sdxlnl1WvzUYZaAAgmFBjFUBlWJ4DEApo
sVqTLJCrF45Ry95LeaZRtrRx6mBlCjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBnwZQ54OE73swHLjI4VtAE/5bJuQirq2y61DuoQ8Kyl6Bd5VnH
ZtNyFDODEEUTKurSThroe0ldR9/70CpAVwJttL4bwmtc1KXLK+zewhCbBInGb9IAo8tirF5W
9QffWKlIHDC2PmVDdePUQBZGubKzgtb50/92G+FZQ0vSMoaVkjtZeNGn71kssMPiGKtSXCuq
/jZ9XWwlDjxDgNOSZE2Kh+3XjPz+AKpLoL/CB3PCHYb4UL9SSDIwofQbNhPviN7RjBPCQC0s
RFBbOeW0arxSRqVXFMVKGHlGJ+8horAC+w9tSGNWbo0LUF1Hq/YTsniFQagebKQ0m0+cnpny
SBRNKhZJWj8POWZ6NKsRWUtPhQDccYhtjAqR3It+FRmf0lkgxHYAoEqL+vvNkJ6B9lU9GEfv
YQCZvkL53d2idToWzJje978KBETdGNui3BNC4md+yElsS8lFc1vM+Dkcm7B5JKw1M0KD6ALF
9W2eYoibKYWquEhR0vZ56rMgonShnKoNMZANAG6EjPunFBYiGKbqv2VrrNxpgDduyQBUcMkR
hIkbQfN4/HYclYr2PXhYlJkTsTZhb87eUjooDLU7kCp7b2Mf7CSK/4J8Nxf8uACXTGA7nHZu
8fkRvDKzZ/CoTIucPzCFoWrzC8Og7kndfB28yBzqo5NCUSdBVr9GQs0oBwAAAAAAAA==
--------------ms020001050609050906070008--
