From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 2/4] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Wed, 26 Jan 2022 12:24:25 +0100
Message-ID: <YfEvaeCXoL+I3z05@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-3-bigeasy@linutronix.de>
 <86eeed07-b7dc-b387-ea4d-1a4a41334fe3@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643196266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=22UvY86Kfs4AbFGAcdoC8Kdx7cTmd+khf9zUEu3+8JU=;
        b=Y7kQkiCmXIll4GHMf/OXPjc7GbWHeMX4BK6a60kJv+OtHkOlHBIWzwoVlUecRRVSGLleqq
        xN0exkry7H3DhKWYBAycSgPYGE2nREK85PvJSSZxiqEwLbP6yfMYNXD5gZ55/XBHzBmUs4
        P5epcx+y7dqy9Xh40pdCjwKrEjd2oIik+PPGmirzfJptqanxbweSltevfnCAEPTRKX1SQS
        +rCwDQj4W6YDWwWg/dIVUcbg93Z+K6M+K1jYKCoApUGInNkLU3HyDMlZTwmgYAD0CJ9I1W
        WbI5qs2CetZVCe6yGPVfH8hNPVtZ9r/MWOdLmkXCfF47Y5uXtGvABUB4uvnOrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643196266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=22UvY86Kfs4AbFGAcdoC8Kdx7cTmd+khf9zUEu3+8JU=;
        b=igt4CRlkzJpPqZFeay9GJE8KSEMkn9bNkM5J8GrPivTBxt7zcI40CakmKrJraSCsziuMtB
        dBEtsKhIHBrZkxCQ==
Content-Disposition: inline
In-Reply-To: <86eeed07-b7dc-b387-ea4d-1a4a41334fe3-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2022-01-26 11:06:40 [+0100], Vlastimil Babka wrote:
> So it's like c68ed7945701 ("mm/vmstat: protect per cpu variables with
> preempt disable on RT") but we still don't want a wrapper of those
> constructs so they don't spread further, right :)

Right. We only have them because of assumption based on spin_lock_irq()
which are not true on PREEMPT_RT. Having a generic one might let people
to use them for the wrong reasons.
The commit you mentioned changed all users while here I only changed
those which missed it. Also I wasn't sure if preemption should be
disabled or interrupts (to align with the other local_irq_save()).

> Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Thank you.

Sebastian
