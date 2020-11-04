From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v20 00/20] per memcg lru lock
Date: Wed, 4 Nov 2020 19:55:39 +0800
Message-ID: <811216d4-4972-4721-d6b9-1028c02f4290@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1603968305-8026-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi Johannes & all,

Thanks for all comments and suggestions, here is a patch base on v20, as a summary for all you suggested:
Is this ok?

Many thanks!
Alex

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0c97292834fa..0fe4172c8c14 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -20,6 +20,9 @@
  * Lockless page tracking & accounting
  * Unified hierarchy configuration model
  * Copyright (C) 2015 Red Hat, Inc., Johannes Weiner
+ *
+ * Per memcg lru locking
+ * Copyright (C) 2020 Alibaba, Inc, Alex Shi
  */

 #include <linux/page_counter.h>
@@ -1380,6 +1383,14 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
        return lruvec;
 }

+/**
+ * lock_page_lruvec - return lruvec for the locked page.
+ * @page: the page
+ *
+ * This series functions should be used in either conditions:
+ * PageLRU is cleared or unset
+ * or, page->_refcount is zero
+ */
 struct lruvec *lock_page_lruvec(struct page *page)
 {
        struct lruvec *lruvec;
diff --git a/mm/swap.c b/mm/swap.c
index 9fe5ff9a8111..bcc814de35c4 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -264,6 +264,13 @@ void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
        do {
                unsigned long lrusize;

+               /*
+                * Hold lruvec->lru_lock is safe here, since
+                * 1) The pinned lruvec in reclaim, or
+                * 2) From a pre-LRU page during refault (which also holds the
+                *    rcu lock, so would be safe even if the page was on the LRU
+                *    and could move simultaneously to a new lruvec).
+                */
                spin_lock_irq(&lruvec->lru_lock);
                /* Record cost event */
                if (file)
@@ -355,10 +362,12 @@ static void activate_page(struct page *page)
        struct lruvec *lruvec;

        page = compound_head(page);
-       lruvec = lock_page_lruvec_irq(page);
-       if (PageLRU(page))
+       if (TestClearPageLRU(page)) {
+               lruvec = lock_page_lruvec_irq(page);
                __activate_page(page, lruvec);
-       unlock_page_lruvec_irq(lruvec);
+               unlock_page_lruvec_irq(lruvec);
+               SetPageLRU(page);
+       }
 }
 #endif

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7ed10ade548d..af03a7f2e1b8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1868,6 +1868,10 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
                        continue;
                }

+               /*
+                * All pages were isolated from the same lruvec (and isolation
+                * inhibits memcg migration).
+                */
                VM_BUG_ON_PAGE(!lruvec_holds_page_lru_lock(page, lruvec), page);
                lru = page_lru(page);
                nr_pages = thp_nr_pages(page);

