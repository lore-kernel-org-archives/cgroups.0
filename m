From: David Rientjes <rientjes@google.com>
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer
 list
Date: Fri, 17 Jan 2020 11:11:04 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001171102590.75824@chino.kir.corp.google.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com> <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com> <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com> <20200117091002.GM19428@dhcp22.suse.cz> <alpine.DEB.2.21.2001170125350.20618@chino.kir.corp.google.com>
 <20200117153839.pcnfomzuaha3dafh@box>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=ddh+J1aNApjVpqxRphFgI91ytuMiQu7DUUqdaf2bvPs=;
        b=DLepnDTOCwEvanSytGMrHpz+NjlAgL2dcwQ39A7BTwc8s8FXc0BaZ7AlHWmcIkt9U9
         sCwIONzWg9+3KzSljhS98LitF3p0pltTBLulgZDkl3msMeZJ2jrgrmWLG6EGUlAVQ1Vv
         QgyeAJSi6uecYBlxuzQG40GSKW165jtPxrSSO5s889P/gq8XFoBW2geGkyzrQ/V8ntJJ
         XMXCVexiShBajVAtI3kqmV4oy15aVW5Im3YeaBaAGctjn3p8SGciD50nMOfQfZgXpLuG
         1lUayirspJWsOtQPQ+LLAq52zCfrBKZJoM0p6m8qNpuBwdy2x8ksgsTLnSwiyFmkqbnX
         dcpw==
In-Reply-To: <20200117153839.pcnfomzuaha3dafh@box>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Fri, 17 Jan 2020, Kirill A. Shutemov wrote:

> > Right, and I don't think that it necessarily is and the second 
> > conditional in Wei's patch will always succeed unless we have raced.  That 
> > patch is for a lock concern but I think Kirill's question has uncovered 
> > something more interesting.
> > 
> > Kirill S would definitely be best to answer Kirill T's question, but from 
> > my understanding when mem_cgroup_move_account() is called with 
> > compound == true that we always have an intact pmd (we never migrate 
> > partial page charges for pages on the deferred split queue with the 
> > current charge migration implementation) and thus the underlying page is 
> > not eligible to be split and shouldn't be on the deferred split queue.
> > 
> > In other words, a page being on the deferred split queue for a memcg 
> > should only happen when it is charged to that memcg.  (This wasn't the 
> > case when we only had per-node split queues.)  I think that's currently 
> > broken in mem_cgroup_move_account() before Wei's patch.
> 
> Right. It's broken indeed.
> 
> We are dealing with anon page here. And it cannot be on deferred list as
> long as it's mapped with PMD. We cannot get compound == true &&
> !list_empty() on the (first) enter to the function. Any PMD-mapped page
> will be put onto deferred by the function. This is wrong.
> 
> The fix is not obvious.
> 
> This comment got in mem_cgroup_move_charge_pte_range() my attention:
> 
> 			/*
> 			 * We can have a part of the split pmd here. Moving it
> 			 * can be done but it would be too convoluted so simply
> 			 * ignore such a partial THP and keep it in original
> 			 * memcg. There should be somebody mapping the head.
> 			 */
> 
> That's exactly the case we care about: PTE-mapped THP that has to be split
> under load. We don't move charge of them between memcgs and therefore we
> should not move the page to different memcg.
> 
> I guess this will do the trick :P
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c5b5f74cfd4d..e87ee4c10f6e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5359,14 +5359,6 @@ static int mem_cgroup_move_account(struct page *page,
>  		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
>  	}
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound && !list_empty(page_deferred_list(page))) {
> -		spin_lock(&from->deferred_split_queue.split_queue_lock);
> -		list_del_init(page_deferred_list(page));
> -		from->deferred_split_queue.split_queue_len--;
> -		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> -	}
> -#endif
>  	/*
>  	 * It is safe to change page->mem_cgroup here because the page
>  	 * is referenced, charged, and isolated - we can't race with
> @@ -5376,16 +5368,6 @@ static int mem_cgroup_move_account(struct page *page,
>  	/* caller should have done css_get */
>  	page->mem_cgroup = to;
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound && list_empty(page_deferred_list(page))) {
> -		spin_lock(&to->deferred_split_queue.split_queue_lock);
> -		list_add_tail(page_deferred_list(page),
> -			      &to->deferred_split_queue.split_queue);
> -		to->deferred_split_queue.split_queue_len++;
> -		spin_unlock(&to->deferred_split_queue.split_queue_lock);
> -	}
> -#endif
> -
>  	spin_unlock_irqrestore(&from->move_lock, flags);
>  
>  	ret = 0;

Yeah, this is what I was thinking as well.  When 
PageTransHuge(page) == true and there's a mapping pmd, the charge gets 
moved but the page shouldn't appear on any deferred split queue; when 
there isn't a mapped pmd, it should already be on a queue but the charge 
doesn't get moved so no change in which queue is needed.

There was no deferred split handling in mem_cgroup_move_account() needed 
for per-node deferred split queues either so this is purely an issue for 
commit 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware") 
so I think we need your patch and it should be annotated for stable 5.4+.
