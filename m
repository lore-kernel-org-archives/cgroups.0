From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 14/18] x86/sgx: Add helper to grab pages from an arbitrary EPC LRU
Date: Fri, 22 Sep 2023 20:06:53 -0700
Message-ID: <20230923030657.16148-15-haitao.huang@linux.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438430; x=1726974430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vokB5ebesnGW9bdWq3wdFib9nSqPQEUUYA5UVblvF4Y=;
  b=i2cyNx7w4OuNrPwnzw90hbwsWjpyzhoRumyUfjQzWf6LPm/c9W0GBFBD
   uSnyBJafNEoKYj+MPifWhivwoFkpIHnGCzW7QKtFEmK5PXFARsea7iwT0
   iDX27Fa6m0O02RR5QEXTSuI3Z1czTgJq8Tp91388jAFl7I1QUawPkJipQ
   Zp3eAzM1DtIp/ftNVe/HBfvs5W/ng4sqDr+pTTNUMCjczHTWlSh5QxaKW
   joSxpRPaBRTEQ+BzXn+rUvdna5hi3NlK7QuzwKVnReQgd62F8WanH57S4
   AXodoRFEE939X2/kWwbe/tMH4V8hjp+KOWpCkzr99R2irodh6cU98DTe6
   w==;
In-Reply-To: <20230923030657.16148-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Move the isolation loop into a helper, sgx_isolate_pages(), in
preparation for existence of multiple LRUs. Expose the helper to other
SGX code so that it can be called from the EPC cgroup code, e.g., to
isolate pages from a single cgroup LRU. Exposing the isolation loop
allows the cgroup iteration logic to be wholly encapsulated within the
cgroup code.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Co-developed-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Co-developed-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
V4:
- No changes other than reordering the patches
---
 arch/x86/kernel/cpu/sgx/main.c | 57 +++++++++++++++++++++-------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 ++
 2 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4e1a3e038db5..b34ad3574c81 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -284,6 +284,40 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	mutex_unlock(&encl->lock);
 }
 
+/**
+ * sgx_isolate_epc_pages() - Isolate pages from an LRU for reclaim
+ * @lru:	LRU from which to reclaim
+ * @nr_to_scan:	Number of pages to scan for reclaim
+ * @dst:	Destination list to hold the isolated pages
+ */
+void sgx_isolate_epc_pages(struct sgx_epc_lru_lists *lru, size_t nr_to_scan,
+			   struct list_head *dst)
+{
+	struct sgx_encl_page *encl_page;
+	struct sgx_epc_page *epc_page;
+
+	spin_lock(&lru->lock);
+	for (; nr_to_scan > 0; --nr_to_scan) {
+		epc_page = list_first_entry_or_null(&lru->reclaimable, struct sgx_epc_page, list);
+		if (!epc_page)
+			break;
+
+		encl_page = epc_page->encl_page;
+
+		if (kref_get_unless_zero(&encl_page->encl->refcount)) {
+			sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
+			list_move_tail(&epc_page->list, dst);
+		} else {
+			/* The owner is freeing the page, remove it from the
+			 * LRU list
+			 */
+			sgx_epc_page_reset_state(epc_page);
+			list_del_init(&epc_page->list);
+		}
+	}
+	spin_unlock(&lru->lock);
+}
+
 /**
  * sgx_reclaim_epc_pages() - Reclaim EPC pages from the consumers
  * @nr_to_scan:		 Number of EPC pages to scan for reclaim
@@ -310,28 +344,7 @@ size_t sgx_reclaim_epc_pages(size_t nr_to_scan, bool ignore_age)
 	LIST_HEAD(iso);
 	size_t ret, i;
 
-	spin_lock(&sgx_global_lru.lock);
-	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
-		epc_page = list_first_entry_or_null(&sgx_global_lru.reclaimable,
-						    struct sgx_epc_page, list);
-		if (!epc_page)
-			break;
-
-		list_del_init(&epc_page->list);
-		encl_page = epc_page->encl_page;
-
-		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
-			sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
-			list_move_tail(&epc_page->list, &iso);
-		} else {
-			/* The owner is freeing the page, remove it from the
-			 * LRU list
-			 */
-			sgx_epc_page_reset_state(epc_page);
-			list_del_init(&epc_page->list);
-		}
-	}
-	spin_unlock(&sgx_global_lru.lock);
+	sgx_isolate_epc_pages(&sgx_global_lru, nr_to_scan, &iso);
 
 	if (list_empty(&iso))
 		return 0;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 7e7f1f36d31e..42075762084c 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -180,6 +180,8 @@ int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
 bool sgx_epc_oom(struct sgx_epc_lru_lists *lrus);
 size_t sgx_reclaim_epc_pages(size_t nr_to_scan, bool ignore_age);
+void sgx_isolate_epc_pages(struct sgx_epc_lru_lists *lrus, size_t nr_to_scan,
+			   struct list_head *dst);
 
 void sgx_ipi_cb(void *info);
 
-- 
2.25.1

