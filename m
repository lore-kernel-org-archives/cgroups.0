From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT
Date: Thu, 13 Jan 2022 15:48:03 +0100
Message-ID: <20220113144803.GB28468@blackbody.suse.cz>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-2-bigeasy@linutronix.de>
 <20220105141653.GA6464@blackbody.suse.cz>
 <YeAkOm0YsAe5jFRb@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642085284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3/KiLmbu2FzwjS6g8oZPwe01R3SCJm9aWDvcjh1V1oQ=;
        b=UzapisG0u9pfLMsgBm15bvLIVl8KzGhzBfs+l22qSgE6/NiXDdINQLc9ShJjoGYF6NyL9D
        N0xgRz4dE6ou/b3G6Wy9yCq0nhAhI9RuklR4BmHJ3fpvuILBLV8j0uSQ+Fxm90ImIleIm8
        CxA7xma/OBgwkBbt+v3yd6LtJRSqOe8=
Content-Disposition: inline
In-Reply-To: <YeAkOm0YsAe5jFRb-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Jan 13, 2022 at 02:08:10PM +0100, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> I added a preempt-disable() section restricted to RT to
> mem_cgroup_event_ratelimit().

Oh, I missed that one.

(Than the decoupling of such mem_cgroup_event_ratelimit() also makes
some more sense.)
> That would mean that mem_cgroup_event_ratelimit() needs a
> local_irq_save(). If that is okay then sure I can move it that way.

Whatever avoids the twisted code :-)

---

> I remember Michal (Hocko) suggested excluding/ rejecting soft limit but
> I didn't know where exactly and its implications. In this block here I
> just followed the replacement of irq-off with preempt-off for RT.

Both soft limit and (these) event notifications are v1 features. Soft
limit itself is rather considered even misfeature. I guess the
implications would not be many since PREEMPT_RT+memcg users would be
new(?) so should rather start with v2 anyway.

One way to disable it would be to reject writes into
memory.soft_limit_in_bytes or cgroup.event_control + documentation of
that.

Michal
