From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 3/3] mm, memcg: inline swap-related functions to improve
 disabled memcg config
Date: Mon, 12 Jul 2021 18:09:34 -0700
Message-ID: <20210713010934.299876-3-surenb@google.com>
References: <20210713010934.299876-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GVgy78Y4XH5cKdFUoC55+OC486NwPMBxiv8zZWv7bfY=;
        b=rTbNMSzuL2c2s+SMmiQn/vo/SmZsGY+OXkBGAmvHywWnVW/URmqQ0RI383JRllnj0g
         /Rgg9ahp4PmJVJfmhYHoDdwgpVoqHOW7CDS7rKPdn0+cGvbn/snoF9GCBhg1uiqWT9qe
         43PBwfiIlYRPZEiXNO6L/bQhFZLTXhl3q1rBuTazBFbrIcS6ashHR8TI3ejZXN/+67qF
         /+fnl5fqxgXZO19rd7/Iv4KOhZTISnV77Hla7Q49CH2r/Hracy8Sa9p7sUx7g69DDiLf
         40gs9q2RTcEOIDoqcVOBMQoSikn/FykSFTUWz1XCCTFAn5AiVv+nfMNeup81sN3KERDA
         fEFg==
In-Reply-To: <20210713010934.299876-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Inline mem_cgroup_try_charge_swap, mem_cgroup_uncharge_swap and
cgroup_throttle_swaprate functions to perform mem_cgroup_disabled static
key check inline before calling the main body of the function. This
minimizes the memcg overhead in the pagefault and exit_mmap paths when
memcgs are disabled using cgroup_disable=memory command-line option.
This change results in ~1% overhead reduction when running PFT test [1]
comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
configuration on an 8-core ARM64 Android device.

[1] https://lkml.org/lkml/2006/8/29/294 also used in mmtests suite

Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 include/linux/swap.h | 26 +++++++++++++++++++++++---
 mm/memcontrol.c      | 14 ++++----------
 mm/swapfile.c        |  5 +----
 3 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6f5a43251593..f30d26b0f71d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -721,7 +721,13 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-extern void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask);
+extern void __cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask);
+static inline  void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__cgroup_throttle_swaprate(page, gfp_mask);
+}
 #else
 static inline void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 {
@@ -730,8 +736,22 @@ static inline void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 
 #ifdef CONFIG_MEMCG_SWAP
 extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
-extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
-extern void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
+extern int __mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
+static inline int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_try_charge_swap(page, entry);
+}
+
+extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
+static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge_swap(entry, nr_pages);
+}
+
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct page *page);
 #else
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6adf50acdbe2..b8aab1900995 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7234,7 +7234,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 }
 
 /**
- * mem_cgroup_try_charge_swap - try charging swap space for a page
+ * __mem_cgroup_try_charge_swap - try charging swap space for a page
  * @page: page being added to swap
  * @entry: swap entry to charge
  *
@@ -7242,16 +7242,13 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 {
 	unsigned int nr_pages = thp_nr_pages(page);
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
-	if (mem_cgroup_disabled())
-		return 0;
-
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
@@ -7287,18 +7284,15 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 }
 
 /**
- * mem_cgroup_uncharge_swap - uncharge swap space
+ * __mem_cgroup_uncharge_swap - uncharge swap space
  * @entry: swap entry to uncharge
  * @nr_pages: the amount of swap space to uncharge
  */
-void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
+void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 {
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 707fa0481bb4..04a0c83f1313 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3773,14 +3773,11 @@ static void free_swap_count_continuations(struct swap_info_struct *si)
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
+void __cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 {
 	struct swap_info_struct *si, *next;
 	int nid = page_to_nid(page);
 
-	if (mem_cgroup_disabled())
-		return;
-
 	if (!(gfp_mask & __GFP_IO))
 		return;
 
-- 
2.32.0.93.g670b81a890-goog

