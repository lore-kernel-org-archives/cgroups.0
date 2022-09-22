From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 18/20] x86/sgx: Enable EPC cgroup controller in SGX core
Date: Thu, 22 Sep 2022 10:10:55 -0700
Message-ID: <20220922171057.1236139-19-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866814; x=1695402814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9LpMipHIxpgQ5nuRBoedZKsszRldILRxqIiqKR5tFVA=;
  b=R4mDlt96XY/9bKstIPeHbY6VeNGWbGzHJX8AkLoGKy7lwaMwDgSEX+5V
   RQJir0SU2gi87eeoeOaRT1FCCcrXh6etmXu+hMLtIcDvowPWrnKQX8WAk
   YHCs7asdZZKvvh7AFmBRFg/Ih/gkRwgjI9ySyuJHn6N1SErpWzFBj5zH6
   enwD+VVTUvcb1fuBuhTEfzjac+2R2RyP43+AV81NfNPMDC/+y9bCdaSac
   +MlWyPhh165wFLFUcaRyF0zDC9fqvOGtRR9SxYGazQhCNA+BAFiyirbxx
   Ixgx3CoH3VM1aelvcUSs3S4dkH4XhW2AMaY3Hmojrqg/Kx76GEHKRtMiy
   Q==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add the appropriate calls to (un)charge a cgroup during EPC page
allocation and free, and to isolate pages for reclaim based on the
provided cgroup.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/epc_cgroup.c |  2 +-
 arch/x86/kernel/cpu/sgx/main.c       | 65 +++++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/sgx.h        |  7 ++-
 3 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/epc_cgroup.c b/arch/x86/kernel/cpu/sgx/epc_cgroup.c
index 0a61bb8548ff..71da3b499950 100644
--- a/arch/x86/kernel/cpu/sgx/epc_cgroup.c
+++ b/arch/x86/kernel/cpu/sgx/epc_cgroup.c
@@ -396,7 +396,7 @@ static int sgx_epc_cgroup_reclaim_pages(unsigned long nr_pages,
 	nr_pages = max(nr_pages, SGX_EPC_RECLAIM_MIN_PAGES);
 	nr_pages = min(nr_pages, SGX_EPC_RECLAIM_MAX_PAGES);
 
-	return sgx_reclaim_epc_pages(nr_pages, rc->ignore_age);
+	return sgx_reclaim_epc_pages(nr_pages, rc->ignore_age, rc->epc_cg);
 }
 
 static int sgx_epc_cgroup_reclaim_failed(struct sgx_epc_reclaim_control *rc)
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 082c08228840..29653a0d4670 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -17,6 +17,7 @@
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
+#include "epc_cgroup.h"
 
 #define SGX_MAX_NR_TO_RECLAIM	32
 
@@ -33,6 +34,10 @@ static DEFINE_XARRAY(sgx_epc_address_space);
 static struct sgx_epc_lru sgx_global_lru;
 static inline struct sgx_epc_lru *sgx_lru(struct sgx_epc_page *epc_page)
 {
+#ifdef CONFIG_CGROUP_SGX_EPC
+	if (epc_page->epc_cg)
+		return &epc_page->epc_cg->lru;
+#endif
 	return &sgx_global_lru;
 }
 
@@ -321,6 +326,7 @@ void sgx_isolate_epc_pages(struct sgx_epc_lru *lru, int *nr_to_scan,
  * sgx_reclaim_epc_pages() - Reclaim EPC pages from the consumers
  * @nr_to_scan:		Number of EPC pages to scan for reclaim
  * @ignore_age:		Reclaim a page even if it is young
+ * @epc_cg:		EPC cgroup from which to reclaim
  *
  * Take a fixed number of pages from the head of the active page pool and
  * reclaim them to the enclave's private shmem files. Skip the pages, which have
@@ -336,7 +342,8 @@ void sgx_isolate_epc_pages(struct sgx_epc_lru *lru, int *nr_to_scan,
  *
  * Return: number of EPC pages reclaimed
  */
-int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age)
+int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age,
+			  struct sgx_epc_cgroup *epc_cg)
 {
 	struct sgx_backing backing[SGX_MAX_NR_TO_RECLAIM];
 	struct sgx_epc_page *epc_page, *tmp;
@@ -347,8 +354,17 @@ int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age)
 	int i = 0;
 	int ret;
 
-	sgx_isolate_epc_pages(&sgx_global_lru, &nr_to_scan, &iso);
+        /*
+         * If a specific cgroup is not being targetted, take from the global
+         * list first, even when cgroups are enabled.  If there are
+         * pages on the global LRU then they should get reclaimed asap.
+         */
+        if (!IS_ENABLED(CONFIG_CGROUP_SGX_EPC) || !epc_cg)
+                sgx_isolate_epc_pages(&sgx_global_lru, &nr_to_scan, &iso);
 
+#ifdef CONFIG_CGROUP_SGX_EPC
+	sgx_epc_cgroup_isolate_pages(epc_cg, &nr_to_scan, &iso);
+#endif
 	if (list_empty(&iso))
 		goto out;
 
@@ -394,6 +410,12 @@ int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age)
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIM_FLAGS;
 
+#ifdef CONFIG_CGROUP_SGX_EPC
+		if (epc_page->epc_cg) {
+			sgx_epc_cgroup_uncharge(epc_page->epc_cg);
+			epc_page->epc_cg = NULL;
+		}
+#endif
 		sgx_free_epc_page(epc_page);
 	}
 out:
@@ -403,7 +425,11 @@ int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age)
 
 static bool sgx_can_reclaim(void)
 {
+#ifdef CONFIG_CGROUP_SGX_EPC
+	return !sgx_epc_cgroup_lru_empty(NULL);
+#else
 	return !list_empty(&sgx_global_lru.reclaimable);
+#endif
 }
 
 static bool sgx_should_reclaim(unsigned long watermark)
@@ -420,7 +446,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
 void sgx_reclaim_direct(void)
 {
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
-		sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
+		sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false, NULL);
 }
 
 static int ksgxd(void *p)
@@ -446,7 +472,7 @@ static int ksgxd(void *p)
 				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
 
 		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
-			sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
+			sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false, NULL);
 	}
 
 	return 0;
@@ -600,7 +626,13 @@ int sgx_drop_epc_page(struct sgx_epc_page *page)
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 {
 	struct sgx_epc_page *page;
+#ifdef CONFIG_CGROUP_SGX_EPC
+	struct sgx_epc_cgroup *epc_cg;
 
+	epc_cg = sgx_epc_cgroup_try_charge(current->mm, reclaim);
+	if (IS_ERR(epc_cg))
+		return ERR_CAST(epc_cg);
+#endif
 	for ( ; ; ) {
 		page = __sgx_alloc_epc_page();
 		if (!IS_ERR(page)) {
@@ -608,8 +640,10 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		if (!sgx_can_reclaim())
-			return ERR_PTR(-ENOMEM);
+		if (!sgx_can_reclaim()) {
+			page = ERR_PTR(-ENOMEM);
+			break;
+		}
 
 		if (!reclaim) {
 			page = ERR_PTR(-EBUSY);
@@ -621,9 +655,17 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
+		sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false, NULL);
 	}
 
+#ifdef CONFIG_CGROUP_SGX_EPC
+	if (!IS_ERR(page)) {
+		WARN_ON(page->epc_cg);
+		page->epc_cg = epc_cg;
+	} else {
+		sgx_epc_cgroup_uncharge(epc_cg);
+	}
+#endif
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
 		wake_up(&ksgxd_waitq);
 
@@ -654,6 +696,12 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	page->flags = SGX_EPC_PAGE_IS_FREE;
 
 	spin_unlock(&node->lock);
+#ifdef CONFIG_CGROUP_SGX_EPC
+	if (page->epc_cg) {
+		sgx_epc_cgroup_uncharge(page->epc_cg);
+		page->epc_cg = NULL;
+	}
+#endif
 	atomic_long_inc(&sgx_nr_free_pages);
 }
 
@@ -818,6 +866,9 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		section->pages[i].flags = 0;
 		section->pages[i].owner = NULL;
 		section->pages[i].poison = 0;
+#ifdef CONFIG_CGROUP_SGX_EPC
+		section->pages[i].epc_cg = NULL;
+#endif
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index a4c7ee0a4958..3ea96779dd28 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -39,6 +39,7 @@
 					 SGX_EPC_PAGE_RECLAIM_IN_PROGRESS | \
 					 SGX_EPC_PAGE_ENCLAVE | \
 					 SGX_EPC_PAGE_VERSION_ARRAY)
+struct sgx_epc_cgroup;
 
 struct sgx_epc_page {
 	unsigned int section;
@@ -46,6 +47,9 @@ struct sgx_epc_page {
 	u16 poison;
 	void *owner;
 	struct list_head list;
+#ifdef CONFIG_CGROUP_SGX_EPC
+	struct sgx_epc_cgroup *epc_cg;
+#endif
 };
 
 /*
@@ -113,7 +117,8 @@ void sgx_reclaim_direct(void);
 void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
 int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
-int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age);
+int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age,
+			  struct sgx_epc_cgroup *epc_cg);
 void sgx_isolate_epc_pages(struct sgx_epc_lru *lru, int *nr_to_scan,
 			   struct list_head *dst);
 bool sgx_epc_oom(struct sgx_epc_lru *lru);
-- 
2.37.3

