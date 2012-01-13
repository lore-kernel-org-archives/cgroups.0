From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC] [PATCH 6/7 v2] memcg: remove PCG_CACHE
Date: Fri, 13 Jan 2012 17:43:37 +0900
Message-ID: <20120113174337.715fbdfa.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120113173001.ee5260ca.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch can be cut-out from this series as an independent patch.
==
From b3528ad71d56cee417cf6152f98b135f0e8dccce Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Thu, 12 Jan 2012 18:55:10 +0900
Subject: [PATCH 6/7] memcg: remove PCG_CACHE

We record 'the page is cache' by PCG_CACHE bit to page_cgroup.
But at charge/uncharge, the caller should know it and we don't
need to record it by using 1bit per a page.

This patch removes PCG_CACHE bit and make callers to specify
the page is cache or not.

Changelog:
 - make callers to specify page type.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/page_cgroup.h |    4 ----
 mm/memcontrol.c             |   28 ++++++++++++++++++++--------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 0b9a48a..a51ab7c 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -4,7 +4,6 @@
 enum {
 	/* flags for mem_cgroup */
 	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
-	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
 	PCG_MIGRATION, /* under page migration */
 	__NR_PCG_FLAGS,
@@ -62,9 +61,6 @@ static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
 /* Cache flag is set only once (at allocation) */
-TESTPCGFLAG(Cache, CACHE)
-CLEARPCGFLAG(Cache, CACHE)
-SETPCGFLAG(Cache, CACHE)
 
 TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a96800d..8b67ccf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2475,6 +2475,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 				       struct page_cgroup *pc,
 				       enum charge_type ctype)
 {
+	bool file = false;
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
@@ -2497,18 +2498,17 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_CACHE:
 	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
-		SetPageCgroupCache(pc);
+		file = true;
 		SetPageCgroupUsed(pc);
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
-		ClearPageCgroupCache(pc);
 		SetPageCgroupUsed(pc);
 		break;
 	default:
 		break;
 	}
 
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
+	mem_cgroup_charge_statistics(memcg, file, nr_pages);
 	unlock_page_cgroup(pc);
 	WARN_ON_ONCE(PageLRU(page));
 	/*
@@ -2581,6 +2581,7 @@ static int mem_cgroup_move_account(struct page *page,
 {
 	unsigned long flags;
 	int ret;
+	bool file = !PageAnon(page);
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(page));
@@ -2609,14 +2610,14 @@ static int mem_cgroup_move_account(struct page *page,
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
-	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
+	mem_cgroup_charge_statistics(from, file, -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
 		__mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), nr_pages);
+	mem_cgroup_charge_statistics(to, file, nr_pages);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
 	 * can be under rmdir(). But in current implementation, caller of
@@ -2964,6 +2965,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
+	bool file = false;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2990,6 +2992,10 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 		goto unlock_out;
 
 	switch (ctype) {
+	case MEM_CGROUP_CHARGE_TYPE_CACHE:
+	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
+		file = true;
+		break;
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
 		/* See mem_cgroup_prepare_migration() */
@@ -3007,7 +3013,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 		break;
 	}
 
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -nr_pages);
+	mem_cgroup_charge_statistics(memcg, file, -nr_pages);
 
 	ClearPageCgroupUsed(pc);
 	/*
@@ -3048,9 +3054,15 @@ void mem_cgroup_uncharge_page(struct page *page)
 
 void mem_cgroup_uncharge_cache_page(struct page *page)
 {
+	int ctype;
+
 	VM_BUG_ON(page_mapped(page));
 	VM_BUG_ON(page->mapping);
-	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
+	if (page_is_file_cache(page))
+		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
+	else
+		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+	__mem_cgroup_uncharge_common(page, ctype);
 }
 
 /*
@@ -3393,7 +3405,7 @@ void mem_cgroup_replace_page_cache(struct page *oldpage,
 	/* fix accounting on old pages */
 	lock_page_cgroup(pc);
 	memcg = pc->mem_cgroup;
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -1);
+	mem_cgroup_charge_statistics(memcg, true, -1);
 	ClearPageCgroupUsed(pc);
 	unlock_page_cgroup(pc);
 
-- 
1.7.4.1

