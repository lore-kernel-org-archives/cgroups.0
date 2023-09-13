From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 04/18] x86/sgx: Use sgx_epc_lru_lists for existing active page list
Date: Tue, 12 Sep 2023 21:06:21 -0700
Message-ID: <20230913040635.28815-5-haitao.huang@linux.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694578129; x=1726114129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q3XKtro3U1/ep+dm2IKy9vFEYUcWpZyEJlm9hX4sn60=;
  b=X2uL4tVuG5Yq2USAFRotXO0yi2lPy9ffAcyYCtc5e9s2elorfpHt4QP1
   m1FO3jsCmRA5nI8mT8+VqOP1yVO21oOG4dsNBMOvoPzW6HXc96FvSTgBd
   zqc0xdjRZrhe99motMrBRPjb1xQ3QupCPEtP37PFimWMY20jvfrUznWWQ
   p4Ry2H8lFWmuApYhezc1Rb9f1iTpuYYXCQnSstaRfjFz2knxYwJFUTqqy
   U1rgSbcLE51wpBrdEJ0+BX/4eguRZPNG/sp6qFqtDHQG4B7QSiUrqbY+5
   P7452/QIiQJRFtHBV6bg4Xfb7eMLb8h6TaRktsLMWqRZetMWlpXTS22X7
   A==;
In-Reply-To: <20230913040635.28815-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

All EPC pages of enclaves including VA and SECS will be tracked in
sgx_epc_lru_lists structs, one per cgroup. For now just replace the
existing sgx_active_page_list in the reclaimer and its spinlock with a
global sgx_epc_lru_lists struct. VA and SECS pages are still not tracked
at this point but they will be tracked after an unreclaimable LRU list
is added to the sgx_epc_lru_lists struct.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
V4:
- No change, only reordered the patch.

V3:
- Remove usage of list wrapper
---
 arch/x86/kernel/cpu/sgx/main.c | 39 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 166692f2d501..afce51d6e94a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -26,10 +26,9 @@ static DEFINE_XARRAY(sgx_epc_address_space);
 
 /*
  * These variables are part of the state of the reclaimer, and must be accessed
- * with sgx_reclaimer_lock acquired.
+ * with sgx_global_lru.lock acquired.
  */
-static LIST_HEAD(sgx_active_page_list);
-static DEFINE_SPINLOCK(sgx_reclaimer_lock);
+static struct sgx_epc_lru_lists sgx_global_lru;
 
 static atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
 
@@ -304,13 +303,13 @@ static void sgx_reclaim_pages(void)
 	int ret;
 	int i;
 
-	spin_lock(&sgx_reclaimer_lock);
+	spin_lock(&sgx_global_lru.lock);
 	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
-		if (list_empty(&sgx_active_page_list))
+		epc_page = list_first_entry_or_null(&sgx_global_lru.reclaimable,
+						    struct sgx_epc_page, list);
+		if (!epc_page)
 			break;
 
-		epc_page = list_first_entry(&sgx_active_page_list,
-					    struct sgx_epc_page, list);
 		list_del_init(&epc_page->list);
 		encl_page = epc_page->owner;
 
@@ -322,7 +321,7 @@ static void sgx_reclaim_pages(void)
 			 */
 			epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
 	}
-	spin_unlock(&sgx_reclaimer_lock);
+	spin_unlock(&sgx_global_lru.lock);
 
 	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
@@ -345,9 +344,9 @@ static void sgx_reclaim_pages(void)
 		continue;
 
 skip:
-		spin_lock(&sgx_reclaimer_lock);
-		list_add_tail(&epc_page->list, &sgx_active_page_list);
-		spin_unlock(&sgx_reclaimer_lock);
+		spin_lock(&sgx_global_lru.lock);
+		list_add_tail(&epc_page->list, &sgx_global_lru.reclaimable);
+		spin_unlock(&sgx_global_lru.lock);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 
@@ -378,7 +377,7 @@ static void sgx_reclaim_pages(void)
 static bool sgx_should_reclaim(unsigned long watermark)
 {
 	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
-	       !list_empty(&sgx_active_page_list);
+	       !list_empty(&sgx_global_lru.reclaimable);
 }
 
 /*
@@ -430,6 +429,8 @@ static bool __init sgx_page_reclaimer_init(void)
 
 	ksgxd_tsk = tsk;
 
+	sgx_lru_init(&sgx_global_lru);
+
 	return true;
 }
 
@@ -505,10 +506,10 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
  */
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
 {
-	spin_lock(&sgx_reclaimer_lock);
+	spin_lock(&sgx_global_lru.lock);
 	page->flags |= SGX_EPC_PAGE_RECLAIMER_TRACKED;
-	list_add_tail(&page->list, &sgx_active_page_list);
-	spin_unlock(&sgx_reclaimer_lock);
+	list_add_tail(&page->list, &sgx_global_lru.reclaimable);
+	spin_unlock(&sgx_global_lru.lock);
 }
 
 /**
@@ -523,18 +524,18 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
  */
 int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
 {
-	spin_lock(&sgx_reclaimer_lock);
+	spin_lock(&sgx_global_lru.lock);
 	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
 		/* The page is being reclaimed. */
 		if (list_empty(&page->list)) {
-			spin_unlock(&sgx_reclaimer_lock);
+			spin_unlock(&sgx_global_lru.lock);
 			return -EBUSY;
 		}
 
 		list_del(&page->list);
 		page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
 	}
-	spin_unlock(&sgx_reclaimer_lock);
+	spin_unlock(&sgx_global_lru.lock);
 
 	return 0;
 }
@@ -567,7 +568,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		if (list_empty(&sgx_active_page_list))
+		if (list_empty(&sgx_global_lru.reclaimable))
 			return ERR_PTR(-ENOMEM);
 
 		if (!reclaim) {
-- 
2.25.1

