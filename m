From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 08/18] x86/sgx: Use a list to track to-be-reclaimed pages
Date: Tue, 12 Sep 2023 21:06:25 -0700
Message-ID: <20230913040635.28815-9-haitao.huang@linux.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694578132; x=1726114132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2PsYQ63FO9gKjJV2WD5fndgBtRRQxs63BhKeT1YL4QI=;
  b=Y+aA71W8qFfmCh7THPvt56RUyK9R+QNcGbbLMp2LO4Z0VnazN6mcjxcJ
   A+rvrymFhg0cZZCom8gVEw6yfsZpty04jou8+blf2KuL9lsvdcbUt7a1z
   bcDJTciO7Oux8OZVUExY7tPqf5gPiFmX7Z+mwlUaorN1Ypz52nj7ZEHam
   Hfn/H0ROV9G4rh9MsoqG1u1PjKs3kvjqjegG3vcvH2r7Lb/8ASrUHCs9K
   TMuc6CIf6HiBoElOID5qSNCx7U838IFoD4GdXVCMTSlmcmIGNmnd3TS5U
   uDFvou0WJCnuhjSQRC23Sme3Z+LjZ+vEFv0h1myPDgd13zUBeaVeyJm9f
   A==;
In-Reply-To: <20230913040635.28815-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Change sgx_reclaim_pages() to use a list rather than an array for
storing the epc_pages which will be reclaimed. This change is needed
to transition to the LRU implementation for EPC cgroup support.

When the EPC cgroup is implemented, the reclaiming process will do a
pre-order tree walk for the subtree starting from the limit-violating
cgroup.  When each node is visited, candidate pages are selected from
its "reclaimable" LRU list and moved into this temporary list. Passing a
list from node to node for temporary storage in this walk is more
straightforward than using an array.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang<haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
V4:
- Changes needed for patch reordering
- Revised commit message

V3:
- Removed list wrappers
---
 arch/x86/kernel/cpu/sgx/main.c | 40 +++++++++++++++-------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c1ae19a154d0..fba06dc5abfe 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -293,12 +293,11 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  */
 static void sgx_reclaim_pages(void)
 {
-	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
 	struct sgx_backing backing[SGX_NR_TO_SCAN];
+	struct sgx_epc_page *epc_page, *tmp;
 	struct sgx_encl_page *encl_page;
-	struct sgx_epc_page *epc_page;
 	pgoff_t page_index;
-	int cnt = 0;
+	LIST_HEAD(iso);
 	int ret;
 	int i;
 
@@ -314,18 +313,22 @@ static void sgx_reclaim_pages(void)
 
 		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
 			sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
-			chunk[cnt++] = epc_page;
+			list_move_tail(&epc_page->list, &iso);
 		} else {
-			/* The owner is freeing the page. No need to add the
-			 * page back to the list of reclaimable pages.
+			/* The owner is freeing the page, remove it from the
+			 * LRU list
 			 */
 			sgx_epc_page_reset_state(epc_page);
+			list_del_init(&epc_page->list);
 		}
 	}
 	spin_unlock(&sgx_global_lru.lock);
 
-	for (i = 0; i < cnt; i++) {
-		epc_page = chunk[i];
+	if (list_empty(&iso))
+		return;
+
+	i = 0;
+	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->owner;
 
 		if (!sgx_reclaimer_age(epc_page))
@@ -340,6 +343,7 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 		}
 
+		i++;
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -347,27 +351,19 @@ static void sgx_reclaim_pages(void)
 skip:
 		spin_lock(&sgx_global_lru.lock);
 		sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIMABLE);
-		list_add_tail(&epc_page->list, &sgx_global_lru.reclaimable);
+		list_move_tail(&epc_page->list, &sgx_global_lru.reclaimable);
 		spin_unlock(&sgx_global_lru.lock);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
-
-		chunk[i] = NULL;
-	}
-
-	for (i = 0; i < cnt; i++) {
-		epc_page = chunk[i];
-		if (epc_page)
-			sgx_reclaimer_block(epc_page);
 	}
 
-	for (i = 0; i < cnt; i++) {
-		epc_page = chunk[i];
-		if (!epc_page)
-			continue;
+	list_for_each_entry(epc_page, &iso, list)
+		sgx_reclaimer_block(epc_page);
 
+	i = 0;
+	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->owner;
-		sgx_reclaimer_write(epc_page, &backing[i]);
+		sgx_reclaimer_write(epc_page, &backing[i++]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		sgx_epc_page_reset_state(epc_page);
-- 
2.25.1

