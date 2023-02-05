From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Sun, 5 Feb 2023 11:49:13 -0800
Message-ID: <Y+AIOQy0HdVXCw8m@P9FQF9L96D>
References: <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
 <Y9LDAZmApLeffrT8@tpad>
 <Y9LQ615H13RmG7wL@dhcp22.suse.cz>
 <0122005439ffb7895efda7a1a67992cbe41392fe.camel@redhat.com>
 <Y9j9BnMwfm4TJks7@tpad>
 <Y9pd7AxAILUSHrpe@dhcp22.suse.cz>
 <28e08669302ad1e7a41bdf8b9988de6a352b5fe1.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675626564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zCXR2fdD5KUizgsD+r8xIXos+I6YOtrXfgJwLA6SDKs=;
        b=EiKIcs3Klx+YgeINRkbrjeT48IQMnlUunMLev5pz3djUhjV6YTD/1jYT489gdALY33FZCx
        dSbnndEJe4EaJCa9nw0etCNxIxWraIHACeTmUQS0DGR5VCNsZsBBcLx7vhAaIdbA07JJPu
        9kXpNSVt5VA+kI0R8AAL2XXGsKB+Ues=
Content-Disposition: inline
In-Reply-To: <28e08669302ad1e7a41bdf8b9988de6a352b5fe1.camel@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, Marcelo Tosatti <mtosatti@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hi Leonardo!

> Yes, but we are exchanging an "always schedule_work_on()", which is a kin=
d of
> contention, for a "sometimes we hit spinlock contention".
>=20
> For the spinlock proposal, on the local cpu side, the *worst case* conten=
tion
> is:
> 1 - wait the spin_unlock() for a complete <percpu cache drain process>,
> 2 - wait a cache hit for local per-cpu cacheline=A0
>=20
> What is current implemented (schedule_work_on() approach), for the local
> cpu=A0side there is *always* this contention:
> 1 - wait for a context switch,
> 2 - wait a cache hit from it's local per-cpu cacheline,
> 3 - wait a complete <percpu cache drain process>,=A0
> 4 - then for a new context switch to the current thread.

I think both Michal and me are thinking of a more generic case in which the=
 cpu
is not exclusively consumed by 1 special process, so that the draining work=
 can
be executed during an idle time. In this case the work is basically free.

And the introduction of a spin_lock() on the hot path is what we're are con=
cerned
about. I agree, that on some hardware platforms it won't be that expensive,=
 but
in general not having any spinlocks is so much better.

>=20
> So moving from schedule_work_on() to spinlocks will save 2 context switch=
es per
> cpu every time drain_all_stock() is called.
>=20
> On the remote cpu side, my tests point that doing the remote draining is =
faster
> than scheduling a local draining, so it's also a gain.
>=20
> Also, IIUC the possible contention in the spinlock approach happens only =
on
> page-faulting and syscalls, versus the schedule_work_on() approach that c=
an
> interrupt user workload at any time.=A0
>=20
> In fact, not interrupting the user workload in isolated cpus is just a bo=
nus of
> using spinlocks.

I believe it significantly depends on the preemption model: you're right re=
garding
fully preemptive kernels, but with voluntary/none preemption it's exactly o=
pposite:
the draining work will be executed at some point later (probably with 0 cos=
t),
while the remote access from another cpu will potentially cause delays on t=
he
spin lock as well as a need to refill the stock.

Overall I'd expect a noticeable performance regression from an introduction=
 of
spin locks and remote draining. Maybe not on all platforms, but at least on=
 some.
That's my main concern. And I don't think the problem we're aiming to solve=
 here
justifies this potential regression.

Thanks!
