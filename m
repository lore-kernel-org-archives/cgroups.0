From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 11:47:02 -0400
Message-ID: <55DB3C76.5010009@gmail.com>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020402090409010007050801"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:message-id
         :disposition-notification-to:date:user-agent:mime-version
         :in-reply-to:content-type;
        bh=rw9gNssYft/wY1xDr766/ECcnUjbJNSB5vlVqhNdxEg=;
        b=INxAzcU79i4Zpwl75UPlSehGs3IOvErFlcJwmv00bd92DnOtFNg2BrMfmy8ZsYlflH
         TaS/PjDL7rT05WpEMnqUHMjASmwL2zelBsGUGtcslrVtPLY/1GIYzsK1PJstNc4Zr7Y3
         zoJuBn+N6KuQGahnyhePYqD3db1hFHoQeGM7wLHqYlrF3z2vpEH41Mgi3UvEW9Bvbwua
         9grXOBAJq23dtkERHfsAV90eCGHPapo6e0v8LTSPA7TcgGzWxX2A2uKNhjBH54wgApJc
         Vg31MXxZj1bOGvY1Y5ihHHFhWYzDyqccFWJtlRNqopwhi9V7Kusu6jCYhAEJBNYt7DwK
         mRhw==
In-Reply-To: <20150822182916.GE20768-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

This is a cryptographically signed message in MIME format.

--------------ms020402090409010007050801
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-22 14:29, Tejun Heo wrote:
> Hello, Paul.
>
> On Fri, Aug 21, 2015 at 12:26:30PM -0700, Paul Turner wrote:
> ...
>> A very concrete example of the above is a virtual machine in which you=

>> want to guarantee scheduling for the vCPU threads which must schedule
>> beside many hypervisor support threads.   A hierarchy is the only way
>> to fix the ratio at which these compete.
>
> Just to learn more, what sort of hypervisor support threads are we
> talking about?  They would have to consume considerable amount of cpu
> cycles for problems like this to be relevant and be dynamic in numbers
> in a way which letting them competing against vcpus makes sense.  Do
> IO helpers meet these criteria?
>
Depending on the configuration, yes they can.  VirtualBox has some=20
rather CPU intensive threads that aren't vCPU threads (their emulated=20
APIC thread immediately comes to mind), and so does QEMU depending on=20
the emulated hardware configuration (it gets more noticeable when the=20
disk images are stored on a SAN and served through iSCSI, NBD, FCoE, or=20
ATAoE, which is pretty typical usage for large virtualization=20
deployments).  I've seen cases first hand where the vCPU's can make no=20
reasonable progress because they are constantly getting crowded out by=20
other threads.

The use of the term 'hypervisor support threads' for this is probably=20
not the best way of describing the contention, as it's almost always a=20
full system virtualization issue, and the contending threads are usually =

storage back-end access threads.

I would argue that there are better ways to deal properly with this=20
(Isolate the non vCPU threads on separate physical CPU's from the=20
hardware emulation threads), but such methods require large systems to=20
be practical at any scale, and many people don't have the budget for=20
such large systems, and this way of doing things is much more flexible=20
for small scale use cases (for example, someone running one or two VM's=20
on a laptop under QEMU or VirtualBox).


--------------ms020402090409010007050801
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI0MTU0NzAyWjBPBgkq
hkiG9w0BCQQxQgRAB8ppBwNqD55wrvs+F1aV23SQsVtz2beZ0iD5dT55zrMzixSdqjmFDl4h
G58M2rMKrVpjSC2xZiHrWA4KffRiBjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBSzT2svp/Sm0G21sUU7Ioezq/y4k3hGZxRnLspiLgeFKo01pLv
cZTDGzljkpsMovdmsachHdMGsFhXhSE30X9x/vbbNYLiSyG015Cg8PdC5Ze3qr1sM1PgySDC
KKl88z2PjHHr2s6ccTfSewEpsxbNu8GyeXLrUzT5LlS2Q25ZHMHHnUFGC5wwiyDsJP6zfpDj
iW0Jza69UlI92gF+7nAWNBrhkqqbnrttSyU2Ucu5gOL9oXmeZATFKmMiE5OnzBjyHZ9lWCBK
YUJfKp6U7EHpE3ir9SJy1nFFZojyvA8XPZVZbETGBs3KnmtU+8xGJpRfo6NRRIWuEWQOl3Ke
UH5qq2el06oHLpdWa4gEqr0hrLTXuMYziz+zwalbgDE+s8OPAmi2gfGqN48OWFMtQNT+tXfa
9/QnyxTfZVz75jd9uhHsHWCk6dne4/3g6q9d0A8GiLUqWAlr4hC/0DA7EDTmgOvIfM+4UI9a
Y5ZbM/uqVqhEFrC+SM7iSomnEM7ZGo7hE9k3jDCfGQW4uHICJmcHbZk1xS3aKe6J5NY7zjW/
cAs5Yxw+LKNT5s92dwFL5J+mYdkryJkzytAUuJT0wtdfTeXJKVTuyL+v34Ry1okL8rpmFmvp
XKaTdPzzxdbQK42neqWRA9l1qEgtPVh19g+R5utyIKqYXaO9BsA6MOxA7gAAAAAAAA==
--------------ms020402090409010007050801--
