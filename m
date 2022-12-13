From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Tue, 13 Dec 2022 14:30:57 +0800
Message-ID: <87k02volwe.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20221202223533.1785418-1-almasrymina@google.com>
        <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
        <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670913120; x=1702449120;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=RRn4X9Gdnegzf1sgNDrCXchtLeBUYjVOO9r5f4wlFyE=;
  b=AP7hYFzAaexLawNiFKtq3/JiYfE6/BB/yWkckKMj8j2pITxPnOMkJGSr
   tNT03SAebeqnQjXADhBzIEH37T8k5E75kb/LHmwcluXcfKa8SrE1bVVw+
   XpvF2Gg8to1M2RHoQOHjx01TvekRFqxrGUaTxqUW7LApYq+QccAlSZbXj
   KVolPuykPVN5hZKDraPtaoJmoCSgaG7SmFjkixkK6dL0CBQmGaMgLxQha
   011Jn2TnGBzFVLsBToqCZedGGs0j9OHxB0/j26fZbLbR7qEIOJyZRjYi5
   2s1ZWyLqEu20vtlCLWwWl6beunZWpl2Quch7rudgc+PBKyKIG18DkGKqu
   A==;
In-Reply-To: <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
        (Mina Almasry's message of "Mon, 12 Dec 2022 16:54:27 -0800")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Mina Almasry <almasrymina@google.com> writes:

> On Mon, Dec 12, 2022 at 12:55 AM Michal Hocko <mhocko@suse.com> wrote:
>>
>> On Fri 02-12-22 14:35:31, Mina Almasry wrote:
>> > The nodes= arg instructs the kernel to only scan the given nodes for
>> > proactive reclaim. For example use cases, consider a 2 tier memory system:
>> >
>> > nodes 0,1 -> top tier
>> > nodes 2,3 -> second tier
>> >
>> > $ echo "1m nodes=0" > memory.reclaim
>> >
>> > This instructs the kernel to attempt to reclaim 1m memory from node 0.
>> > Since node 0 is a top tier node, demotion will be attempted first. This
>> > is useful to direct proactive reclaim to specific nodes that are under
>> > pressure.
>> >
>> > $ echo "1m nodes=2,3" > memory.reclaim
>> >
>> > This instructs the kernel to attempt to reclaim 1m memory in the second tier,
>> > since this tier of memory has no demotion targets the memory will be
>> > reclaimed.
>> >
>> > $ echo "1m nodes=0,1" > memory.reclaim
>> >
>> > Instructs the kernel to reclaim memory from the top tier nodes, which can
>> > be desirable according to the userspace policy if there is pressure on
>> > the top tiers. Since these nodes have demotion targets, the kernel will
>> > attempt demotion first.
>> >
>> > Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
>> > reclaim""), the proactive reclaim interface memory.reclaim does both
>> > reclaim and demotion. Reclaim and demotion incur different latency costs
>> > to the jobs in the cgroup. Demoted memory would still be addressable
>> > by the userspace at a higher latency, but reclaimed memory would need to
>> > incur a pagefault.
>> >
>> > The 'nodes' arg is useful to allow the userspace to control demotion
>> > and reclaim independently according to its policy: if the memory.reclaim
>> > is called on a node with demotion targets, it will attempt demotion first;
>> > if it is called on a node without demotion targets, it will only attempt
>> > reclaim.
>> >
>> > Acked-by: Michal Hocko <mhocko@suse.com>
>> > Signed-off-by: Mina Almasry <almasrymina@google.com>
>>
>> After discussion in [1] I have realized that I haven't really thought
>> through all the consequences of this patch and therefore I am retracting
>> my ack here. I am not nacking the patch at this statge but I also think
>> this shouldn't be merged now and we should really consider all the
>> consequences.
>>
>> Let me summarize my main concerns here as well. The proposed
>> implementation doesn't apply the provided nodemask to the whole reclaim
>> process. This means that demotion can happen outside of the mask so the
>> the user request cannot really control demotion targets and that limits
>> the interface should there be any need for a finer grained control in
>> the future (see an example in [2]).
>> Another problem is that this can limit future reclaim extensions because
>> of existing assumptions of the interface [3] - specify only top-tier
>> node to force the aging without actually reclaiming any charges and
>> (ab)use the interface only for aging on multi-tier system. A change to
>> the reclaim to not demote in some cases could break this usecase.
>>
>
> I think this is correct. My use case is to request from the kernel to
> do demotion without reclaim in the cgroup, and the reason for that is
> stated in the commit message:
>
> "Reclaim and demotion incur different latency costs to the jobs in the
> cgroup. Demoted memory would still be addressable by the userspace at
> a higher latency, but reclaimed memory would need to incur a
> pagefault."
>
> For jobs of some latency tiers, we would like to trigger proactive
> demotion (which incurs relatively low latency on the job), but not
> trigger proactive reclaim (which incurs a pagefault). I initially had
> proposed a separate interface for this, but Johannes directed me to
> this interface instead in [1]. In the same email Johannes also tells
> me that meta's reclaim stack relies on memory.reclaim triggering
> demotion, so it seems that I'm not the first to take a dependency on
> this. Additionally in [2] Johannes also says it would be great if in
> the long term reclaim policy and demotion policy do not diverge.
>
> [1] https://lore.kernel.org/linux-mm/Y35fw2JSAeAddONg@cmpxchg.org/
> [2] https://lore.kernel.org/linux-mm/Y36fIGFCFKiocAd6@cmpxchg.org/

After these discussion, I think the solution maybe use different
interfaces for "proactive demote" and "proactive reclaim".  That is,
reconsider "memory.demote".  In this way, we will always uncharge the
cgroup for "memory.reclaim".  This avoid the possible confusion there.
And, because demotion is considered aging, we don't need to disable
demotion for "memory.reclaim", just don't count it.

Best Regards,
Huang, Ying
