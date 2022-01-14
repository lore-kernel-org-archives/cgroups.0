From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT
Date: Fri, 14 Jan 2022 10:09:35 +0100
Message-ID: <YeE9zyUokSY9L2ZI@linutronix.de>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-2-bigeasy@linutronix.de>
 <20220105141653.GA6464@blackbody.suse.cz>
 <YeAkOm0YsAe5jFRb@linutronix.de>
 <20220113144803.GB28468@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1642151377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+Si0XJr5oFNQer8Hglx3KPVt6lkZ6RKg12n+qYdLpI=;
        b=RwooFruNFLsHCSO275wabcot+DSjrha0x1w6ecguFCmXlQS5QH0oflEEeC27XOUPg1dtFP
        8zT+z2T5dWLQovWP1HeMd00xl42HvA77sUiJ0/pOhrVAHQfuvj+N56H4t+mwlmvA1dj8xM
        pXzMhSuCJ2KcnCNetFZmntp2dq628DEKaht9B63045pMNGhKVZp55cIm5SH+9DFDf5LaiG
        IjHILvL1KmzRF7adK4BLpU3h7CHlBVKcot8one6JEowWVP8sHg5mwFxo6TWoSkDI8TjeG8
        zVOfSbxSys8l9ucexNadniaKja6ruv9kPb8B88koLXYyLOlCoUEIcJFNhVmjSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1642151377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+Si0XJr5oFNQer8Hglx3KPVt6lkZ6RKg12n+qYdLpI=;
        b=I4ZS6gpi10OqmERf2Vkqp4ZPPFgo7Q5w72tXKKeEBLVRzK6yVYnVlkkD+ONCVkREMg8FuJ
        k5BrrTjoPTaXxVBA==
Content-Disposition: inline
In-Reply-To: <20220113144803.GB28468-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 2022-01-13 15:48:03 [+0100], Michal Koutn=C3=BD wrote:
> On Thu, Jan 13, 2022 at 02:08:10PM +0100, Sebastian Andrzej Siewior <bige=
asy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> > I added a preempt-disable() section restricted to RT to
> > mem_cgroup_event_ratelimit().
>=20
> Oh, I missed that one.
>=20
> (Than the decoupling of such mem_cgroup_event_ratelimit() also makes
> some more sense.)
> > That would mean that mem_cgroup_event_ratelimit() needs a
> > local_irq_save(). If that is okay then sure I can move it that way.
>=20
> Whatever avoids the twisted code :-)

Okay. So let me do that.

> ---
>=20
> > I remember Michal (Hocko) suggested excluding/ rejecting soft limit but
> > I didn't know where exactly and its implications. In this block here I
> > just followed the replacement of irq-off with preempt-off for RT.
>=20
> Both soft limit and (these) event notifications are v1 features. Soft
> limit itself is rather considered even misfeature. I guess the
> implications would not be many since PREEMPT_RT+memcg users would be
> new(?) so should rather start with v2 anyway.

People often migrate to RT so they take whatever they have. In general I
would like to keep RT & !RT in sync unless there are reasons to do it
differently.

> One way to disable it would be to reject writes into
> memory.soft_limit_in_bytes or cgroup.event_control + documentation of
> that.

So avoiding these two also avoids memcg_check_events()?
Right now it does not look like a big obstacle. It is the same pattern
I'm following for the per-CPU RMW. If it is, I could avoid the writes
and if0 the other function for RT.
If I remove memcg_check_events() from the equation then we could keep
the explicit irq-off regions (plus add a few). The only that would look
odd then is that we disable interrupts for the RMW operation and
preemption in other places (__count_memcg_events() invocations in swap.c
and vmscan.c).=20

Are there plans to remove v1 or is this part of "we must not break
userland"?

> Michal

Sebastian
