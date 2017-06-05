From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] swap: cond_resched in swap_cgroup_prepare()
Date: Mon, 5 Jun 2017 07:12:07 +0200
Message-ID: <20170605051206.GB9248@dhcp22.suse.cz>
References: <20170601195635.20744-1-yuzhao@google.com>
 <20170604200109.17606-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170604200109.17606-1-yuzhao@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

[CC Andrew]

On Sun 04-06-17 13:01:09, Yu Zhao wrote:
> Saw need_resched() warnings when swapping on large swapfile (TBs)
> because continuously allocating many pages in swap_cgroup_prepare()
> took too long.
> 
> We already cond_resched when freeing page in swap_cgroup_swapoff().
> Do the same for the page allocation.
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
> ---
> Changelog since v1:
> * clarify the problem in the commit message
> 
>  mm/swap_cgroup.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
> index ac6318a064d3..3405b4ee1757 100644
> --- a/mm/swap_cgroup.c
> +++ b/mm/swap_cgroup.c
> @@ -48,6 +48,9 @@ static int swap_cgroup_prepare(int type)
>  		if (!page)
>  			goto not_enough_page;
>  		ctrl->map[idx] = page;
> +
> +		if (!(idx % SWAP_CLUSTER_MAX))
> +			cond_resched();
>  	}
>  	return 0;
>  not_enough_page:
> -- 
> 2.13.0.506.g27d5fe0cd-goog

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
