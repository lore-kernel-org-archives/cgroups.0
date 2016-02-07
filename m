From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: memcontrol: drop unnecessary lru locking from
 mem_cgroup_migrate()
Date: Sun, 7 Feb 2016 21:41:00 +0300
Message-ID: <20160207184059.GB19151@esperanza>
References: <1454616467-8994-1-git-send-email-hannes@cmpxchg.org>
 <1454616467-8994-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454616467-8994-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Feb 04, 2016 at 03:07:47PM -0500, Johannes Weiner wrote:
> Migration accounting in the memory controller used to have to handle
> both oldpage and newpage being on the LRU already; fuse's page cache
> replacement used to pass a recycled newpage that had been uncharged
> but not freed and removed from the LRU, and the memcg migration code
> used to uncharge oldpage to "pass on" the existing charge to newpage.
> 
> Nowadays, pages are no longer uncharged when truncated from the page
> cache, but rather only at free time, so if a LRU page is recycled in
> page cache replacement it'll also still be charged. And we bail out of
> the charge transfer altogether in that case. Tell commit_charge() that
> we know newpage is not on the LRU, to avoid taking the zone->lru_lock
> unnecessarily from the migration path.
> 
> But also, oldpage is no longer uncharged inside migration. We only use
> oldpage for its page->mem_cgroup and page size, so we don't care about
> its LRU state anymore either. Remove any mention from the kernel doc.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Nit:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae8b81c55685..120118f3ce0a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5483,6 +5483,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 	unsigned int nr_pages;
 	bool compound;
 
+	VM_BUG_ON_PAGE(PageLRU(newpage), newpage);
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
