From: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 09:56:08 -0700
Message-ID: <CAAPL-u_i-Mp-Bo7LtP_4aJscY=1JHG_y1H_-A7N_HRAgtz+arg@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com> <YkcEMdsi9G5y8mX4@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AocYHkt1MbaGb+EzbKia8sCXii4deKplOa2PaIkASDE=;
        b=YDqVBVNEE8HcVFjurxrYb5hOycjVTxK7fOeL/e4ZGq8suMwkA1++G6q7Opq8eNnXmv
         alhVqf6Q7sfMLjETKtpr386gqUSGhJX2C6o2VvqlJ8p7HtB5bwcIcNB0XRLlv6htt1PB
         6hec/drOZlO2WnMOaNRiPlu1yfFknBkU60wZ93cfloTZc/pNROVqNWR8vRewZz+ln2Yz
         GlgZw6Iv28fbArfWaavfo1YtdgqBkQ2LbR1nzQx/nUEoG9vwDenS8VHv7x3IpHv6BiGC
         VOvSWmSoJUdtRtes52igqYpgxtIqlBQo6hHyvFe36ewT2/HlDIhhe/hMWBPT6zWryEwJ
         /Aqg==
In-Reply-To: <YkcEMdsi9G5y8mX4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Apr 1, 2022 at 6:54 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 31-03-22 08:41:51, Yosry Ahmed wrote:
> > From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
> >
> > Use case: Proactive Reclaim
> > ---------------------------
> >
> > A userspace proactive reclaimer can continuously probe the memcg to
> > reclaim a small amount of memory. This gives more accurate and
> > up-to-date workingset estimation as the LRUs are continuously
> > sorted and can potentially provide more deterministic memory
> > overcommit behavior. The memory overcommit controller can provide
> > more proactive response to the changing behavior of the running
> > applications instead of being reactive.
> >
> > A userspace reclaimer's purpose in this case is not a complete replacement
> > for kswapd or direct reclaim, it is to proactively identify memory savings
> > opportunities and reclaim some amount of cold pages set by the policy
> > to free up the memory for more demanding jobs or scheduling new jobs.
> >
> > A user space proactive reclaimer is used in Google data centers.
> > Additionally, Meta's TMO paper recently referenced a very similar
> > interface used for user space proactive reclaim:
> > https://dl.acm.org/doi/pdf/10.1145/3503222.3507731
> >
> > Benefits of a user space reclaimer:
> > -----------------------------------
> >
> > 1) More flexible on who should be charged for the cpu of the memory
> > reclaim. For proactive reclaim, it makes more sense to be centralized.
> >
> > 2) More flexible on dedicating the resources (like cpu). The memory
> > overcommit controller can balance the cost between the cpu usage and
> > the memory reclaimed.
> >
> > 3) Provides a way to the applications to keep their LRUs sorted, so,
> > under memory pressure better reclaim candidates are selected. This also
> > gives more accurate and uptodate notion of working set for an
> > application.
> >
> > Why memory.high is not enough?
> > ------------------------------
> >
> > - memory.high can be used to trigger reclaim in a memcg and can
> >   potentially be used for proactive reclaim.
> >   However there is a big downside in using memory.high. It can potentially
> >   introduce high reclaim stalls in the target application as the
> >   allocations from the processes or the threads of the application can hit
> >   the temporary memory.high limit.
> >
> > - Userspace proactive reclaimers usually use feedback loops to decide
> >   how much memory to proactively reclaim from a workload. The metrics
> >   used for this are usually either refaults or PSI, and these metrics
> >   will become messy if the application gets throttled by hitting the
> >   high limit.
> >
> > - memory.high is a stateful interface, if the userspace proactive
> >   reclaimer crashes for any reason while triggering reclaim it can leave
> >   the application in a bad state.
> >
> > - If a workload is rapidly expanding, setting memory.high to proactively
> >   reclaim memory can result in actually reclaiming more memory than
> >   intended.
> >
> > The benefits of such interface and shortcomings of existing interface
> > were further discussed in this RFC thread:
> > https://lore.kernel.org/linux-mm/5df21376-7dd1-bf81-8414-32a73cea45dd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> >
> > Interface:
> > ----------
> >
> > Introducing a very simple memcg interface 'echo 10M > memory.reclaim' to
> > trigger reclaim in the target memory cgroup.
> >
> >
> > Possible Extensions:
> > --------------------
> >
> > - This interface can be extended with an additional parameter or flags
> >   to allow specifying one or more types of memory to reclaim from (e.g.
> >   file, anon, ..).
> >
> > - The interface can also be extended with a node mask to reclaim from
> >   specific nodes. This has use cases for reclaim-based demotion in memory
> >   tiering systens.
> >
> > - A similar per-node interface can also be added to support proactive
> >   reclaim and reclaim-based demotion in systems without memcg.
> >
> > For now, let's keep things simple by adding the basic functionality.
>
> Yes, I am for the simplicity and this really looks like a bare minumum
> interface. But it is not really clear who do you want to add flags on
> top of it?
>
> I am not really sure we really need a node aware interface for memcg.
> The global reclaim interface will likely need a different node because
> we do not want to make this CONFIG_MEMCG constrained.

A nodemask argument for memory.reclaim can be useful for memory
tiering between NUMA nodes with different performance.  Similar to
proactive reclaim, it can allow a userspace daemon to drive
memcg-based proactive demotion via the reclaim-based demotion
mechanism in the kernel.

> > [yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org: refreshed to current master, updated commit
> > message based on recent discussions and use cases]
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> All that being said. I haven't been a great fan for explicit reclaim
> triggered from the userspace but I do recognize that limitations of the
> existing interfaces is just too restrictive.
>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>
> Thanks!
> --
> Michal Hocko
> SUSE Labs
