From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Date: Fri, 11 Mar 2022 17:00:51 +0100
Message-ID: <20220311160051.GA24796@blackbody.suse.cz>
References: <20220304184040.1304781-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647014453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SAaUOGAe1srGHsWHBvn1FZ7QUyxX7XpJoMnIGqLANGo=;
        b=JC9r4EOT7aEN0yB8Qf9FysIjDt/Lfq9D5zM4Ke/NbM9uN/KN1uAZpE5K4BgUSbilo63d9z
        ht/QmX4FXDK1KjhUAtCwUayHbXzLF9H3rBvvtmdT+W0F37+q8YPjroPqnmmlYH+VtrjBi7
        QtXDY6i3jI+KGH0cCUUGI9NsJFBQN9M=
Content-Disposition: inline
In-Reply-To: <20220304184040.1304781-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Frank Hofmann <fhofmann-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

TL;DR rstats are slow but accurate on reader side. To tackle the
performance regression no flush seems simpler than this patch.


So, I've made an overview for myself what were the relevant changes with
rstat introduction.
The amount of work is:
- before
  R: O(1)
  W: O(tree_depth)

- after
  R: O(nr_cpus * nr_cgroups(subtree) * nr_counters) 
  W: O(tree_depth)

That doesn't look like a positive change especially on the reader side.

(In theory, the reader's work would be amortized but as the original
report here shows, not all workloads are diluting the flushes
sufficiently. [1])

The benefit this was traded for was the greater accuracy, the possible
error is:
- before
  - O(nr_cpus * nr_cgroups(subtree) * MEMCG_CHARGE_BATCH)	(1)
- after
    O(nr_cpus * MEMCG_CHARGE_BATCH) // sync. flush
    or
    O(flush_period * max_cr) // periodic flush only		(2)
                             // max_cr is per-counter max change rate

So we could argue that if the pre-rstat kernels did just fine with the
error (1), they would not be worse with periodic flush if we can compare
(1) and (2). 

On Fri, Mar 04, 2022 at 06:40:40PM +0000, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> This patch fixes this regression by making the rstat flushing
> conditional in the performance critical codepaths. More specifically,
> the kernel relies on the async periodic rstat flusher to flush the stats
> and only if the periodic flusher is delayed by more than twice the
> amount of its normal time window then the kernel allows rstat flushing
> from the performance critical codepaths.

I'm not sure whether your patch attempts to solve the problem of
(a) periodic flush getting stuck or (b) limiting error on refault path.
If it's (a), it should be tackled more systematically (dedicated wq?).
If it's (b), why not just rely on periodic flush (self answer: (1) and
(2) comparison is workload dependent).

> Now the question: what are the side-effects of this change? The worst
> that can happen is the refault codepath will see 4sec old lruvec stats
> and may cause false (or missed) activations of the refaulted page which
> may under-or-overestimate the workingset size. Though that is not very
> concerning as the kernel can already miss or do false activations.

We can't argue what's the effect of periodic only flushing so this
newly introduced factor would inherit that too. I find it superfluous.


Michal

[1] This is worth looking at in more detail.

From the flush condition we have
  cr * Δt = nr_cpus * MEMCG_CHARGE_BATCH 
where Δt is time between flushes and cr is global change rate.

cr composes of all updates together (corresponds to stats_updates in
memcg_rstat_updated(), max_cr is change rate per counter)
  cr = Σ cr_i <= nr_counters * max_cr 

By combining these two we get shortest time between flushes:
  cr * Δt <= nr_counters * max_cr * Δt
  nr_cpus * MEMCG_CHARGE_BATCH <= nr_counters * max_cr * Δt
  Δt >= (nr_cpus * MEMCG_CHARGE_BATCH) / (nr_counters * max_cr)

We are interested in 
  R_amort = flush_work / Δt
which is
  R_amort <= flush_work * nr_counters * max_cr / (nr_cpus * MEMCG_CHARGE_BATCH)

R_amort: O( nr_cpus * nr_cgroups(subtree) * nr_counters * (nr_counters * max_cr) / (nr_cpus * MEMCG_CHARGE_BATCH) )
R_amort: O( nr_cgroups(subtree) * nr_counters^2 * max_cr) / (MEMCG_CHARGE_BATCH) )

The square looks interesting given there are already tens of counters.
(As data from Ivan have shown, we can hardly restore the pre-rstat
performance on the read side even with mere mod_delayed_work().)
This is what you partially solved with introduction of NR_MEMCG_EVENTS
but the stats_updates was still sum of all events, so the flush might
have still triggered too frequently.

Maybe that would be better long-term approach, splitting into accurate
and approximate counters and reflect that in the error estimator stats_updates.

Or some other optimization of mem_cgroup_css_rstat_flush().


