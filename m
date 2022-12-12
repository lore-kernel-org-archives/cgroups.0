From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Mon, 12 Dec 2022 09:55:54 +0100
Message-ID: <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
References: <20221202223533.1785418-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670835354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TGVOMJbI5VSuu2tCry8NVGy56zUSkKbZBynEIgKf3Ms=;
        b=e7WlOo+Kk87BEbCBNwskXM7yzdzJaKGsFfe8oyqFNEfXIitKdo5y7ay8NCB+3SVFXff3cJ
        GR5vhrP/1xCsq6oCvRi6mNucyOzWGdMku6SHUqxKcvu0y7JCY81V/IY3luS2NOgA/C0S7+
        YTMgtj+HVc6jHmGNR/MARafPRYQAziM=
Content-Disposition: inline
In-Reply-To: <20221202223533.1785418-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 02-12-22 14:35:31, Mina Almasry wrote:
> The nodes= arg instructs the kernel to only scan the given nodes for
> proactive reclaim. For example use cases, consider a 2 tier memory system:
> 
> nodes 0,1 -> top tier
> nodes 2,3 -> second tier
> 
> $ echo "1m nodes=0" > memory.reclaim
> 
> This instructs the kernel to attempt to reclaim 1m memory from node 0.
> Since node 0 is a top tier node, demotion will be attempted first. This
> is useful to direct proactive reclaim to specific nodes that are under
> pressure.
> 
> $ echo "1m nodes=2,3" > memory.reclaim
> 
> This instructs the kernel to attempt to reclaim 1m memory in the second tier,
> since this tier of memory has no demotion targets the memory will be
> reclaimed.
> 
> $ echo "1m nodes=0,1" > memory.reclaim
> 
> Instructs the kernel to reclaim memory from the top tier nodes, which can
> be desirable according to the userspace policy if there is pressure on
> the top tiers. Since these nodes have demotion targets, the kernel will
> attempt demotion first.
> 
> Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
> reclaim""), the proactive reclaim interface memory.reclaim does both
> reclaim and demotion. Reclaim and demotion incur different latency costs
> to the jobs in the cgroup. Demoted memory would still be addressable
> by the userspace at a higher latency, but reclaimed memory would need to
> incur a pagefault.
> 
> The 'nodes' arg is useful to allow the userspace to control demotion
> and reclaim independently according to its policy: if the memory.reclaim
> is called on a node with demotion targets, it will attempt demotion first;
> if it is called on a node without demotion targets, it will only attempt
> reclaim.
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

After discussion in [1] I have realized that I haven't really thought
through all the consequences of this patch and therefore I am retracting
my ack here. I am not nacking the patch at this statge but I also think
this shouldn't be merged now and we should really consider all the
consequences.

Let me summarize my main concerns here as well. The proposed
implementation doesn't apply the provided nodemask to the whole reclaim
process. This means that demotion can happen outside of the mask so the
the user request cannot really control demotion targets and that limits
the interface should there be any need for a finer grained control in
the future (see an example in [2]).
Another problem is that this can limit future reclaim extensions because
of existing assumptions of the interface [3] - specify only top-tier
node to force the aging without actually reclaiming any charges and
(ab)use the interface only for aging on multi-tier system. A change to
the reclaim to not demote in some cases could break this usecase.

My counter proposal would be to define the nodemask for memory.reclaim
as a domain to constrain the charge reclaim. That means both aging and
reclaim including demotion which is a part of aging. This will allow
to control where to demote for balancing purposes (e.g. demote to node 2
rather than 3) which is impossible with the proposed scheme.

[1] http://lkml.kernel.org/r/20221206023406.3182800-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
[2] http://lkml.kernel.org/r/Y5bnRtJ6sojtjgVD-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
[3] http://lkml.kernel.org/r/CAAPL-u8rgW-JACKUT5ChmGSJiTDABcDRjNzW_QxMjCTk9zO4sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
-- 
Michal Hocko
SUSE Labs
