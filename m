From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/6] mm: memcontrol: per-lruvec stats infrastructure
Date: Sat, 3 Jun 2017 20:50:02 +0300
Message-ID: <20170603175002.GE15130@esperanza>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-6-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q+BTCQzayK1LxEyzedxQ+MeFBxmku32f+1seafEvoxQ=;
        b=SwIR9izCa+TEq+MYXbAy/NZ9rVh8m/KUgGydMxhgKO47QltPCSPKXuP3fyNql1Lv+C
         mktoevOuxEa0Wt3pC3u22rDLCoXMtOMtbfdz3BUyJYCpTeovHYTvi9Ded6RWpwVrTbpn
         Tbv7KrG73340xNmJW7CVT4A9uQKXTXk6V6CHcr+XlyXIZYKR7YD+1TYx2F+D7qXMlwF4
         i9LwkVqm0YHfQAVKHfsZMA+QcEEUct051l/mMmRlY794OvLbpUXK1DK8+0tcStjrWBAQ
         cd2X9c5xoGbE02BxiGMwVGWrAU9L2aCZY17iozBPlDAcEdxmrdfK0g/CrweEU2iR3oNk
         stWQ==
Content-Disposition: inline
In-Reply-To: <20170530181724.27197-6-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, May 30, 2017 at 02:17:23PM -0400, Johannes Weiner wrote:
> lruvecs are at the intersection of the NUMA node and memcg, which is
> the scope for most paging activity.
> 
> Introduce a convenient accounting infrastructure that maintains
> statistics per node, per memcg, and the lruvec itself.
> 
> Then convert over accounting sites for statistics that are already
> tracked in both nodes and memcgs and can be easily switched.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 238 +++++++++++++++++++++++++++++++++++++++------
>  include/linux/vmstat.h     |   1 -
>  mm/memcontrol.c            |   6 ++
>  mm/page-writeback.c        |  15 +--
>  mm/rmap.c                  |   8 +-
>  mm/workingset.c            |   9 +-
>  6 files changed, 225 insertions(+), 52 deletions(-)
> 
...
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9c68a40c83e3..e37908606c0f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4122,6 +4122,12 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>  	if (!pn)
>  		return 1;
>  
> +	pn->lruvec_stat = alloc_percpu(struct lruvec_stat);
> +	if (!pn->lruvec_stat) {
> +		kfree(pn);
> +		return 1;
> +	}
> +
>  	lruvec_init(&pn->lruvec);
>  	pn->usage_in_excess = 0;
>  	pn->on_tree = false;

I don't see the matching free_percpu() anywhere, forget to patch
free_mem_cgroup_per_node_info()?

Other than that and with the follow-up fix applied, this patch
is good IMO.

Acked-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
