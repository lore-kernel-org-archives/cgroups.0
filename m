From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] mm: memcontrol: don't allocate cgroup swap arrays
 when memcg is disabled
Date: Fri, 19 Mar 2021 16:33:14 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2103191630090.1043@eggly.anvils>
References: <20210319054944.50048-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=H5VdK/uIKMT1pp4iCjsWX5lLDmAK1g5zh8chc7mIlAc=;
        b=AY3pRnV72+SVoCn6bFK2m3d33V0kl3Xdda5vLh6PNQNNefCcAdDxuiD5hlz3URSd+i
         IVpfjCNBFk7l3OILp3flc1HpKr+lYJewEk2+hdkYf4Anssy+2hawzWNpfP0J4MipfB0G
         K8Zzp7g7MQNL6nWIRfRrOyvtsD0HLMAt8lC/cAY0WhmdMVriYj6dbDBOUzWsxbSW/Eer
         uUdcZ08zjwC4OLH1mQoBs6fBjJstKgjzJb9MLdJpa4cP/B0ZjhqjvY02td2/Xk+LcRDd
         nZckom5APFW679p2UegQaJ14GM8XCvZ2zQS9rWIqW79JELxZOtYzsV2e44iG9zbnfpgC
         uj+Q==
In-Reply-To: <20210319054944.50048-1-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, 19 Mar 2021, Johannes Weiner wrote:

> Since commit 2d1c498072de ("mm: memcontrol: make swap tracking an
> integral part of memory control"), the cgroup swap arrays are used to
> track memory ownership at the time of swap readahead and swapoff, even
> if swap space *accounting* has been turned off by the user via
> swapaccount=0 (which sets cgroup_memory_noswap).
> 
> However, the patch was overzealous: by simply dropping the
> cgroup_memory_noswap conditionals in the swapon, swapoff and uncharge
> path, it caused the cgroup arrays being allocated even when the memory
> controller as a whole is disabled. This is a waste of that memory.
> 
> Restore mem_cgroup_disabled() checks, implied previously by
> cgroup_memory_noswap, in the swapon, swapoff, and swap_entry_free
> callbacks.
> 
> Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Hugh Dickins <hughd@google.com>

Thanks for the memory!

> ---
>  mm/memcontrol.c  | 3 +++
>  mm/swap_cgroup.c | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 668d1d7c2645..49bdcf603af1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7101,6 +7101,9 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
>  	struct mem_cgroup *memcg;
>  	unsigned short id;
>  
> +	if (mem_cgroup_disabled())
> +		return;
> +
>  	id = swap_cgroup_record(entry, 0, nr_pages);
>  	rcu_read_lock();
>  	memcg = mem_cgroup_from_id(id);
> diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
> index 7f34343c075a..08c3246f9269 100644
> --- a/mm/swap_cgroup.c
> +++ b/mm/swap_cgroup.c
> @@ -171,6 +171,9 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
>  	unsigned long length;
>  	struct swap_cgroup_ctrl *ctrl;
>  
> +	if (mem_cgroup_disabled())
> +		return 0;
> +
>  	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
>  	array_size = length * sizeof(void *);
>  
> @@ -206,6 +209,9 @@ void swap_cgroup_swapoff(int type)
>  	unsigned long i, length;
>  	struct swap_cgroup_ctrl *ctrl;
>  
> +	if (mem_cgroup_disabled())
> +		return;
> +
>  	mutex_lock(&swap_cgroup_mutex);
>  	ctrl = &swap_cgroup_ctrl[type];
>  	map = ctrl->map;
> -- 
> 2.30.1
