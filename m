From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Mon, 12 Dec 2022 16:54:27 -0800
Message-ID: <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
References: <20221202223533.1785418-1-almasrymina@google.com> <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0Zi3ZzyKkgNoOmYVx10LPKw87VjddBy1CfolqOqRLdM=;
        b=gFj+NaTDEjrbdtpaBG2ekgela1K6vSk06PHME5bYkhlxpLN/TpofHvr+G1qhD6fdVo
         Q48yRVBKQyN3eTdjzONydNVQa/y9AMl8JsKpVBkWTEyxMVVH2l6/8bSXPQ6nMfoaYFrl
         JRa4ASQiKWaHIwAQxgrXNfrmnFtSqfN1Sg9AK5KhNM17J+lNd+IYqFQuV3tWZo7rCc9o
         AJmYC89CvqJsT3AJLyzxhL2kGwNaMjt2y3z93qBrZHXDVhH4Ojb8xWbj0wCmyH9h/KeW
         gs666d/CSjHK5LGAClY2hOgbWj3C7TMMX/h5d42YVIa2rVdiTV/geNGtmz5XyIkb2zEP
         RKbQ==
In-Reply-To: <Y5bsmpCyeryu3Zz1-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Dec 12, 2022 at 12:55 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Fri 02-12-22 14:35:31, Mina Almasry wrote:
> > The nodes= arg instructs the kernel to only scan the given nodes for
> > proactive reclaim. For example use cases, consider a 2 tier memory system:
> >
> > nodes 0,1 -> top tier
> > nodes 2,3 -> second tier
> >
> > $ echo "1m nodes=0" > memory.reclaim
> >
> > This instructs the kernel to attempt to reclaim 1m memory from node 0.
> > Since node 0 is a top tier node, demotion will be attempted first. This
> > is useful to direct proactive reclaim to specific nodes that are under
> > pressure.
> >
> > $ echo "1m nodes=2,3" > memory.reclaim
> >
> > This instructs the kernel to attempt to reclaim 1m memory in the second tier,
> > since this tier of memory has no demotion targets the memory will be
> > reclaimed.
> >
> > $ echo "1m nodes=0,1" > memory.reclaim
> >
> > Instructs the kernel to reclaim memory from the top tier nodes, which can
> > be desirable according to the userspace policy if there is pressure on
> > the top tiers. Since these nodes have demotion targets, the kernel will
> > attempt demotion first.
> >
> > Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
> > reclaim""), the proactive reclaim interface memory.reclaim does both
> > reclaim and demotion. Reclaim and demotion incur different latency costs
> > to the jobs in the cgroup. Demoted memory would still be addressable
> > by the userspace at a higher latency, but reclaimed memory would need to
> > incur a pagefault.
> >
> > The 'nodes' arg is useful to allow the userspace to control demotion
> > and reclaim independently according to its policy: if the memory.reclaim
> > is called on a node with demotion targets, it will attempt demotion first;
> > if it is called on a node without demotion targets, it will only attempt
> > reclaim.
> >
> > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> After discussion in [1] I have realized that I haven't really thought
> through all the consequences of this patch and therefore I am retracting
> my ack here. I am not nacking the patch at this statge but I also think
> this shouldn't be merged now and we should really consider all the
> consequences.
>
> Let me summarize my main concerns here as well. The proposed
> implementation doesn't apply the provided nodemask to the whole reclaim
> process. This means that demotion can happen outside of the mask so the
> the user request cannot really control demotion targets and that limits
> the interface should there be any need for a finer grained control in
> the future (see an example in [2]).
> Another problem is that this can limit future reclaim extensions because
> of existing assumptions of the interface [3] - specify only top-tier
> node to force the aging without actually reclaiming any charges and
> (ab)use the interface only for aging on multi-tier system. A change to
> the reclaim to not demote in some cases could break this usecase.
>

I think this is correct. My use case is to request from the kernel to
do demotion without reclaim in the cgroup, and the reason for that is
stated in the commit message:

"Reclaim and demotion incur different latency costs to the jobs in the
cgroup. Demoted memory would still be addressable by the userspace at
a higher latency, but reclaimed memory would need to incur a
pagefault."

For jobs of some latency tiers, we would like to trigger proactive
demotion (which incurs relatively low latency on the job), but not
trigger proactive reclaim (which incurs a pagefault). I initially had
proposed a separate interface for this, but Johannes directed me to
this interface instead in [1]. In the same email Johannes also tells
me that meta's reclaim stack relies on memory.reclaim triggering
demotion, so it seems that I'm not the first to take a dependency on
this. Additionally in [2] Johannes also says it would be great if in
the long term reclaim policy and demotion policy do not diverge.

[1] https://lore.kernel.org/linux-mm/Y35fw2JSAeAddONg-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
[2] https://lore.kernel.org/linux-mm/Y36fIGFCFKiocAd6-druUgvl0LCNAfugRpC6u6w@public.gmane.org/

> My counter proposal would be to define the nodemask for memory.reclaim
> as a domain to constrain the charge reclaim. That means both aging and
> reclaim including demotion which is a part of aging. This will allow
> to control where to demote for balancing purposes (e.g. demote to node 2
> rather than 3) which is impossible with the proposed scheme.
>

My understanding is that with this interface in order to trigger
demotion I would want to list both the top tier nodes and the bottom
tier nodes on the nodemask, and since the bottom tier nodes are in the
nodemask the kernel will not just trigger demotion, but will also
trigger reclaim. This is very specifically not our use case and not
the goal of this patch.

I had also suggested adding a demotion= arg to memory.reclaim so the
userspace may customize this behavior, but Johannes rejected this in
[3] to adhere to the aging pipeline.

All in all I like Johannes's model in [3] describing the aging
pipeline and the relationship between demotion and reclaim. The nodes=
arg is just a hint to the kernel that the userspace is looking for
reclaim from a top tier node (which would be done by demotion
according to the aging pipeline) or a bottom tier node (which would be
done by reclaim according to the aging pipeline). I think this
interface is aligned with this model.

[3] https://lore.kernel.org/linux-mm/Y36XchdgTCsMP4jT-druUgvl0LCNAfugRpC6u6w@public.gmane.org/

> [1] http://lkml.kernel.org/r/20221206023406.3182800-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
> [2] http://lkml.kernel.org/r/Y5bnRtJ6sojtjgVD-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
> [3] http://lkml.kernel.org/r/CAAPL-u8rgW-JACKUT5ChmGSJiTDABcDRjNzW_QxMjCTk9zO4sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> --
> Michal Hocko
> SUSE Labs
