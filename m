From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-next] mm/memcontrol.c: Fix potential uninitialized variable warning
Date: Wed, 26 May 2021 15:36:02 -0400
Message-ID: <20210526193602.8742-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622057791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lvXIzW1vboiHDAOnYTe4b5RTNGtYwyUKmFA6LenTEYg=;
        b=XzjstuFw0W+1Gegcc64NyEjxfe+peoxq/ghdk3LAg+7TUEfxd+o41+1rmPTuXfOvKg6o8P
        QoKzzeWlXlzAkX//WI5gRdklqKeeMksmu4N/hgO+zTlLpgV7LLuoEWjwf4d6eCL9cjDrRH
        poIhyAJ//1ZjpwkC/DUdHtEBO87asu8=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

If the -Wno-maybe-uninitialized gcc option is not specified, compilation
of memcontrol.c may generate the following warnings:

mm/memcontrol.c: In function ‘refill_obj_stock’:
./arch/x86/include/asm/irqflags.h:127:17: warning: ‘flags’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  return !(flags & X86_EFLAGS_IF);
          ~~~~~~~^~~~~~~~~~~~~~~~
mm/memcontrol.c:3216:16: note: ‘flags’ was declared here
  unsigned long flags;
                ^~~~~
In file included from mm/memcontrol.c:29:
mm/memcontrol.c: In function ‘uncharge_page’:
./include/linux/memcontrol.h:797:2: warning: ‘objcg’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  percpu_ref_put(&objcg->refcnt);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix that by properly initializing *pflags in get_obj_stock() and
introducing a use_objcg bool variable in uncharge_page() to avoid
potentially accessing the struct page data twice.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cb864f87b01d..b9a6db6a7d4f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2108,6 +2108,7 @@ static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
 	struct memcg_stock_pcp *stock;
 
 	if (likely(in_task())) {
+		*pflags = 0UL;
 		preempt_disable();
 		stock = this_cpu_ptr(&memcg_stock);
 		return &stock->task_obj;
@@ -6840,6 +6841,7 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 	unsigned long nr_pages;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	bool use_objcg = PageMemcgKmem(page);
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
@@ -6848,7 +6850,7 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 	 * page memcg or objcg at this point, we have fully
 	 * exclusive access to the page.
 	 */
-	if (PageMemcgKmem(page)) {
+	if (use_objcg) {
 		objcg = __page_objcg(page);
 		/*
 		 * This get matches the put at the end of the function and
@@ -6876,7 +6878,7 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 
 	nr_pages = compound_nr(page);
 
-	if (PageMemcgKmem(page)) {
+	if (use_objcg) {
 		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
 
-- 
2.18.1

