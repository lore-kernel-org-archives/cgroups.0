From: Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH] memcg: refactor mem_cgroup_resize_limit()
Date: Sun, 4 Jun 2017 12:44:11 -0700
Message-ID: <20170604194411.GB15369@google.com>
References: <20170601230212.30578-1-yuzhao@google.com>
 <7c1be205-837f-30f9-9161-9c8ed4689216@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HAN6Shib896lWdXF+ysWcSqTH0FtrNywl+dQejC1SbM=;
        b=Toi2En0fgnJGFQHIB/5pHeGPJuaxq655MND8MQSz0wEk878U6D3YaYm/5jKcz46gNo
         Rma+wXePEEDEttPnGHN6+LTHTPeYVcQ74w9stlxVSXVcmBwmzlPK3Dang490WPFLbcQc
         t27cBkDhowssuDM7shOYXuRgo+f8p7ORTQerd34K22JGqIGHN7TwCeheLT+9a5lCnxkV
         U4AF3iYrJ1uWfa1BInva0Outlr26IlPV5RQUb6J/r3YGzz52dbS0EDcCY+4LoztcOQmp
         iIJy4Xp/L9DRQiUF45FvahJ3ybGkr0vDYm+RvUWm9V+GGuG7jpzwL9DlQpffw7GyyI77
         o5pg==
Content-Disposition: inline
In-Reply-To: <7c1be205-837f-30f9-9161-9c8ed4689216@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Jun 02, 2017 at 10:32:52AM +0300, Nikolay Borisov wrote:
> 
> 
> On  2.06.2017 02:02, Yu Zhao wrote:
> > mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() have
> > identical logics. Refactor code so we don't need to keep two pieces
> > of code that does same thing.
> > 
> > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > ---
> >  mm/memcontrol.c | 71 +++++++++------------------------------------------------
> >  1 file changed, 11 insertions(+), 60 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 94172089f52f..a4f0daaff704 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2422,13 +2422,14 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
> >  static DEFINE_MUTEX(memcg_limit_mutex);
> >  
> >  static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
> > -				   unsigned long limit)
> > +				   unsigned long limit, bool memsw)
> >  {
> >  	unsigned long curusage;
> >  	unsigned long oldusage;
> >  	bool enlarge = false;
> >  	int retry_count;
> >  	int ret;
> > +	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
> >  
> >  	/*
> >  	 * For keeping hierarchical_reclaim simple, how long we should retry
> > @@ -2438,58 +2439,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
> >  	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
> >  		      mem_cgroup_count_children(memcg);
> >  
> > -	oldusage = page_counter_read(&memcg->memory);
> > -
> > -	do {
> > -		if (signal_pending(current)) {
> > -			ret = -EINTR;
> > -			break;
> > -		}
> > -
> > -		mutex_lock(&memcg_limit_mutex);
> > -		if (limit > memcg->memsw.limit) {
> > -			mutex_unlock(&memcg_limit_mutex);
> > -			ret = -EINVAL;
> > -			break;
> > -		}
> > -		if (limit > memcg->memory.limit)
> > -			enlarge = true;
> > -		ret = page_counter_limit(&memcg->memory, limit);
> > -		mutex_unlock(&memcg_limit_mutex);
> > -
> > -		if (!ret)
> > -			break;
> > -
> > -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true);
> > -
> > -		curusage = page_counter_read(&memcg->memory);
> > -		/* Usage is reduced ? */
> > -		if (curusage >= oldusage)
> > -			retry_count--;
> > -		else
> > -			oldusage = curusage;
> > -	} while (retry_count);
> > -
> > -	if (!ret && enlarge)
> > -		memcg_oom_recover(memcg);
> > -
> > -	return ret;
> > -}
> > -
> > -static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
> > -					 unsigned long limit)
> > -{
> > -	unsigned long curusage;
> > -	unsigned long oldusage;
> > -	bool enlarge = false;
> > -	int retry_count;
> > -	int ret;
> > -
> > -	/* see mem_cgroup_resize_res_limit */
> > -	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
> > -		      mem_cgroup_count_children(memcg);
> > -
> > -	oldusage = page_counter_read(&memcg->memsw);
> > +	oldusage = page_counter_read(counter);
> >  
> >  	do {
> >  		if (signal_pending(current)) {
> > @@ -2498,22 +2448,23 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
> >  		}
> >  
> >  		mutex_lock(&memcg_limit_mutex);
> > -		if (limit < memcg->memory.limit) {
> > +		if (memsw ? limit < memcg->memory.limit :
> > +			    limit > memcg->memsw.limit) {
> 
> No, just no. Please createa a local variable and use that. Using the
> ternary operator in an 'if' statement is just ugly!

Thanks. It is uncommon but seems no aesthetic difference to me. I'll
replace it with an extra variable and resend the patch.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
