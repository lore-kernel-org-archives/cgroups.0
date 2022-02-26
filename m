From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive codepaths
Date: Fri, 25 Feb 2022 17:42:57 -0800
Message-ID: <CALvZod7SA17vounKnq1KX23172rztNN_Oo0K1XaeEuS4JVEhMw@mail.gmail.com>
References: <20220226002412.113819-1-shakeelb@google.com> <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PVUmr01vxo2MfeZIcVa242AyLzLGr7DmFOqnKspe5oo=;
        b=g7+3YvD71i4cYpDgsVXRs6VjOt3Np9OxZ/vd1UugXCCnnBMzSZ1u/kSQOgIzsv2RW7
         KTwGzMI7ijIz+tnxvMMLRvTVtizPUmJxNhHdWZeQUskYgbYwYdrSIbM+QpPqkGAlHfy2
         LdZM9ykzpQE3lLbLvVEmFW3X4f5AYqqCEen/v5MWGCQNWVPjmo7wXmGhy2kqZSBNKZPP
         oUGF6XnpafKrhrj8EaW65TOo3AfKd9PBClE0LNfewWSAfXfxtSao2EkVBplJOO1ffH65
         LK9yweKPr75iY/XsHxIoqk1/gDWy7/pRyIBR8vmRLw2mgrUhflfHqdTx+uqGhXAY3CX8
         I7mw==
In-Reply-To: <20220225165842.561d3a475310aeab86a2d653-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 25, 2022 at 4:58 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Fri, 25 Feb 2022 16:24:12 -0800 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > Daniel Dao has reported [1] a regression on workloads that may trigger
> > a lot of refaults (anon and file). The underlying issue is that flushing
> > rstat is expensive. Although rstat flush are batched with (nr_cpus *
> > MEMCG_BATCH) stat updates, it seems like there are workloads which
> > genuinely do stat updates larger than batch value within short amount of
> > time. Since the rstat flush can happen in the performance critical
> > codepaths like page faults, such workload can suffer greatly.
> >
> > The easiest fix for now is for performance critical codepaths trigger
> > the rstat flush asynchronously. This patch converts the refault codepath
> > to use async rstat flush. In addition, this patch has premptively
> > converted mem_cgroup_wb_stats and shrink_node to also use the async
> > rstat flush as they may also similar performance regressions.
>
> Gee we do this trick a lot and gee I don't like it :(
>
> a) if we're doing too much work then we're doing too much work.
>    Punting that work over to a different CPU or thread doesn't alter
>    that - it in fact adds more work.
>

Please note that we already have the async worker running every 2
seconds. Normally no consumer would need to flush the stats but if
there were too many stat updates from producers in a short amount of
time then one of the consumers will have to pay the price of the
flush.

We have two types of consumers i.e. performance critical (e.g.
refault) and non-performance critical (e.g. memory.stat or num_stat
readers). I think we can let the performance critical consumer skip
the synchronous flushing and the async worker do the work for
performance reasons.

> b) there's an assumption here that the flusher is able to keep up
>    with the producer.  What happens if that isn't the case?  Do we
>    simply wind up the deferred items until the system goes oom?
>

Without a consumer nothing bad can happen even if flusher is slow (or
it has too much work) or too many stats are being updated by many
producers.

With a couple of consumers, in the current kernel, one of them may
have to pay the cost of synch flush. With this patch, we will have two
types of consumers. First, who are ok to pay the price of sync flush
to get the accurate stats and second who are ok with out of sync stats
but bounded by 2 seconds (yes assuming flusher runs every 2 seconds).

BTW there is no concern of the system going into oom due to reading a
bit older stats.

>    What happens if there's a producer running on each CPU?  Can the
>    flushers keep up?
>
>    Pathologically, what happens if the producer is running
>    task_is_realtime() on a single-CPU system?  Or if there's a
>    task_is_realtime() producer running on every CPU?  The flusher never
>    gets to run and we're dead?
>

I think it has to be a mix of (stat) producers and (stat) consumers
which are hogging CPU forever and no, we will not be dead. At worst
the consumers might be making some wrong decisions due to consuming
older stats.

One can argue that since one consumer is reclaim code, some reclaim
heuristic can get messed up due to older stats. Yes, that can happen.

>
> An obvious fix is to limit the permissible amount of windup (to what?)
> and at some point, do the flushing synchronously anyway.
>

That is what we are currently doing. The limit being nr_cpus * MEMCG_BATCH.

> Or we just don't do any this at all and put up with the cost of the
> current code.  I mean, this "fix" is kind of fake anyway, isn't it?
> Pushing the 4-10ms delay onto a different CPU will just disrupt
> something else which wanted to run on that CPU.  The overall effect is
> to hide the impact from one particular testcase, but is the benefit
> really a real one?
>

Yes, the right fix would be to optimize the flushing code (but that
would require more work/time). However I still think letting
performance critical code paths to skip the sync flush would be good
in general. So, if the current patch is not to your liking we can
remove mem_cgroup_flush_stats() from workingset_refault().
