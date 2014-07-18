From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Fri, 18 Jul 2014 10:45:54 -0400
Message-ID: <20140718144554.GG29639@cmpxchg.org>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715082545.GA9366@dhcp22.suse.cz>
 <20140715121935.GB9366@dhcp22.suse.cz>
 <20140718071246.GA21565@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=pG3zYPpOsqDTktmwwle13Kt2T7GpgIS8jOjPhFpvGds=;
	b=ozugXb56Z/3sPWtA5lJ550r1Xwdthwym89WM6dPmbHDh6qMFpDZxM/XD98CYbd1nD2tRGxUSuaWaUm3rOormUoYXKDn2ygJlrrbMmjuGPsZ69hvL+tUtV0uYnEGtcfXZSjjyuK0XGJZvPb2ZTjFa3n+3ckoY/RH8W/733RV+3Yo=;
Content-Disposition: inline
In-Reply-To: <20140718071246.GA21565@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Michal,

[cc'ing Miklos for fuse's use of replace_page_cache()]

On Fri, Jul 18, 2014 at 09:12:46AM +0200, Michal Hocko wrote:
> On Tue 15-07-14 14:19:35, Michal Hocko wrote:
> > [...]
> > > +/**
> > > + * mem_cgroup_migrate - migrate a charge to another page
> > > + * @oldpage: currently charged page
> > > + * @newpage: page to transfer the charge to
> > > + * @lrucare: page might be on LRU already
> > 
> > which one? I guess the newpage?
> > 
> > > + *
> > > + * Migrate the charge from @oldpage to @newpage.
> > > + *
> > > + * Both pages must be locked, @newpage->mapping must be set up.
> > > + */
> > > +void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
> > > +			bool lrucare)
> > > +{
> > > +	unsigned int nr_pages = 1;
> > > +	struct page_cgroup *pc;
> > > +
> > > +	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
> > > +	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
> > > +	VM_BUG_ON_PAGE(PageLRU(oldpage), oldpage);
> > > +	VM_BUG_ON_PAGE(PageLRU(newpage), newpage);
> > 
> > 	VM_BUG_ON_PAGE(PageLRU(newpage) && !lruvec, newpage);
> 
> I guess everything except these two notes got addressed.

Sorry, they fell through the cracks.

Yes, @newpage can already be on the LRU, and it's what @lrucare is
for.  However, you got me thinking about the source page, and so I
went back to replace_page_cache(); and fuse code, which is the only
user of it.

I assumed the source page would always be new, according to this part
in fuse_try_move_page():

	/*
	 * This is a new and locked page, it shouldn't be mapped or
	 * have any special flags on it
	 */
	if (WARN_ON(page_mapped(oldpage)))
		goto out_fallback_unlock;
	if (WARN_ON(page_has_private(oldpage)))
		goto out_fallback_unlock;
	if (WARN_ON(PageDirty(oldpage) || PageWriteback(oldpage)))
		goto out_fallback_unlock;
	if (WARN_ON(PageMlocked(oldpage)))
		goto out_fallback_unlock;

However, it's in the page cache and I can't really convince myself
that it's not also on the LRU.  Miklos, I have trouble pinpointing
where oldpage is instantiated exactly and what state it might be in -
can it already be on the LRU?

If it can, we need to make sure we don't change pc->mem_cgroup while
mem_cgroup_migrate() is looking at it:

---
From c636935736bafa4d6800fe040a0c3cff7ce334ea Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 18 Jul 2014 09:48:42 -0400
Subject: [patch] mm: memcontrol: rewrite uncharge API fix - page cache
 migration

It was known that the target page in migration could be on the LRU -
clarify this in mem_cgroup_migrate() and correct the VM_BUG_ON_PAGE().

However, the source page can also be on the LRU in case of page cache
replacement and there is nothing stabilizing pc->mem_cgroup right now:
grab the page lock in mem_cgroup_move_account() to prevent page cache
replacement from racing with charge moving.

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9db142d83b5c..c9cebf2cf273 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3450,9 +3450,17 @@ static int mem_cgroup_move_account(struct page *page,
 	if (nr_pages > 1 && !PageTransHuge(page))
 		goto out;
 
+	/*
+	 * Prevent mem_cgroup_migrate() from looking at pc->mem_cgroup
+	 * of its source page while we change it: page migration takes
+	 * both pages off the LRU, but page cache replacement doesn't.
+	 */
+	if (!trylock_page(page))
+		goto out;
+
 	ret = -EINVAL;
 	if (!PageCgroupUsed(pc) || pc->mem_cgroup != from)
-		goto out;
+		goto out_unlock;
 
 	move_lock_mem_cgroup(from, &flags);
 
@@ -3487,6 +3495,8 @@ static int mem_cgroup_move_account(struct page *page,
 	mem_cgroup_charge_statistics(from, page, -nr_pages);
 	memcg_check_events(from, page);
 	local_irq_enable();
+out_unlock:
+	unlock_page(page);
 out:
 	return ret;
 }
@@ -6614,7 +6624,7 @@ void mem_cgroup_uncharge_list(struct list_head *page_list)
  * mem_cgroup_migrate - migrate a charge to another page
  * @oldpage: currently charged page
  * @newpage: page to transfer the charge to
- * @lrucare: page might be on LRU already
+ * @lrucare: @newpage might be on LRU already
  *
  * Migrate the charge from @oldpage to @newpage.
  *
@@ -6628,8 +6638,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
-	VM_BUG_ON_PAGE(PageLRU(oldpage), oldpage);
-	VM_BUG_ON_PAGE(PageLRU(newpage), newpage);
+	VM_BUG_ON_PAGE(!lrucare && PageLRU(newpage), newpage);
 	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
 
 	if (mem_cgroup_disabled())
-- 
2.0.0


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
