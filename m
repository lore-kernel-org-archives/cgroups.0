From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/4] memcg: synchronously enforce memory.high for large overcharges
Date: Fri, 11 Feb 2022 12:36:33 -0800
Message-ID: <CALvZod6FwcSyi3B-3fkw4e+7BGrjFF2iRLEZVeurLp2+v-k-dg@mail.gmail.com>
References: <20220211064917.2028469-1-shakeelb@google.com> <20220211064917.2028469-5-shakeelb@google.com>
 <YgZS+YijLo0/WmEd@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CCAsjj+/2EPlyUQtiVo8WDkzcxXnQjrZ0PEqMW7wI0o=;
        b=ppE7RooPi4WL00e0ZLJbFk100+IS02OV5QywrNLcKaCJbEtR4YxukPIudnLp8SeKMe
         1NpTHSxW8chgPGf7JOY4Ea15KZrCmewdQuJqeHkqMC3F2oB8XRhcoJdjL6j9/F+7f8WJ
         uUAPTnA1DepzO0Qt+pe0IQN9d9vuPEWAghF7tyEwP6gcUibW6u7V60dsZ2Om7MgSwh3u
         hnqtLmgCUXP8KKVYUrxRFdwOov2m9joI3QdDjxk8pE/fUxhg1L3y/BZJCLku2CDajQza
         5EbbCjrTyKK1IaSFwD9Kfjiz5aTiqTn7xQlm4sYnrDALmXTu3uE6ySHxWdrZ9XJkKkF2
         1Hdw==
In-Reply-To: <YgZS+YijLo0/WmEd-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 11, 2022 at 4:13 AM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
[...]
> >To make high limit enforcement more robust, this patch makes the limit
> >enforcement synchronous only if the accumulated overcharge becomes
> >larger than MEMCG_CHARGE_BATCH. So, most of the allocations would still
> >be throttled on the return-to-userspace path but only the extreme
> >allocations which accumulates large amount of overcharge without
> >returning to the userspace will be throttled synchronously. The value
> >MEMCG_CHARGE_BATCH is a bit arbitrary but most of other places in the
> >memcg codebase uses this constant therefore for now uses the same one.
>
> Note that mem_cgroup_handle_over_high() has its own allocator throttling grace
> period, where it bails out if the penalty to apply is less than 10ms. The
> reclaim will still happen, though. So throttling might not happen even for
> roughly MEMCG_CHARGE_BATCH-sized allocations, depending on the overall size of
> the cgroup and its protection.
>

Here by throttling, I meant both reclaim and
schedule_timeout_killable(). I don't want to say low level details
which might change in future.

[...]
>
> Thanks, I was going to comment on v1 that I prefer to keep the implementation
> of mem_cgroup_handle_over_high if possible since we know that the mechanism has
> been safe in production over the past few years.
>
> One question I have is about throttling. It looks like this new
> mem_cgroup_handle_over_high callsite may mean that throttling is invoked more
> than once on a misbehaving workload that's failing to reclaim since the
> throttling could be invoked both here and in return to userspace, right? That
> might not be a problem, but we should think about the implications of that,
> especially in relation to MEMCG_MAX_HIGH_DELAY_JIFFIES.
>

Please note that mem_cgroup_handle_over_high() clears
memcg_nr_pages_over_high and if on the return-to-userspace path
mem_cgroup_handle_over_high() finds that memcg_nr_pages_over_high is
non-zero, then it means the task has further accumulated the charges
over high limit after a possibly synchronous
memcg_nr_pages_over_high() call.

> Maybe we should record if throttling happened previously and avoid doing it
> again for this entry into kernelspace? Not certain that's the right answer, but
> we should think about what the new semantics should be.

For now, I will keep this as is and will add a comment in the code and
a mention in the commit message about it. I will wait for others to
comment before sending the next version and thanks for taking a look.
