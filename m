From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: Questions about replacing isolcpus by cgroup-v2
Date: Fri, 12 Nov 2021 16:36:56 +0100
Message-ID: <20211112153656.qkwyvdmb42ze25iw@linutronix.de>
References: <AM9PR10MB48692A964E3106D11AC0FDEE898D9@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636731417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9v4lZgCUQeGJScxnFs28hIj2fcB/Z1CFUoIPVSgG+0U=;
        b=pepmbIai6RJczu32uCUBFxIA0UOl61CF5Zc5fZz7vo2ZPNR9cDHbXgT/RSyuRxrTGJh5ki
        zMvlvItRUcde5W0ZTm4ISrxIe0gbKEvZeiTx5JyRUDr52qbaKCQpxl8Kna48RRvMAIPtE9
        W09yT7eRBarO+9StsstyLjLZpbbOCl5D1+s00ifPkbpY2saDGJm5UuxVB/XMdXsJvmPuPk
        fE16z0umB2tEdD0i6Wmm8FC7bqsAEEODiZc1CpxVxAo+Ot4LMMXweMU8qvm5rLvgsE/hK5
        ypgLrW0BKhwCAxOYL6fdEAm976Z7fXMFuavFKsUYvA02JbXLBc3VX3UewCtwTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636731417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9v4lZgCUQeGJScxnFs28hIj2fcB/Z1CFUoIPVSgG+0U=;
        b=qJFDWGseH2rn5g/egDMjy5G9VmngorvJvEb821mCYdvSAHY8OQhPxPEJTZvojT0boMJpjm
        vJEtYfNvmxYcGlDQ==
Content-Disposition: inline
In-Reply-To: <AM9PR10MB48692A964E3106D11AC0FDEE898D9-M49tMopaQCDO+/9PLUklKbUAtUbAAahqZmpNikb/MY7jO8Y7rvWZVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Moessbauer, Felix" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org" <henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org" <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "Schmidt, Adriaan" <adriaan.schmidt-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 2021-11-04 17:29:08 [+0000], Moessbauer, Felix wrote:
> Dear subscribers,
Hi,

I Cced cgroups@vger since thus question fits there better.
I Cced Frederic in case he has come clues regarding isolcpus and
cgroups.

> we are currently evaluating how to rework realtime tuning to use cgroup-v=
2 cpusets instead of the isolcpus kernel parameter.
> Our use-case are realtime applications with rt and non-rt threads. Hereby=
, the non-rt thread might create additional non-rt threads:
>=20
> Example (RT CPU=3D1, 4 CPUs):
> - Non-RT Thread (A) with default affinity 0xD (1101b)
> - RT Thread (B) with Affinity 0x2 (0010b, via set_affinity)
>=20
> When using pure isolcpus and cgroup-v1, just setting isolcpus=3D1 perfect=
ly works:
> Thread A gets affinity 0xD, Thread B gets 0x2 and additional threads get =
a default affinity of 0xD.
> By that, independent of the threads' priorities, we can ensure that nothi=
ng is scheduled on our RT cpu (except from kernel threads, etc...).
>=20
> During this journey, we discovered the following:
>=20
> Using cgroup-v2 cpusets and isolcpus together seems to be incompatible:
> When activating the cpuset controller on a cgroup (for the first time), a=
ll default CPU affinities are reset.
> By that, also the default affinity is set to 0xFFFF..., while with isolcp=
us we expect it to be (0xFFFF - isolcpus).
> This breaks the example from above, as now the non-RT thread can also be =
scheduled on the RT CPU.
>=20
> When only using cgroup-v2, we can isolate our RT process by placing it in=
 a cgroup with CPUs=3D0,1 and remove CPU=3D1 from all other cgroups.
> However, we do not know of a strategy to set a default affinity:
> Given the example above, we have no way to ensure that newly created thre=
ads are born with an affinity of just 0x2 (without changing the application=
).
>=20
> Finally, isolcpus itself is deprecated since kernel 5.4.

Where is this the deprecation of isolcpus announced/ written?

> Questions:
>=20
> 1. What is the best strategy to "isolcpus" similar semantics with cgroups=
-v2?
> 2. Is there a way to specify the default affinity (within a cgroup)
>=20
> We are currently at a point where we would write patches to add a default=
 affinity feature to cpusets of cgroupv2.
> But maybe that is not needed or would be the wrong direction, so we wante=
d to discuss first.
>=20
> Best regards,
> Felix M=C3=B6=C3=9Fbauer
> Siemens AG

Sebastian
