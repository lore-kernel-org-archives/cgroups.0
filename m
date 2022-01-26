From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 0/4] mm/memcg: Address PREEMPT_RT problems instead of
 disabling it.
Date: Wed, 26 Jan 2022 08:30:26 +0100
Message-ID: <YfD4khP2Hr2U5//i@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125152146.d7e25afe3b8a6807df6fee3f@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643182228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9NZ3lJVnTo7mLG1upjj5vlqJmvStFoul39zOV2ksyiw=;
        b=YdF40EP8NbbaYR4CLObHjD/v1L3OyjJSpWu7WzHz2yclKAch8LWLxg6o1leUYjkVM4JwZR
        tfZNk4cgFU0TAlLhbJ0V9CmXx9TCxzi9xy0MhYPR+qJUP7zQLnvYgxric+KmJN2I06cXok
        NMTFJq3ypCS/P3dLap9wGu8Y4B6m5ogPtuzt99+zU3ILJ3UQJMZqRrEPrEqReyxpaf3QER
        JbUjrUW1vowb7PoT0GITodpBrtfHilSj8QFjd++QbsrWwhtJN6FdWmz9RRYvyufZWkQghi
        TvmGsQX/4/hl0ADe6yM248PvCvXRlwQzGopXMgpA5OmC+5oeMq4bdbBPK/06eg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643182228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9NZ3lJVnTo7mLG1upjj5vlqJmvStFoul39zOV2ksyiw=;
        b=W2T8DfnRpP/yM/quFoYVhVRZ0BnYogZZrluWaWuREyW1CnGUo2yehjAouXi5rt3hDPe9et
        X09WVcHB0qlhPuBA==
Content-Disposition: inline
In-Reply-To: <20220125152146.d7e25afe3b8a6807df6fee3f-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2022-01-25 15:21:46 [-0800], Andrew Morton wrote:
> On Tue, 25 Jan 2022 17:43:33 +0100 Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> 
> > Hi,
> > 
> > this series is a follow up to the initial RFC
> >     https://lore.kernel.org/all/20211222114111.2206248-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
> > 
> > and aims to enable MEMCG for PREEMPT_RT instead of disabling it.
> > 
> > where it has been suggested that I should try again with memcg instead
> > of simply disabling it.
> > 
> > Changes since the RFC:
> > - cgroup.event_control / memory.soft_limit_in_bytes is disabled on
> >   PREEMPT_RT. It is a deprecated v1 feature. Fixing the signal path is
> >   not worth it.
> > 
> > - The updates to per-CPU counters are usually synchronised by disabling
> >   interrupts. There are a few spots where assumption about disabled
> >   interrupts are not true on PREEMPT_RT and therefore preemption is
> >   disabled. This is okay since the counter are never written from
> >   in_irq() context.
> > 
> > Patch #2 deals with the counters.
> > 
> > Patch #3 is a follow up to
> >    https://lkml.kernel.org/r/20211214144412.447035-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > 
> > Patch #4 restricts the task_obj usage to !PREEMPTION kernels. Based on
> > the numbers in 
> >    https://lore.kernel.org/all/YdX+INO9gQje6d0S-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
> 
> This isn't a terribly useful [0/n], sorry.  It would be better to have
> something self-contained which doesn't require that the reader chase
> down increasingly old links and figure out what changed during
> successive iterations.

I'm sorry. I didn't want to copy the numbers and make the impression of
doing the numbers now on -rc1.
 
> > I tested them on CONFIG_PREEMPT_NONE + CONFIG_PREEMPT_RT with the
> > tools/testing/selftests/cgroup/* tests. It looked good except for the
> > following (which was also there before the patches):
> > - test_kmem sometimes complained about:
> >  not ok 2 test_kmem_memcg_deletion
> 
> Is this a new issue?

No, I saw it already on 5.16.0-rc5.

> Does this happen with these patches when CONFIG_PREEMPT_RT=n?

Yes. The problem reported by the test is independent of the series and
RT.

> > - test_memcontrol complained always about
> >  not ok 3 test_memcg_min
> >  not ok 4 test_memcg_low
> >  and did not finish.
> 
> Similarly, is this caused by these patches?  Is it only triggered under
> preempt_rt?

No. This happens regardless of these patches and RT.

> > - lockdep complains were triggered by test_core and test_freezer (both
> >   had to run):
> 
> Ditto.

Also happens regardless of these patches and RT. It does not happen
always so sometimes I had to run test_core and test_freezer a few times
until lockdep complained.

Sebastian
