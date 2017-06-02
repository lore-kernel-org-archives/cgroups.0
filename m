From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Re: [PATCH] memcg: refactor mem_cgroup_resize_limit()
Date: Fri, 2 Jun 2017 10:32:52 +0300
Message-ID: <7c1be205-837f-30f9-9161-9c8ed4689216@gmail.com>
References: <20170601230212.30578-1-yuzhao@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SU2EZhnxd93hfuAIJr/rsDo4LJcCnC2BlaEv9+KFNgA=;
        b=WX5aRD3NHLabx5/lBrcXT+0OErVPLbPvNdKlRu0m2SMzxc+zS5UBcGObX6lPQkWvey
         6toKhqKK6jneSKl2z5snKe6/xiD+HXRAPLCHKTE7khbUgYajqZMNBrFHFTDzcmE6V8fZ
         2r+5wUEmXCimz/B9ADxtsWaAeKWcThNGoButH2ItHz0eEdrSJcOj6NZKQjMJyMIGFaBe
         RGGdG7+0r8fwszNbr7Lyb/70gaPxsA59h6HZzE94roe9QcXyCCZ6XdGH7FPDRitlcJ+T
         HclGOOmipWuTIeyCE5BUyBTZod81DWODu+lfP72C6N4V+9fjqAc6s5R/wC85lA5QNQN4
         Yjhw==
In-Reply-To: <20170601230212.30578-1-yuzhao@google.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Zhao <yuzhao@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



On  2.06.2017 02:02, Yu Zhao wrote:
> mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() have
> identical logics. Refactor code so we don't need to keep two pieces
> of code that does same thing.
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  mm/memcontrol.c | 71 +++++++++------------------------------------------------
>  1 file changed, 11 insertions(+), 60 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 94172089f52f..a4f0daaff704 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2422,13 +2422,14 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
>  static DEFINE_MUTEX(memcg_limit_mutex);
>  
>  static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
> -				   unsigned long limit)
> +				   unsigned long limit, bool memsw)
>  {
>  	unsigned long curusage;
>  	unsigned long oldusage;
>  	bool enlarge = false;
>  	int retry_count;
>  	int ret;
> +	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
>  
>  	/*
>  	 * For keeping hierarchical_reclaim simple, how long we should retry
> @@ -2438,58 +2439,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
>  		      mem_cgroup_count_children(memcg);
>  
> -	oldusage = page_counter_read(&memcg->memory);
> -
> -	do {
> -		if (signal_pending(current)) {
> -			ret = -EINTR;
> -			break;
> -		}
> -
> -		mutex_lock(&memcg_limit_mutex);
> -		if (limit > memcg->memsw.limit) {
> -			mutex_unlock(&memcg_limit_mutex);
> -			ret = -EINVAL;
> -			break;
> -		}
> -		if (limit > memcg->memory.limit)
> -			enlarge = true;
> -		ret = page_counter_limit(&memcg->memory, limit);
> -		mutex_unlock(&memcg_limit_mutex);
> -
> -		if (!ret)
> -			break;
> -
> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true);
> -
> -		curusage = page_counter_read(&memcg->memory);
> -		/* Usage is reduced ? */
> -		if (curusage >= oldusage)
> -			retry_count--;
> -		else
> -			oldusage = curusage;
> -	} while (retry_count);
> -
> -	if (!ret && enlarge)
> -		memcg_oom_recover(memcg);
> -
> -	return ret;
> -}
> -
> -static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
> -					 unsigned long limit)
> -{
> -	unsigned long curusage;
> -	unsigned long oldusage;
> -	bool enlarge = false;
> -	int retry_count;
> -	int ret;
> -
> -	/* see mem_cgroup_resize_res_limit */
> -	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
> -		      mem_cgroup_count_children(memcg);
> -
> -	oldusage = page_counter_read(&memcg->memsw);
> +	oldusage = page_counter_read(counter);
>  
>  	do {
>  		if (signal_pending(current)) {
> @@ -2498,22 +2448,23 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		}
>  
>  		mutex_lock(&memcg_limit_mutex);
> -		if (limit < memcg->memory.limit) {
> +		if (memsw ? limit < memcg->memory.limit :
> +			    limit > memcg->memsw.limit) {

No, just no. Please createa a local variable and use that. Using the
ternary operator in an 'if' statement is just ugly!

>  			mutex_unlock(&memcg_limit_mutex);
>  			ret = -EINVAL;
>  			break;
>  		}
> -		if (limit > memcg->memsw.limit)
> +		if (limit > counter->limit)
>  			enlarge = true;
> -		ret = page_counter_limit(&memcg->memsw, limit);
> +		ret = page_counter_limit(counter, limit);
>  		mutex_unlock(&memcg_limit_mutex);
>  
>  		if (!ret)
>  			break;
>  
> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, false);
> +		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
>  
> -		curusage = page_counter_read(&memcg->memsw);
> +		curusage = page_counter_read(counter);
>  		/* Usage is reduced ? */
>  		if (curusage >= oldusage)
>  			retry_count--;
> @@ -2975,10 +2926,10 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
>  		}
>  		switch (MEMFILE_TYPE(of_cft(of)->private)) {
>  		case _MEM:
> -			ret = mem_cgroup_resize_limit(memcg, nr_pages);
> +			ret = mem_cgroup_resize_limit(memcg, nr_pages, false);
>  			break;
>  		case _MEMSWAP:
> -			ret = mem_cgroup_resize_memsw_limit(memcg, nr_pages);
> +			ret = mem_cgroup_resize_limit(memcg, nr_pages, true);
>  			break;
>  		case _KMEM:
>  			ret = memcg_update_kmem_limit(memcg, nr_pages);
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
