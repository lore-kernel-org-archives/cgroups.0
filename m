From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 15/18] mm: memcontrol: make swap tracking an integral
 part of memory control
Date: Thu, 23 Apr 2020 23:01:17 -0400
Message-ID: <20200424030117.GC464082@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-16-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kyzduwWV8InceUnIl0vidH/X3bbDtm0JxJsBZQHUEsg=;
        b=xCajfsFC29zFs0ldyM1nenfzOzJDtFNYbMcgKb1rYjfjosHZZWeWeXnPI+8bxZ2ntm
         XHXSecOpa9F53pVydA37qwBNQQz3IM8/taC9P6tAXhUnpQt/iT4a01qo0tF1UzjpM1pl
         9weajk44I9MEZiCL03RFgeD8nMd6M1w7/fZJVwQ9w0ADRRNU6IYndhE3AF/qOVSxKDnx
         voK4SCOCZVyquDhFXfze9UC5Qoftazh/65yyjBEJeOa43yxDbu4gxT1oLoaN8bh/AsTH
         9tc/JQBlf043Zpg9/w1+sY2RY/7r2b4k7AZyRfSTf+lRVIRzyrXJ5E4L4HDmZr5V+x+J
         G9zA==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-16-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <js1304@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Apr 20, 2020 at 06:11:23PM -0400, Johannes Weiner wrote:
> @@ -6884,9 +6876,6 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  	VM_BUG_ON_PAGE(PageLRU(page), page);
>  	VM_BUG_ON_PAGE(page_count(page), page);
>  
> -	if (!do_memsw_account())
> -		return;
> -
>  	memcg = page->mem_cgroup;
>  
>  	/* Readahead page, never charged */

I messed up here.

mem_cgroup_swapout() must not run on cgroup2, because cgroup2 uses
mem_cgroup_try_charge_swap() instead. Both record a swap entry and
running them both will trigger a VM_BUG_ON() on an existing record.

I'm actually somewhat baffled why this didn't trigger in my
MADV_PAGEOUT -> MADV_WILLNEED swap test. memory.max driven swapout
triggered it right away.

!do_memsw_account() needs to be !cgroup_subsys_on_dfl(memory_cgrp_subsys)

> @@ -6913,7 +6902,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  	if (!mem_cgroup_is_root(memcg))
>  		page_counter_uncharge(&memcg->memory, nr_entries);
>  
> -	if (memcg != swap_memcg) {
> +	if (do_memsw_account() && memcg != swap_memcg) {
>  		if (!mem_cgroup_is_root(swap_memcg))
>  			page_counter_charge(&swap_memcg->memsw, nr_entries);
>  		page_counter_uncharge(&memcg->memsw, nr_entries);

And this can be !cgroup_memory_noswap instead. It'll do the same
thing, but will be clearer.

I'll have it fixed in version 2.

