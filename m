From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 08/19] mm: memcontrol: prepare cgroup vmstat infrastructure for native anon counters
Date: Fri,  8 May 2020 14:30:55 -0400
Message-ID: <20200508183105.225460-9-hannes@cmpxchg.org>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OaPQ/6k0L3jh0C6o7CfSb8YWPSRRpIDUVegV83C74dM=;
        b=zsUtCnonxo6Zog/FPVNSwTnBaCeM0640kwri6ouMQy5dP2WS5K0VL3Uvua0clO1WBf
         BRitoPXoqUDeRAN3oCRArMc0i5WyRWV5zibXNnGvLKFsfxZfB46eyMtJ1T+ADLs86OCv
         LZx/kJXhWDmi573Z9v9iEtE7MPuSnPQAeSsW9ktSHlahFKAGyE3tgF/3HMfZppUOuR2T
         vtpeWzPAdHEQDHLQ+DLtQo6+dje3HLAIlF7UMTktdJowPW9vr1UAxTEoHprG65c/iRSm
         pLM0u4C80GxbnbdQrdhxsGROOssrDKHBbDmYIIdnn4iZb4ScmI8zkH0K8z67JNA8P1nt
         w/ww==
In-Reply-To: <20200508183105.225460-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Joonsoo Kim <js1304@gmail.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Anonymous compound pages can be mapped by ptes, which means that if we
want to track NR_MAPPED_ANON, NR_ANON_THPS on a per-cgroup basis, we
have to be prepared to see tail pages in our accounting functions.

Make mod_lruvec_page_state() and lock_page_memcg() deal with tail
pages correctly, namely by redirecting to the head page which has the
page->mem_cgroup set up.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/memcontrol.h | 5 +++--
 mm/memcontrol.c            | 9 ++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 57339514d960..5b110ac7dd83 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -723,16 +723,17 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
 static inline void __mod_lruvec_page_state(struct page *page,
 					   enum node_stat_item idx, int val)
 {
+	struct page *head = compound_head(page); /* rmap on tail pages */
 	pg_data_t *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!page->mem_cgroup) {
+	if (!head->mem_cgroup) {
 		__mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
-	lruvec = mem_cgroup_lruvec(page->mem_cgroup, pgdat);
+	lruvec = mem_cgroup_lruvec(head->mem_cgroup, pgdat);
 	__mod_lruvec_state(lruvec, idx, val);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fe4212db8411..b7be4cd6ddc5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1979,6 +1979,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
  */
 struct mem_cgroup *lock_page_memcg(struct page *page)
 {
+	struct page *head = compound_head(page); /* rmap on tail pages */
 	struct mem_cgroup *memcg;
 	unsigned long flags;
 
@@ -1998,7 +1999,7 @@ struct mem_cgroup *lock_page_memcg(struct page *page)
 	if (mem_cgroup_disabled())
 		return NULL;
 again:
-	memcg = page->mem_cgroup;
+	memcg = head->mem_cgroup;
 	if (unlikely(!memcg))
 		return NULL;
 
@@ -2006,7 +2007,7 @@ struct mem_cgroup *lock_page_memcg(struct page *page)
 		return memcg;
 
 	spin_lock_irqsave(&memcg->move_lock, flags);
-	if (memcg != page->mem_cgroup) {
+	if (memcg != head->mem_cgroup) {
 		spin_unlock_irqrestore(&memcg->move_lock, flags);
 		goto again;
 	}
@@ -2049,7 +2050,9 @@ void __unlock_page_memcg(struct mem_cgroup *memcg)
  */
 void unlock_page_memcg(struct page *page)
 {
-	__unlock_page_memcg(page->mem_cgroup);
+	struct page *head = compound_head(page);
+
+	__unlock_page_memcg(head->mem_cgroup);
 }
 EXPORT_SYMBOL(unlock_page_memcg);
 
-- 
2.26.2

