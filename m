From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 0/4] mm/memcg: Address PREEMPT_RT problems instead of
 disabling it.
Date: Tue, 25 Jan 2022 15:21:46 -0800
Message-ID: <20220125152146.d7e25afe3b8a6807df6fee3f@linux-foundation.org>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643152908;
        bh=Os2MWz5br1ib2WiO76xCA8LnZuVKJFmC7RaP9N/4r0o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yfnDC4j/A3Ze/Yu/Lo5vpOBBSb7WGzqzIQfb9aBKBYXUanxENNOYdhS5qgb+Snw2a
         Oo1sOfxKasHmBVZuza4/zG7vu2H3IWuBcYnNK9ooYWsgLOX359S4eIfxKjNvLsWJd6
         YIUFWvRtN68ay6Si4EByHUpFRiDgoz0U8tfpUMss=
In-Reply-To: <20220125164337.2071854-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, 25 Jan 2022 17:43:33 +0100 Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:

> Hi,
> 
> this series is a follow up to the initial RFC
>     https://lore.kernel.org/all/20211222114111.2206248-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
> 
> and aims to enable MEMCG for PREEMPT_RT instead of disabling it.
> 
> where it has been suggested that I should try again with memcg instead
> of simply disabling it.
> 
> Changes since the RFC:
> - cgroup.event_control / memory.soft_limit_in_bytes is disabled on
>   PREEMPT_RT. It is a deprecated v1 feature. Fixing the signal path is
>   not worth it.
> 
> - The updates to per-CPU counters are usually synchronised by disabling
>   interrupts. There are a few spots where assumption about disabled
>   interrupts are not true on PREEMPT_RT and therefore preemption is
>   disabled. This is okay since the counter are never written from
>   in_irq() context.
> 
> Patch #2 deals with the counters.
> 
> Patch #3 is a follow up to
>    https://lkml.kernel.org/r/20211214144412.447035-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> 
> Patch #4 restricts the task_obj usage to !PREEMPTION kernels. Based on
> the numbers in 
>    https://lore.kernel.org/all/YdX+INO9gQje6d0S-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org

This isn't a terribly useful [0/n], sorry.  It would be better to have
something self-contained which doesn't require that the reader chase
down increasingly old links and figure out what changed during
successive iterations.

> I tested them on CONFIG_PREEMPT_NONE + CONFIG_PREEMPT_RT with the
> tools/testing/selftests/cgroup/* tests. It looked good except for the
> following (which was also there before the patches):
> - test_kmem sometimes complained about:
>  not ok 2 test_kmem_memcg_deletion

Is this a new issue?

Does this happen with these patches when CONFIG_PREEMPT_RT=n?

> - test_memcontrol complained always about
>  not ok 3 test_memcg_min
>  not ok 4 test_memcg_low
>  and did not finish.

Similarly, is this caused by these patches?  Is it only triggered under
preempt_rt?

> - lockdep complains were triggered by test_core and test_freezer (both
>   had to run):

Ditto.


