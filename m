From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH V1] mm: Disable demotion from proactive reclaim
Date: Wed, 23 Nov 2022 13:20:57 -0800
Message-ID: <CAHS8izN+xqM67XLT4y5qyYnGQMUWRQCJrdvf2gjTHd8nZ_=0sw@mail.gmail.com>
References: <20221122203850.2765015-1-almasrymina@google.com> <Y35fw2JSAeAddONg@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KgB35nu4bsdO3BRjzB71vDc5gogI51cR7qkBlnNkHoA=;
        b=RgUxytdJdEgfB4d1z2o+FdTqXryjzLvZ4nGRF+rSNbtAiNkj/xWRZCXnEjox3Qnzus
         ibYwfYLUb6vo6Ch7w2FllZzJR4GyBdOl1wo6nDO89NSiIiWNPsb+9CUw9zNf01MWuTnJ
         RdDrEnA2Jgkjv+Mfg/0Rnkttl2WaHuZQOqnJh5Dm5AaMts8LSC04yTsJiR/RqXB+TsdE
         x88zNb+4QJUQ0Rz6veIlgutL2dMskRBO8Ej/+jwwlOOpd781ex+ifKun2SDUVWfsZADZ
         s2tmYle4/MZIRDRw+fMyC1IAOXboaFxxgm7WPPnqKBTrGl9qzn5XX+EbX5Oi5AaUCwwn
         Hu0Q==
In-Reply-To: <Y35fw2JSAeAddONg-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Nov 23, 2022 at 10:00 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Hello Mina,
>
> On Tue, Nov 22, 2022 at 12:38:45PM -0800, Mina Almasry wrote:
> > Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
> > reclaim""), the proactive reclaim interface memory.reclaim does both
> > reclaim and demotion. This is likely fine for us for latency critical
> > jobs where we would want to disable proactive reclaim entirely, and is
> > also fine for latency tolerant jobs where we would like to both
> > proactively reclaim and demote.
> >
> > However, for some latency tiers in the middle we would like to demote but
> > not reclaim. This is because reclaim and demotion incur different latency
> > costs to the jobs in the cgroup. Demoted memory would still be addressable
> > by the userspace at a higher latency, but reclaimed memory would need to
> > incur a pagefault.
> >
> > To address this, I propose having reclaim-only and demotion-only
> > mechanisms in the kernel. There are a couple possible
> > interfaces to carry this out I considered:
> >
> > 1. Disable demotion in the memory.reclaim interface and add a new
> >    demotion interface (memory.demote).
> > 2. Extend memory.reclaim with a "demote=<int>" flag to configure the demotion
> >    behavior in the kernel like so:
> >       - demote=0 would disable demotion from this call.
> >       - demote=1 would allow the kernel to demote if it desires.
> >       - demote=2 would only demote if possible but not attempt any
> >         other form of reclaim.
>
> Unfortunately, our proactive reclaim stack currently relies on
> memory.reclaim doing both. It may not stay like that, but I'm a bit
> wary of changing user-visible semantics post-facto.
>
> In patch 2, you're adding a node interface to memory.demote. Can you
> add this to memory.reclaim instead? This would allow you to control
> demotion and reclaim independently as you please: if you call it on a
> node with demotion targets, it will demote; if you call it on a node
> without one, it'll reclaim. And current users will remain unaffected.

Hello Johannes, thanks for taking a look!

I can certainly add the "nodes=" arg to memory.reclaim and you're
right, that would help in bridging the gap. However, if I understand
the underlying code correctly, with only the nodes= arg the kernel
will indeed attempt demotion first, but the kernel will also merrily
fall back to reclaiming if it can't demote the full amount. I had
hoped to have the flexibility to protect latency sensitive jobs from
reclaim entirely while attempting to do demotion.

There are probably ways to get around that in the userspace. I presume
the userspace can check if there is available memory on the node's
demotion targets, and if so, the kernel should demote-only. But I feel
that wouldn't be reliable as the demotion logic may change across
kernel versions. The userspace may think the kernel would demote but
instead demotion failed due to whatever heuristic introduced into the
new kernel version.

The above is just one angle of the issue. Another angle (which Yosry
would care most about I think) is that at Google we call
memory.reclaim mainly when memory.current is too close to memory.max
and we expect the memory usage of the cgroup to drop as a result of a
success memory.reclaim call. I suspect once we take in commit
3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg reclaim""),
we would run into that regression, but I defer to Yosry here, he may
have a solution for that in mind already.

For these reasons, what do you think about adding both the "nodes="
and "demote=" args from my patch series to memory.reclaim? With these
args the default memory.reclaim behavior would suit meta as-is (no
change) but we would be able to configure it to address our use cases
as well.

As always, thanks for taking the time to review!
