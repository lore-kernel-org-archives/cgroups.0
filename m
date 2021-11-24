From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Wed, 24 Nov 2021 15:19:15 +0000
Message-ID: <20211124151915.GA6163@haolee.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=VQS9J9ET/JQ+uchySALu/6BIuoEYQrXpV1bknFuamdY=;
        b=fK7/ysA9q+3lIpsi3NA5igDoHT6nob2CncLewzRyhJj7GxHFWBpXYzZck1N0SWi4D6
         jaJ5RUL7SL3WnaYD2oDzS/379y4FSjRtBJaQbE7uAtQ4UZJ1L8ZB2USj7NZhSysju4Jo
         e8t/JSZ3LoDp648sz8zMfd25a3MWpAmxjIsSVuccbIxw7OK+vWsU511Z5CtAF5FbWDeJ
         2EmDdUiVBkvAN052YipJeEXp4N/xVe2RUtkJ4M50ba/10QPJyPw+ljEPP66VSvQhRHP3
         Uu23aHp7jPw5CexlF/OXPRWpfiZ3rckMpllum0MfYvpIqw2ylBOiUbKsYbS7sUaujoZ/
         YK2A==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When several tasks are terminated simultaneously, lots of pages will be
released, which can cause severe spinlock contention. Other tasks which
are running on the same core will be seriously affected. We can yield
cpu to fix this problem.

Signed-off-by: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/memcontrol.h | 26 ++++++++++++++++++++++++++
 mm/memcontrol.c            | 12 ++++++++++++
 mm/swap.c                  |  8 +++++++-
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0c5c403f4be6..b06a5bcfd8f6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -800,6 +800,8 @@ struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 						unsigned long *flags);
+struct lruvec *folio_lruvec_trylock_irqsave(struct folio *folio,
+						unsigned long *flags);
 
 #ifdef CONFIG_DEBUG_VM
 void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio);
@@ -1313,6 +1315,17 @@ static inline struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 	return &pgdat->__lruvec;
 }
 
+static inline struct lruvec *folio_lruvec_trylock_irqsave(struct folio *folio,
+		unsigned long *flagsp)
+{
+	struct pglist_data *pgdat = folio_pgdat(folio);
+
+	if (spin_trylock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp))
+		return &pgdat->__lruvec;
+	else
+		return NULL;
+}
+
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
 		struct mem_cgroup *prev,
@@ -1598,6 +1611,19 @@ static inline struct lruvec *folio_lruvec_relock_irqsave(struct folio *folio,
 	return folio_lruvec_lock_irqsave(folio, flags);
 }
 
+static inline struct lruvec *folio_lruvec_tryrelock_irqsave(struct folio *folio,
+		struct lruvec *locked_lruvec, unsigned long *flags)
+{
+	if (locked_lruvec) {
+		if (folio_matches_lruvec(folio, locked_lruvec))
+			return locked_lruvec;
+
+		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+	}
+
+	return folio_lruvec_trylock_irqsave(folio, flags);
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 781605e92015..b60ba54e2337 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1261,6 +1261,18 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 	return lruvec;
 }
 
+struct lruvec *folio_lruvec_trylock_irqsave(struct folio *folio,
+		unsigned long *flags)
+{
+	struct lruvec *lruvec = folio_lruvec(folio);
+
+	if (spin_trylock_irqsave(&lruvec->lru_lock, *flags)) {
+		lruvec_memcg_debug(lruvec, folio);
+		return lruvec;
+	}
+
+	return NULL;
+}
 /**
  * mem_cgroup_update_lru_size - account for adding or removing an lru page
  * @lruvec: mem_cgroup per zone lru vector
diff --git a/mm/swap.c b/mm/swap.c
index e8c9dc6d0377..91850d51a5a5 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -960,8 +960,14 @@ void release_pages(struct page **pages, int nr)
 		if (PageLRU(page)) {
 			struct lruvec *prev_lruvec = lruvec;
 
-			lruvec = folio_lruvec_relock_irqsave(folio, lruvec,
+retry:
+			lruvec = folio_lruvec_tryrelock_irqsave(folio, lruvec,
 									&flags);
+			if (!lruvec) {
+				cond_resched();
+				goto retry;
+			}
+
 			if (prev_lruvec != lruvec)
 				lock_batch = 0;
 
-- 
2.31.1

