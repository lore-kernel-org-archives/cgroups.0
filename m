From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Tue, 13 Dec 2022 14:30:40 +0100
Message-ID: <Y5h+gHBneexFQcR3@cmpxchg.org>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
 <87k02volwe.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GkAga1fPXNCvgWWr0y17vOcwxqzOIKIhEW49YSLUBLs=;
        b=zXfkNNv5mXOMPEanvux+4bWlBQnFuzxE2MzUd22vOUfuSUzuyhRUOfDzB0ggA71T8F
         U4BoSvDNvouPUsFnxzBhZ9PkJKNOOi+r+fWw9vIFexrfG0KwcjqamyWJH78bxvSa+wEK
         sviWJZdff4IfSH7PcbdsfV9IggXAnSU97epnS/d0NovCmFSRag3LxiwLBWEbw0wia48V
         YbDPBVUWD+T8qS9AWX0q7GxruKFPjvBYZuFfVuhZJcW2vVgQJ/wUPa1YAkGfHLEO3TNv
         ut45RL2Pkoauar+k5MQKvHAfX+4LQXjfZ+Tr4d/sXdDmzrGpjYfmw5ayEfmXxR2ffeRd
         2uuQ==
Content-Disposition: inline
In-Reply-To: <87k02volwe.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Dec 13, 2022 at 02:30:57PM +0800, Huang, Ying wrote:
> Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
> 
> > On Mon, Dec 12, 2022 at 12:55 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >>
> >> On Fri 02-12-22 14:35:31, Mina Almasry wrote:
> >> > The nodes= arg instructs the kernel to only scan the given nodes for
> >> > proactive reclaim. For example use cases, consider a 2 tier memory system:
> >> >
> >> > nodes 0,1 -> top tier
> >> > nodes 2,3 -> second tier
> >> >
> >> > $ echo "1m nodes=0" > memory.reclaim
> >> >
> >> > This instructs the kernel to attempt to reclaim 1m memory from node 0.
> >> > Since node 0 is a top tier node, demotion will be attempted first. This
> >> > is useful to direct proactive reclaim to specific nodes that are under
> >> > pressure.
> >> >
> >> > $ echo "1m nodes=2,3" > memory.reclaim
> >> >
> >> > This instructs the kernel to attempt to reclaim 1m memory in the second tier,
> >> > since this tier of memory has no demotion targets the memory will be
> >> > reclaimed.
> >> >
> >> > $ echo "1m nodes=0,1" > memory.reclaim
> >> >
> >> > Instructs the kernel to reclaim memory from the top tier nodes, which can
> >> > be desirable according to the userspace policy if there is pressure on
> >> > the top tiers. Since these nodes have demotion targets, the kernel will
> >> > attempt demotion first.
> >> >
> >> > Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
> >> > reclaim""), the proactive reclaim interface memory.reclaim does both
> >> > reclaim and demotion. Reclaim and demotion incur different latency costs
> >> > to the jobs in the cgroup. Demoted memory would still be addressable
> >> > by the userspace at a higher latency, but reclaimed memory would need to
> >> > incur a pagefault.
> >> >
> >> > The 'nodes' arg is useful to allow the userspace to control demotion
> >> > and reclaim independently according to its policy: if the memory.reclaim
> >> > is called on a node with demotion targets, it will attempt demotion first;
> >> > if it is called on a node without demotion targets, it will only attempt
> >> > reclaim.
> >> >
> >> > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> >> > Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>
> >> After discussion in [1] I have realized that I haven't really thought
> >> through all the consequences of this patch and therefore I am retracting
> >> my ack here. I am not nacking the patch at this statge but I also think
> >> this shouldn't be merged now and we should really consider all the
> >> consequences.
> >>
> >> Let me summarize my main concerns here as well. The proposed
> >> implementation doesn't apply the provided nodemask to the whole reclaim
> >> process. This means that demotion can happen outside of the mask so the
> >> the user request cannot really control demotion targets and that limits
> >> the interface should there be any need for a finer grained control in
> >> the future (see an example in [2]).
> >> Another problem is that this can limit future reclaim extensions because
> >> of existing assumptions of the interface [3] - specify only top-tier
> >> node to force the aging without actually reclaiming any charges and
> >> (ab)use the interface only for aging on multi-tier system. A change to
> >> the reclaim to not demote in some cases could break this usecase.
> >>
> >
> > I think this is correct. My use case is to request from the kernel to
> > do demotion without reclaim in the cgroup, and the reason for that is
> > stated in the commit message:
> >
> > "Reclaim and demotion incur different latency costs to the jobs in the
> > cgroup. Demoted memory would still be addressable by the userspace at
> > a higher latency, but reclaimed memory would need to incur a
> > pagefault."
> >
> > For jobs of some latency tiers, we would like to trigger proactive
> > demotion (which incurs relatively low latency on the job), but not
> > trigger proactive reclaim (which incurs a pagefault). I initially had
> > proposed a separate interface for this, but Johannes directed me to
> > this interface instead in [1]. In the same email Johannes also tells
> > me that meta's reclaim stack relies on memory.reclaim triggering
> > demotion, so it seems that I'm not the first to take a dependency on
> > this. Additionally in [2] Johannes also says it would be great if in
> > the long term reclaim policy and demotion policy do not diverge.
> >
> > [1] https://lore.kernel.org/linux-mm/Y35fw2JSAeAddONg-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
> > [2] https://lore.kernel.org/linux-mm/Y36fIGFCFKiocAd6-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
> 
> After these discussion, I think the solution maybe use different
> interfaces for "proactive demote" and "proactive reclaim".  That is,
> reconsider "memory.demote".  In this way, we will always uncharge the
> cgroup for "memory.reclaim".  This avoid the possible confusion there.
> And, because demotion is considered aging, we don't need to disable
> demotion for "memory.reclaim", just don't count it.

Hm, so in summary:

1) memory.reclaim would demote and reclaim like today, but it would
   change to only count reclaimed pages against the goal.

2) memory.demote would only demote.

   a) What if the demotion targets are full? Would it reclaim or fail?

3) Would memory.reclaim and memory.demote still need nodemasks? Would
   they return -EINVAL if a) memory.reclaim gets passed only toptier
   nodes or b) memory.demote gets passed any lasttier nodes?
