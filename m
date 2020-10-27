From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 5/5] mm: memcontrol: Simplify the mem_cgroup_page_lruvec
Date: Tue, 27 Oct 2020 16:02:56 +0800
Message-ID: <20201027080256.76497-6-songmuchun@bytedance.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uiglRpBNWkrLFEUzSubzu7HQqvI3OKCdlqP2Lx2y8is=;
        b=P+Nz2tG9WB/qhj+FCO+gcFTyNF1I6MsxBKRw9kmsx8p6kTqOEUDww4WezfUMzA7ids
         ac0Zw4GET/vXhxCf8QG68dkLY5mwIlJRUt9Gm+jLihmcX0NoOz+Cp5twgR8DGsYW67qd
         PZLKcV4nEUGWtiN0RpyT1yxo4Vpm4Vkn4poFL4T2cKC8G6zrJxeA05Boleywdh/UF3ZC
         mRUnhoac0MFVouztQxbXWFTjsi/iFZUkv7BWXoxoXhK2tMu9Ey2RFTz7zACV5EhVfAwX
         vnFuZ5csx1UlaEVc6ELswrsJ5ZO+KZAEF/R9wChhpmuL/z63EgKtfFu5WfRU6MxRFo7g
         u0PA==
In-Reply-To: <20201027080256.76497-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

We can reuse the code of mem_cgroup_lruvec() to simplify the code
of the mem_cgroup_page_lruvec().

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/memcontrol.h | 44 +++++++++++++++++++++++++++-----------
 mm/memcontrol.c            | 40 ----------------------------------
 2 files changed, 32 insertions(+), 52 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 95807bf6be64..5e8480e54cd8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -451,16 +451,9 @@ mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
 	return memcg->nodeinfo[nid];
 }
 
-/**
- * mem_cgroup_lruvec - get the lru list vector for a memcg & node
- * @memcg: memcg of the wanted lruvec
- *
- * Returns the lru list vector holding pages for a given @memcg &
- * @node combination. This can be the node lruvec, if the memory
- * controller is disabled.
- */
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
-					       struct pglist_data *pgdat)
+static inline struct lruvec *mem_cgroup_node_lruvec(struct mem_cgroup *memcg,
+						    struct pglist_data *pgdat,
+						    int nid)
 {
 	struct mem_cgroup_per_node *mz;
 	struct lruvec *lruvec;
@@ -473,7 +466,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+	mz = mem_cgroup_nodeinfo(memcg, nid);
 	lruvec = &mz->lruvec;
 out:
 	/*
@@ -486,7 +479,34 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
 	return lruvec;
 }
 
-struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
+/**
+ * mem_cgroup_lruvec - get the lru list vector for a memcg & node
+ * @memcg: memcg of the wanted lruvec
+ *
+ * Returns the lru list vector holding pages for a given @memcg &
+ * @node combination. This can be the node lruvec, if the memory
+ * controller is disabled.
+ */
+static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+					       struct pglist_data *pgdat)
+{
+	return mem_cgroup_node_lruvec(memcg, pgdat, pgdat->node_id);
+}
+
+/**
+ * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
+ * @page: the page
+ * @pgdat: pgdat of the page
+ *
+ * This function relies on page->mem_cgroup being stable - see the
+ * access rules in commit_charge().
+ */
+static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
+						    struct pglist_data *pgdat)
+{
+	return mem_cgroup_node_lruvec(page->mem_cgroup, pgdat,
+				      page_to_nid(page));
+}
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 70345b15b150..7097f3fc4dee 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1332,46 +1332,6 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 	return ret;
 }
 
-/**
- * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
- * @page: the page
- * @pgdat: pgdat of the page
- *
- * This function relies on page->mem_cgroup being stable - see the
- * access rules in commit_charge().
- */
-struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
-{
-	struct mem_cgroup_per_node *mz;
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	if (mem_cgroup_disabled()) {
-		lruvec = &pgdat->__lruvec;
-		goto out;
-	}
-
-	memcg = page->mem_cgroup;
-	/*
-	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.
-	 */
-	if (!memcg)
-		memcg = root_mem_cgroup;
-
-	mz = mem_cgroup_page_nodeinfo(memcg, page);
-	lruvec = &mz->lruvec;
-out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->zone here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->pgdat != pgdat))
-		lruvec->pgdat = pgdat;
-	return lruvec;
-}
-
 /**
  * mem_cgroup_update_lru_size - account for adding or removing an lru page
  * @lruvec: mem_cgroup per zone lru vector
-- 
2.20.1

