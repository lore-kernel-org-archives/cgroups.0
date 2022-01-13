From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT
Date: Thu, 13 Jan 2022 14:08:10 +0100
Message-ID: <YeAkOm0YsAe5jFRb@linutronix.de>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-2-bigeasy@linutronix.de>
 <20220105141653.GA6464@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1642079291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fYgLEwvs5VRdvN1sFaMXFPXbTNezugG6bv5lyd4Ctj4=;
        b=v1uyQhmEmw9G5cmDCunfbkUxXr32EpMeccAD1gd6U6W+73VwRBiba9y14BQAX1/ZTUmJ1a
        d/3HnbGf2cgsuUnoe/WY2GSOkznC3Sn6RDV1PxEAXJHFTAZOzew+4s5qDV/qHlRoHq5T6I
        rwX/+EC6H/DVSeD2ut/PazZ8EHI2P3r5tIG4CumOj/9RKKsPVano8a0FSrWBDd1GPxsbp8
        w6OKtu1+Bumi+4qS6RNrBRzhGSQanBDP2ue4KBTrewUcQcHL6f0uNLj0oIT0WTpgL6AzAs
        jkHTvMTUS+pvGd9s8D5lPHD6OsTaVXhe/fWrWopfUnGCcUgji65PAI5rUWWd8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1642079291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fYgLEwvs5VRdvN1sFaMXFPXbTNezugG6bv5lyd4Ctj4=;
        b=e8hxGV5XP7MuUwHHDk4O9a9OrESgBC00df0u70Hyf7ZMiqhZbPf1spzi+CdMAKxlt8sfKo
        jOqH5hlwCstqJcAw==
Content-Disposition: inline
In-Reply-To: <20220105141653.GA6464-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 2022-01-05 15:16:53 [+0100], Michal Koutn=C3=BD wrote:
> On Wed, Dec 22, 2021 at 12:41:09PM +0100, Sebastian Andrzej Siewior <bige=
asy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> > The sections with disabled preemption must exclude
> > memcg_check_events() so that spinlock_t locks can still be acquired
> > (for instance in eventfd_signal()).
>=20
> The resulting construct in uncharge_batch() raises eybrows. If you can de=
couple
> per-cpu updates from memcg_check_events() on PREEMPT_RT, why not tackle
> it the same way on !PREEMPT_RT too (and have just one variant of the
> block)?

That would mean that mem_cgroup_event_ratelimit() needs a
local_irq_save(). If that is okay then sure I can move it that way.

> (Actually, it doesn't seem to me that memcg_check_events() can be
> extracted like this from the preempt disabled block since
> mem_cgroup_event_ratelimit() relies on similar RMW pattern.
> Things would be simpler if PREEMPT_RT didn't allow the threshold event
> handlers (akin to Michal Hocko's suggestion of rejecting soft limit).)

I added a preempt-disable() section restricted to RT to
mem_cgroup_event_ratelimit(). I had to exclude memcg_check_events() from
the block because of the spinlock_t locks involved down the road
(eventfd_signal() for instance).

I remember Michal (Hocko) suggested excluding/ rejecting soft limit but
I didn't know where exactly and its implications. In this block here I
just followed the replacement of irq-off with preempt-off for RT.

> Thanks,
> Michal

Sebastian
