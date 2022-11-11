From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 15/26] x86/sgx: Add helper to grab pages from an arbitrary EPC LRU
Date: Fri, 11 Nov 2022 10:35:20 -0800
Message-ID: <20221111183532.3676646-16-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191768; x=1699727768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ztjZ1lXO5N5qsaAMVTmsTfaoQ2t8XkFBGpOnZicwNo=;
  b=TgBBh/kYsih/e5ziEBSsW36bz0DDQDcAFsqjK0TGP3RghTwJ6R6QdhEG
   k307Vgma/TIbuq3XAAiJgyR7fP2javZPI/aQR0lNWyPt56Mgj5XdfsYu+
   ojUrPBfhAjOo0lN6UxqswD1bXMSx/PuBhTbc5P3hnxYYISSCIIlvttapY
   o0y9av1Mckr1xoVKnJ3bUW+E/jyurI67UFdLYNGfwyb7qAFFKOOmbqcBf
   boaWNJmuuY2hVzr+E2xq1wNj7toco6j3HlxfM9Ut7Y+O8S+ZbuJOtlTHr
   pOpAWbkZ6Yj1EXKcMv89MPDgpgt63aHQona80SmpICKrAF0Oc9MrfVsFj
   A==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Move the isolation loop into a standalone helper, sgx_isolate_pages(),
in preparation for existence of multiple LRUs.  Expose the helper to
other SGX code so that it can be called from the EPC cgroup code, e.g.
to isolate pages from a single cgroup LRU.  Exposing the isolation loop
allows the cgroup iteration logic to be wholly encapsulated within the
cgroup code.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 68 +++++++++++++++++++++-------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 +
 2 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index cb6f57caf24c..f8f1451b0a11 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -280,7 +280,46 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 }
 
 /**
- * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
+ * sgx_isolate_epc_pages() - Isolate pages from an LRU for reclaim
+ * @lru:	LRU from which to reclaim
+ * @nr_to_scan:	Number of pages to scan for reclaim
+ * @dst:	Destination list to hold the isolated pages
+ */
+void sgx_isolate_epc_pages(struct sgx_epc_lru *lru, int *nr_to_scan,
+			   struct list_head *dst)
+{
+	struct sgx_encl_page *encl_page;
+	struct sgx_epc_page *epc_page;
+
+	spin_lock(&lru->lock);
+	for (; *nr_to_scan > 0; --(*nr_to_scan)) {
+		if (list_empty(&lru->reclaimable))
+			break;
+
+		epc_page = sgx_epc_peek_reclaimable(lru);
+		if (!epc_page)
+			break;
+
+		encl_page = epc_page->encl_owner;
+
+		if (WARN_ON_ONCE(!(epc_page->flags & SGX_EPC_PAGE_ENCLAVE)))
+			continue;
+
+		if (kref_get_unless_zero(&encl_page->encl->refcount)) {
+			epc_page->flags |= SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
+			list_move_tail(&epc_page->list, dst);
+		} else {
+			/* The owner is freeing the page, remove it from the
+			 * LRU list
+			 */
+			epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+			list_del_init(&epc_page->list);
+		}
+	}
+	spin_unlock(&lru->lock);
+}
+
+/**
  * sgx_reclaim_epc_pages() - Reclaim EPC pages from the consumers
  * @nr_to_scan:		 Number of EPC pages to scan for reclaim
  * @ignore_age:		 Reclaim a page even if it is young
@@ -305,37 +344,14 @@ static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
 	struct sgx_epc_lru *lru;
 	pgoff_t page_index;
 	LIST_HEAD(iso);
+	int i = 0;
 	int ret;
-	int i;
-
-	spin_lock(&sgx_global_lru.lock);
-	for (i = 0; i < nr_to_scan; i++) {
-		epc_page = sgx_epc_peek_reclaimable(&sgx_global_lru);
-		if (!epc_page)
-			break;
-
-		encl_page = epc_page->encl_owner;
 
-		if (WARN_ON_ONCE(!(epc_page->flags & SGX_EPC_PAGE_ENCLAVE)))
-			continue;
-
-		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
-			epc_page->flags |= SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
-			list_move_tail(&epc_page->list, &iso);
-		} else {
-			/* The owner is freeing the page, remove it from the
-			 * LRU list
-			 */
-			epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
-			list_del_init(&epc_page->list);
-		}
-	}
-	spin_unlock(&sgx_global_lru.lock);
+	sgx_isolate_epc_pages(&sgx_global_lru, &nr_to_scan, &iso);
 
 	if (list_empty(&iso))
 		return 0;
 
-	i = 0;
 	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->encl_owner;
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index ca51b3c7d905..29c37f20792c 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -182,6 +182,8 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
 int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
 int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age);
+void sgx_isolate_epc_pages(struct sgx_epc_lru *lru, int *nr_to_scan,
+			   struct list_head *dst);
 
 void sgx_ipi_cb(void *info);
 
-- 
2.37.3

