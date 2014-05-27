From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 9/9] mm: memcontrol: rewrite uncharge API
Date: Tue, 27 May 2014 14:59:30 -0400
Message-ID: <20140527185930.GB2878@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-10-git-send-email-hannes@cmpxchg.org>
 <53844220.5040507@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=zO7Z9dRMFOvIk/XeHCueOpL6xc6J6sct0DG7TIsau30=;
	b=pGFszyZxgR7y+7mVAjjNBHdhiY//BmuZTfbskV9t7kigBr4iCbkWfKy9kmjpf4YG/hh7VQ780KrnK3Y2KiYHglPABiKPRjd0OaaUbRQSQVZZAljthH5vpLaD4VXOpVUDd0NwuElu6lGvssgZTQDQ2zNOGnU9lpe/GkM1/L7rgC4=;
Content-Disposition: inline
In-Reply-To: <53844220.5040507@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Kame,

it's been a long time, I hope you're doing well.

On Tue, May 27, 2014 at 04:43:28PM +0900, Kamezawa Hiroyuki wrote:
> (2014/05/01 5:25), Johannes Weiner wrote:
> > The memcg uncharging code that is involved towards the end of a page's
> > lifetime - truncation, reclaim, swapout, migration - is impressively
> > complicated and fragile.
> > 
> > Because anonymous and file pages were always charged before they had
> > their page->mapping established, uncharges had to happen when the page
> > type could be known from the context, as in unmap for anonymous, page
> > cache removal for file and shmem pages, and swap cache truncation for
> > swap pages.  However, these operations also happen well before the
> > page is actually freed, and so a lot of synchronization is necessary:
> > 
> > - On page migration, the old page might be unmapped but then reused,
> >    so memcg code has to prevent an untimely uncharge in that case.
> >    Because this code - which should be a simple charge transfer - is so
> >    special-cased, it is not reusable for replace_page_cache().
> > 
> > - Swap cache truncation happens during both swap-in and swap-out, and
> >    possibly repeatedly before the page is actually freed.  This means
> >    that the memcg swapout code is called from many contexts that make
> >    no sense and it has to figure out the direction from page state to
> >    make sure memory and memory+swap are always correctly charged.
> > 
> > But now that charged pages always have a page->mapping, introduce
> > mem_cgroup_uncharge(), which is called after the final put_page(),
> > when we know for sure that nobody is looking at the page anymore.
> > 
> > For page migration, introduce mem_cgroup_migrate(), which is called
> > after the migration is successful and the new page is fully rmapped.
> > Because the old page is no longer uncharged after migration, prevent
> > double charges by decoupling the page's memcg association (PCG_USED
> > and pc->mem_cgroup) from the page holding an actual charge.  The new
> > bits PCG_MEM and PCG_MEMSW represent the respective charges and are
> > transferred to the new page during migration.
> > 
> > mem_cgroup_migrate() is suitable for replace_page_cache() as well.
> > 
> > Swap accounting is massively simplified: because the page is no longer
> > uncharged as early as swap cache deletion, a new mem_cgroup_swapout()
> > can transfer the page's memory+swap charge (PCG_MEMSW) to the swap
> > entry before the final put_page() in page reclaim.
> > 
> > Finally, because pages are now charged under proper serialization
> > (anon: exclusive; cache: page lock; swapin: page lock; migration: page
> > lock), and uncharged under full exclusion, they can not race with
> > themselves.  Because they are also off-LRU during charge/uncharge,
> > charge migration can not race, with that, either.  Remove the crazily
> > expensive the page_cgroup lock and set pc->flags non-atomically.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> The whole series seems wonderful to me. Thank you.
> I'm not sure whether I have enough good eyes now but this seems good.

Thank you!

> One thing in my mind is batched uncharge rework.
> 
> Because uncharge() is done in final put_page() path, 
> mem_cgroup_uncharge_start()/mem_cgroup_uncharge_end() placement may not be good enough.
> 
> swap.c::release_pages() may be good to have mem_cgroup_uncharge_start()/end().
> (and you may be able to remove unnecessary calls of mem_cgroup_uncharge_start/end())

That's a good point.

I pushed the batch calls from all pagevec_release() callers directly
into release_pages(), which is everyone but shrink_page_list().

THP fallback abort used to do real uncharging, but now only does
cancelling, so it's no longer batched - I removed the batch calls
there as well.  Not optimal, but it should be fine in this slowpath.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
