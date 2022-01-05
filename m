From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT
Date: Wed, 5 Jan 2022 15:16:53 +0100
Message-ID: <20220105141653.GA6464@blackbody.suse.cz>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641392214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+WLxA9/1x+7qLb1Bx+bH8yfotWhgKxpBD6Y91WrBPbQ=;
        b=PAV1YMrbk39la/pf4jUdMUxaJx7luCh/1FN7SIUMJSyUYitC0PrA9E1VgkCh4UraOVmpCW
        +8BmyHXXMxdMUUZt92yHwdC6UfUeiVDIiLcYDZZKA7x/dKlQYzcwlFtdozw5tMUSedbc0s
        dEWuIryro2F81voSW5mEdShvjMtk74A=
Content-Disposition: inline
In-Reply-To: <20211222114111.2206248-2-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Dec 22, 2021 at 12:41:09PM +0100, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> The sections with disabled preemption must exclude
> memcg_check_events() so that spinlock_t locks can still be acquired
> (for instance in eventfd_signal()).

The resulting construct in uncharge_batch() raises eybrows. If you can decouple
per-cpu updates from memcg_check_events() on PREEMPT_RT, why not tackle
it the same way on !PREEMPT_RT too (and have just one variant of the
block)?

(Actually, it doesn't seem to me that memcg_check_events() can be
extracted like this from the preempt disabled block since
mem_cgroup_event_ratelimit() relies on similar RMW pattern.
Things would be simpler if PREEMPT_RT didn't allow the threshold event
handlers (akin to Michal Hocko's suggestion of rejecting soft limit).)

Thanks,
Michal
