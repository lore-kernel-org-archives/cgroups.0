From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 15/28] x86/sgx: Add helper to grab pages from an arbitrary EPC LRU
Date: Wed, 12 Jul 2023 16:01:49 -0700
Message-ID: <20230712230202.47929-16-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202935; x=1720738935;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tA0QQdRKFxwvJ3GfeRZ7KDjSQ0meiTP93JAaft2AeWw=;
  b=agrHstpKriBNmRDcJB6E1/yRtxsSES7TORHQEMeifhhBn319tUlzQlJZ
   moZHBLqMzGTGT8+aVE3BAqeLTkOWr06uHXAnczVABySpIB7MlD/0qWdjX
   aWTyy7wsB0z2Fu923FaKuEtLiBLs3W4/qHwacdxp0hkIT1m8pauUbrl3p
   oRIENHi6Lts1RzNaytfJaBWUPgJUXXnLg9r4qwCQ+PFT4TjdVekNOWm3a
   ipD+1VIBMaKr//ZSAOLB0mYei7vFp40htNH+kwRG+flqXpyn1quvFg4Fp
   R7+U5+mP+aSWwcZ1HsU2Y8+yaNoKT+MWXbYga3K1BkjaNI377cJ9t0fl+
   A==;
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Move the isolation loop into a helper, sgx_isolate_pages(), in
preparation for existence of multiple LRUs.  Expose the helper to other
SGX code so that it can be called from the EPC cgroup code, e.g.  to
isolate pages from a single cgroup LRU. Exposing the isolation loop
allows the cgroup iteration logic to be wholly encapsulated within the
cgroup code.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 60 +++++++++++++++++++++-------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 ++
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index e9c9e0d97300..883470062514 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -288,6 +288,43 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
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
+		if (WARN_ON_ONCE(!(epc_page->flags & SGX_EPC_OWNER_ENCL_PAGE)))
+			continue;
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
@@ -316,28 +353,7 @@ size_t sgx_reclaim_epc_pages(size_t nr_to_scan, bool ignore_age)
 	size_t ret;
 	size_t i;
 
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
index 98d3b15341b1..25db815f5add 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -176,6 +176,8 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
 int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
 size_t sgx_reclaim_epc_pages(size_t nr_to_scan, bool ignore_age);
+void sgx_isolate_epc_pages(struct sgx_epc_lru_lists *lrus, size_t nr_to_scan,
+			   struct list_head *dst);
 
 void sgx_ipi_cb(void *info);
 
-- 
2.25.1

