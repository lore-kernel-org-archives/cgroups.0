From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: vmscan: memcontrol: remove
 mem_cgroup_select_victim_node()
Date: Wed, 30 Oct 2019 13:44:55 -0400
Message-ID: <20191030174455.GA45135@cmpxchg.org>
References: <20191029234753.224143-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A6yVuPB6LXuICIv7poxF2BAaptyD1Hihg4TrEeI9+Jw=;
        b=sozm5qleGziX428szkw/H+7If3/x7loBPpt2oW5IYALdZ5UQ01sEahdB3jplMrxsZP
         8fkP990UWGINNKWje1T4f34YF9bVU4CocJAZRe0X6x9G225pyXyZnEYlJCtSHi60PaGA
         8xaOS1bCBt7dv+wXrcuytT6FOgqh2+DWU2Ib/zQKKFJRs7AN/rfFqn8yG/WuHsy+aqSM
         QOxb3zm841f/ZAP+4vCwBLxyu/4qHsWqYzju81lMDLtfsdk7p56sfVOJmU0IcjFYg4fY
         rFXxUpjxn4seusqGZzzFOSmhawfWX3VxePsC9Z5RLg6BdcH4X2d4YiOBfaIKt+nYFuVl
         Ry1g==
Content-Disposition: inline
In-Reply-To: <20191029234753.224143-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Greg Thelen <gthelen@google.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com

On Tue, Oct 29, 2019 at 04:47:53PM -0700, Shakeel Butt wrote:
> Since commit 1ba6fc9af35b ("mm: vmscan: do not share cgroup iteration
> between reclaimers"), the memcg reclaim does not bail out earlier based
> on sc->nr_reclaimed and will traverse all the nodes. All the reclaimable
> pages of the memcg on all the nodes will be scanned relative to the
> reclaim priority. So, there is no need to maintain state regarding which
> node to start the memcg reclaim from. Also KCSAN complains data races in
> the code maintaining the state.
> 
> This patch effectively reverts the commit 889976dbcb12 ("memcg: reclaim
> memory from nodes in round-robin order") and the commit 453a9bf347f1
> ("memcg: fix numa scan information update to be triggered by memory
> event").
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: <syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com>

Excellent, thanks Shakeel!
Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Just a request on this bit:

> @@ -3360,16 +3358,9 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  		.may_unmap = 1,
>  		.may_swap = may_swap,
>  	};
> +	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
>  
>  	set_task_reclaim_state(current, &sc.reclaim_state);
> -	/*
> -	 * Unlike direct reclaim via alloc_pages(), memcg's reclaim doesn't
> -	 * take care of from where we get pages. So the node where we start the
> -	 * scan does not need to be the current node.
> -	 */
> -	nid = mem_cgroup_select_victim_node(memcg);
> -
> -	zonelist = &NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK];

This works, but it *is* somewhat fragile if we decide to add bail-out
conditions to reclaim again. And some numa nodes receiving slightly
less pressure than others could be quite tricky to debug.

Can we add a comment here that points out the assumption that the
zonelist walk is comprehensive, and that all nodes receive equal
reclaim pressure?

Also, I think we should use sc.gfp_mask & ~__GFP_THISNODE, so that
allocations with a physical node preference still do node-agnostic
reclaim for the purpose of cgroup accounting.
