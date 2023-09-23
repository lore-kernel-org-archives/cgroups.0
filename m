From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 07/18] x86/sgx: Introduce RECLAIM_IN_PROGRESS state
Date: Fri, 22 Sep 2023 20:06:46 -0700
Message-ID: <20230923030657.16148-8-haitao.huang@linux.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438424; x=1726974424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6gXh1rHtrkHSzkPHJy21La79GKdM/hChwBw4+Gb9Byg=;
  b=az+qzZHSkN9xnfdSF71mjpM2TUPQN0TGexiyvj4zL+WcE6kRFBwSOY1x
   bDU+ZLFwz0NEEQ0y0tbdeZglo5kInAk8tYe3j8PFw47LS0P8Q8JseTUk6
   2WZHQybn2y7ISBSgkyDPbnlRgv08CT865sWRTvH59hGOtunMyY2dEzs6X
   /8Ky8jzwrirtx4lquAJLsM2F12ekoI5hleeHLrfkqylgosCoU1fvbprrB
   wLertwiScRz7zQu/SVId8G8eVBD/myYC16jwg6pgKt+xgQ23IKt1hwVhA
   ea8pFbeOkQiCZznr9jNEd4ipGx5FBmPMtVdmr6EfNXJ0vG8IPSSarC1x0
   A==;
In-Reply-To: <20230923030657.16148-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add RECLAIM_IN_PROGRESS state to not rely on list_empty(&epc_page->list)
to determine if an EPC page is selected as a reclaiming candidate.

When a page is being reclaimed from the page pool (sgx_global_lru),
there is an intermediate stage where a page may have been identified as
a candidate for reclaiming, but has not yet been reclaimed.  Currently
such pages are list_del_init()'d from the global LRU list, and stored in
a an array on stack. To prevent another thread from dropping the same
page in the middle of reclaiming, sgx_drop_epc_page() checks for
list_empty(&epc_page->list).

A later patch will replace the array on stack with a temporary list to
store the candidate pages, so list_empty() should no longer be used for
this purpose.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Co-developed-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Co-developed-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
V4:
- Fixed some typos.
- Revised commit message.

V3:
- Extend the sgx_epc_page_state enum introduced earlier to replace the
flag based approach.
---
 arch/x86/kernel/cpu/sgx/main.c | 21 ++++++++++-----------
 arch/x86/kernel/cpu/sgx/sgx.h  | 16 ++++++++++++++++
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b26860399402..c1ae19a154d0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -312,13 +312,15 @@ static void sgx_reclaim_pages(void)
 		list_del_init(&epc_page->list);
 		encl_page = epc_page->owner;
 
-		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
+		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
+			sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
 			chunk[cnt++] = epc_page;
-		else
+		} else {
 			/* The owner is freeing the page. No need to add the
 			 * page back to the list of reclaimable pages.
 			 */
 			sgx_epc_page_reset_state(epc_page);
+		}
 	}
 	spin_unlock(&sgx_global_lru.lock);
 
@@ -528,16 +530,13 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 int sgx_drop_epc_page(struct sgx_epc_page *page)
 {
 	spin_lock(&sgx_global_lru.lock);
-	if (sgx_epc_page_reclaimable(page->flags)) {
-		/* The page is being reclaimed. */
-		if (list_empty(&page->list)) {
-			spin_unlock(&sgx_global_lru.lock);
-			return -EBUSY;
-		}
-
-		list_del(&page->list);
-		sgx_epc_page_reset_state(page);
+	if (sgx_epc_page_reclaim_in_progress(page->flags)) {
+		spin_unlock(&sgx_global_lru.lock);
+		return -EBUSY;
 	}
+
+	list_del(&page->list);
+	sgx_epc_page_reset_state(page);
 	spin_unlock(&sgx_global_lru.lock);
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 2faeb40b345f..764cec23f4e5 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -40,6 +40,8 @@ enum sgx_epc_page_state {
 
 	/* Page is in use and tracked in a reclaimable LRU list
 	 * Becomes NOT_TRACKED after sgx_drop_epc()
+	 * Becomes RECLAIM_IN_PROGRESS in sgx_reclaim_pages() when identified
+	 * for reclaiming
 	 */
 	SGX_EPC_PAGE_RECLAIMABLE = 2,
 
@@ -50,6 +52,14 @@ enum sgx_epc_page_state {
 	 */
 	SGX_EPC_PAGE_UNRECLAIMABLE = 3,
 
+	/* Page is being prepared for reclamation, tracked in a temporary
+	 * isolated list by the reclaimer.
+	 * Changes in sgx_reclaim_pages() back to RECLAIMABLE if preparation
+	 * fails for any reason.
+	 * Becomes NOT_TRACKED if reclaimed successfully in sgx_reclaim_pages()
+	 * and immediately sgx_free_epc() is called to make it FREE.
+	 */
+	SGX_EPC_PAGE_RECLAIM_IN_PROGRESS = 4,
 };
 
 #define SGX_EPC_PAGE_STATE_MASK GENMASK(2, 0)
@@ -73,6 +83,12 @@ static inline void sgx_epc_page_set_state(struct sgx_epc_page *page, unsigned lo
 	page->flags |= (flags & SGX_EPC_PAGE_STATE_MASK);
 }
 
+static inline bool sgx_epc_page_reclaim_in_progress(unsigned long flags)
+{
+	return SGX_EPC_PAGE_RECLAIM_IN_PROGRESS == (flags &
+						    SGX_EPC_PAGE_STATE_MASK);
+}
+
 static inline bool sgx_epc_page_reclaimable(unsigned long flags)
 {
 	return SGX_EPC_PAGE_RECLAIMABLE == (flags & SGX_EPC_PAGE_STATE_MASK);
-- 
2.25.1

