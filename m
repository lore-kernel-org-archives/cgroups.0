From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: 4.3-rc1 dirty page count underflow (cgroup-related?)
Date: Mon, 21 Sep 2015 01:06:58 -0700
Message-ID: <xr93pp1cmc0t.fsf@gthelen.mtv.corp.google.com>
References: <55FC24C2.8020501@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=references:from:to:cc:subject:in-reply-to:date:message-id
         :mime-version:content-type;
        bh=QoGFW5OMhpl4BbFa8v28QgVqmslIo12qCEf+NtSOs9g=;
        b=FcD5Kgh1UT8fpoXyLesOfxLGovsE6geBmnkAi7PBgITM6bY/GJPjOzrpEYKMg5J+kS
         dHLq9KsjSbUxXZztK5jVUneHjI09uD5L2EDxCMxCS9YaT1voAnoYMEVkU7HKlrhE9wJF
         ZkNkL+m23Gf+rto05jvMG3ZyP33PO2HZDY+HRbtuIRKx+otuMycyyX1LeVtB6qJ9l9A3
         lv8WuDX2iQodcbNTXedq8XzrQLTTiIoyWqGzz8uZIagYalyBUvjzCc50ylZqf7czAUnl
         xMtsVLfaaA/9USeMWsMW64ttmevBCFqhHjsrnroBpT6J/hmrCLQ/OHQGzkS8PRV0NeO9
         u0Qg==
In-reply-to: <55FC24C2.8020501-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Dave Hansen wrote:

> On 09/17/2015 11:09 PM, Greg Thelen wrote:
>> I'm not denying the issue, bug the WARNING splat isn't necessarily
>> catching a problem.  The corresponding code comes from your debug patch:
>> +		WARN_ONCE(__this_cpu_read(memcg->stat->count[MEM_CGROUP_STAT_DIRTY]) > (1UL<<30), "MEM_CGROUP_STAT_DIRTY bogus");
>> 
>> This only checks a single cpu's counter, which can be negative.  The sum
>> of all counters is what matters.
>> Imagine:
>> cpu1) dirty page: inc
>> cpu2) clean page: dec
>> The sum is properly zero, but cpu2 is -1, which will trigger the WARN.
>> 
>> I'll look at the code and also see if I can reproduce the failure using
>> mem_cgroup_read_stat() for all of the new WARNs.
>
> D'oh.  I'll replace those with the proper mem_cgroup_read_stat() and
> test with your patch to see if anything still triggers.

Thanks Dave.

Here's what I think we should use to fix the issue.  I tagged this for
v4.2 stable given the way that unpatched performance falls apart without
warning or workaround (besides deleting and recreating affected memcg).
Feedback welcome.

From f5c39c2e8471c10fe0464ca7b6e6f743ce6920a6 Mon Sep 17 00:00:00 2001
From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date: Sat, 19 Sep 2015 16:21:18 -0700
Subject: [PATCH] memcg: fix dirty page migration

The problem starts with a file backed dirty page which is charged to a
memcg.  Then page migration is used to move oldpage to newpage.
Migration:
- copies the oldpage's data to newpage
- clears oldpage.PG_dirty
- sets newpage.PG_dirty
- uncharges oldpage from memcg
- charges newpage to memcg

Clearing oldpage.PG_dirty decrements the charged memcg's dirty page
count.  However, because newpage is not yet charged, setting
newpage.PG_dirty does not increment the memcg's dirty page count.  After
migration completes newpage.PG_dirty is eventually cleared, often in
account_page_cleaned().  At this time newpage is charged to a memcg so
the memcg's dirty page count is decremented which causes underflow
because the count was not previously incremented by migration.  This
underflow causes balance_dirty_pages() to see a very large unsigned
number of dirty memcg pages which leads to aggressive throttling of
buffered writes by processes in non root memcg.

This issue:
- can harm performance of non root memcg buffered writes.
- can report too small (even negative) values in
  memory.stat[(total_)dirty] counters of all memcg, including the root.

To avoid polluting migrate.c with #ifdef CONFIG_MEMCG checks, introduce
page_memcg() and set_page_memcg() helpers.

Test:
    0) setup and enter limited memcg
    mkdir /sys/fs/cgroup/test
    echo 1G > /sys/fs/cgroup/test/memory.limit_in_bytes
    echo $$ > /sys/fs/cgroup/test/cgroup.procs

    1) buffered writes baseline
    dd if=/dev/zero of=/data/tmp/foo bs=1M count=1k
    sync
    grep ^dirty /sys/fs/cgroup/test/memory.stat

    2) buffered writes with compaction antagonist to induce migration
    yes 1 > /proc/sys/vm/compact_memory &
    rm -rf /data/tmp/foo
    dd if=/dev/zero of=/data/tmp/foo bs=1M count=1k
    kill %
    sync
    grep ^dirty /sys/fs/cgroup/test/memory.stat

    3) buffered writes without antagonist, should match baseline
    rm -rf /data/tmp/foo
    dd if=/dev/zero of=/data/tmp/foo bs=1M count=1k
    sync
    grep ^dirty /sys/fs/cgroup/test/memory.stat

                       (speed, dirty residue)
             unpatched                       patched
    1) 841 MB/s 0 dirty pages          886 MB/s 0 dirty pages
    2) 611 MB/s -33427456 dirty pages  793 MB/s 0 dirty pages
    3) 114 MB/s -33427456 dirty pages  891 MB/s 0 dirty pages

    Notice that unpatched baseline performance (1) fell after
    migration (3): 841 -> 114 MB/s.  In the patched kernel, post
    migration performance matches baseline.

Fixes: c4843a7593a9 ("memcg: add per cgroup dirty page accounting")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.2+
Reported-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/mm.h | 21 +++++++++++++++++++++
 mm/migrate.c       | 12 +++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 91c08f6f0dc9..80001de019ba 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -905,6 +905,27 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 #endif
 }
 
+#ifdef CONFIG_MEMCG
+static inline struct mem_cgroup *page_memcg(struct page *page)
+{
+	return page->mem_cgroup;
+}
+
+static inline void set_page_memcg(struct page *page, struct mem_cgroup *memcg)
+{
+	page->mem_cgroup = memcg;
+}
+#else
+static inline struct mem_cgroup *page_memcg(struct page *page)
+{
+	return NULL;
+}
+
+static inline void set_page_memcg(struct page *page, struct mem_cgroup *memcg)
+{
+}
+#endif
+
 /*
  * Some inline functions in vmstat.h depend on page_zone()
  */
diff --git a/mm/migrate.c b/mm/migrate.c
index c3cb566af3e2..6116b8f64d27 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -740,6 +740,15 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 	if (PageSwapBacked(page))
 		SetPageSwapBacked(newpage);
 
+	/*
+	 * Indirectly called below, migrate_page_copy() copies PG_dirty and thus
+	 * needs newpage's memcg set to transfer memcg dirty page accounting.
+	 * So perform memcg migration in two steps:
+	 * 1. set newpage->mem_cgroup (here)
+	 * 2. clear page->mem_cgroup (below)
+	 */
+	set_page_memcg(newpage, page_memcg(page));
+
 	mapping = page_mapping(page);
 	if (!mapping)
 		rc = migrate_page(mapping, newpage, page, mode);
@@ -756,9 +765,10 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 		rc = fallback_migrate_page(mapping, newpage, page, mode);
 
 	if (rc != MIGRATEPAGE_SUCCESS) {
+		set_page_memcg(newpage, NULL);
 		newpage->mapping = NULL;
 	} else {
-		mem_cgroup_migrate(page, newpage, false);
+		set_page_memcg(page, NULL);
 		if (page_was_mapped)
 			remove_migration_ptes(page, newpage);
 		page->mapping = NULL;
-- 
2.6.0.rc0.131.gf624c3d
