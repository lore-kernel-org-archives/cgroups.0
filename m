From: David Rientjes <rientjes@google.com>
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer
 list
Date: Thu, 16 Jan 2020 14:01:59 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com> <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=3l1bLmmeM9s291uP94O9U/aPjNKzd/SwoB7qzxFa1R0=;
        b=pZIi5sE/9TH17JjoL4l5dJZZrLpm7nc9kqlJkmnnzJuXTFlpU/YTZtduls0CTZLNQm
         E6ll5YpO8ByoE0nF7TJYBSt49NmIhu3tapebJ0GHzTHlrn11c9dfl4pg11YGNTtRTxRR
         g6ct6R0KdTbp94x6U595KvssLi8FgrCtpq3PPgsq7ZGsbVAGcsoE8WV0gRTaMptR7kLu
         Avzv6iRXqtNfuUucdsVE8Dx8aZKT07u4EELR1eoXNKnKFbnCN1FSuHa3xuv9FxuzLVhY
         UCe+3l+fC3JBlJNBgau4SWMziDCNmnvE5ZBSRsIY9lzxnRJqtiLV5b10eh8jS8HfF/jk
         VwwQ==
In-Reply-To: <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Thu, 16 Jan 2020, Kirill Tkhai wrote:

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c5b5f74cfd4d..6450bbe394e2 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
> >  	}
> >  
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -	if (compound && !list_empty(page_deferred_list(page))) {
> > +	if (compound) {
> >  		spin_lock(&from->deferred_split_queue.split_queue_lock);
> > -		list_del_init(page_deferred_list(page));
> > -		from->deferred_split_queue.split_queue_len--;
> > +		if (!list_empty(page_deferred_list(page))) {
> > +			list_del_init(page_deferred_list(page));
> > +			from->deferred_split_queue.split_queue_len--;
> > +		}
> >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> >  	}
> >  #endif
> > @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
> >  	page->mem_cgroup = to;
> >  
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -	if (compound && list_empty(page_deferred_list(page))) {
> > +	if (compound) {
> >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> > -		list_add_tail(page_deferred_list(page),
> > -			      &to->deferred_split_queue.split_queue);
> > -		to->deferred_split_queue.split_queue_len++;
> > +		if (list_empty(page_deferred_list(page))) {
> > +			list_add_tail(page_deferred_list(page),
> > +				      &to->deferred_split_queue.split_queue);
> > +			to->deferred_split_queue.split_queue_len++;
> > +		}
> >  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
> >  	}
> >  #endif
> 
> The patch looks OK for me. But there is another question. I forget, why we unconditionally
> add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
> it was initially in the list? Something like:
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d4394ae4e5be..0be0136adaa6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
>  	struct pglist_data *pgdat;
>  	unsigned long flags;
>  	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
> +	bool split = false;
>  	int ret;
>  	bool anon;
>  
> @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
>  		if (!list_empty(page_deferred_list(page))) {
>  			list_del_init(page_deferred_list(page));
>  			from->deferred_split_queue.split_queue_len--;
> +			split = true;
>  		}
>  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>  	}
> @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
>  	page->mem_cgroup = to;
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound) {
> +	if (compound && split) {
>  		spin_lock(&to->deferred_split_queue.split_queue_lock);
>  		if (list_empty(page_deferred_list(page))) {
>  			list_add_tail(page_deferred_list(page),
> 

I think that's a good point, especially considering that the current code 
appears to unconditionally place any compound page on the deferred split 
queue of the destination memcg.  The correct list that it should appear 
on, I believe, depends on whether the pmd has been split for the process 
being moved: note the MC_TARGET_PAGE caveat in 
mem_cgroup_move_charge_pte_range() that does not move the charge for 
compound pages with split pmds.  So when mem_cgroup_move_account() is 
called with compound == true, we're moving the charge of the entire 
compound page: why would it appear on that memcg's deferred split queue?
